rm(list=ls())
require(readxl)
require(reshape2)
require(ggplot2)
require(GGally)
require(factoextra)

# Read in Gelman-Rubin RHat results
df.prsf = data.frame(read_xlsx('2020-10-19_MCMCSTATmprsf_Diagnostics.xlsx')
                     , stringsAsFactors = F, row.names = 1)

# Constraints
df.constraints = data.frame(read_xlsx('2020-10-19_MCMCSTAT_constraints.xlsx')
                            , stringsAsFactors = F, row.names = 1)

# Read in chain summaries. Nested because I'm bad at regex 
v.chains = grep(value = T, list.files(path = 'OUTPUT/', pattern = '2020-10-07')
                , pattern='chains.csv')

# Read in chains
ls.chains = sapply(v.chains, function(x){
  REGION = strsplit(x, '_')[[1]][2]
  
  # Read in csv 
  res = read.csv(paste("OUTPUT/", x, sep='', collapse = ''))
  
  # Data-frame
  res = as.data.frame(res) 
  
  # Remove last column of NA's since I'm also bad at writing matlab outputs
  res = res[,-ncol(res)]
  
  # Add positions
  res$idx = 1:(table(res$i_chain)[1])
  
  # add region
  res$region = REGION
  
  # Return  
  list(res)
})
names(ls.chains) = sapply(names(ls.chains)
                          , function(x) strsplit(x, '_')[[1]][2])

# Summarize chains
ls.summary = lapply(ls.chains, function(x){
  
})

# Side-note... maybe I can PCA this to see unidentifiability?
region = 'wash'
test = t(do.call('cbind', split(ls.chains[[region]][,1:6], ls.chains[[region]]$i_chain)))
v.hab = sapply(rownames(test), function(x){strsplit(x, '\\.')[[1]][2]})

df.pcs = prcomp(test)
fviz_pca_ind(df.pcs, geom.ind = 'point', habillage = v.hab, addEllipses = T)


# (1) Pairplots -----------------------------------------------------------

# Contours
if(F){
  for(region in c('wash', 'sflor', 'nyc')){
    for(i in 1:11){
      test = ls.chains[[region]]
      # if(region == 'wash'){
      #   test = test[test$i_chain != 4,]
      # }
      test = test[test$i_chain == i,1:6]
      
      p_pairs = ggpairs(test, lower = list(continuous = "density"))
      
      # Combinations
      v.names = 1:ncol(test)
      names(v.names) = colnames(test)
      
      v.combs = t(combn(v.names, 2))
      for(j in 1:nrow(v.combs)){
        j_comb = v.combs[j,]
        
        p_pairs[j_comb[2], j_comb[1]] = p_pairs[j_comb[2], j_comb[1]] + 
          scale_x_continuous(limits=c(df.constraints[j_comb[1]][1,1]
                                      , df.constraints[j_comb[1]][2,1])) + 
          scale_y_continuous(limit=c(df.constraints[j_comb[2]][1,1]
                                     , df.constraints[j_comb[2]][2,1]))
      }
      for(j in 1:ncol(test)){
        p_pairs[j, j] = p_pairs[j, j] + 
          scale_x_continuous(limits=c(df.constraints[1,j]
                                      , df.constraints[2,j]))
      }
      
      ggsave(paste(region, '_countour_', i, '.png', sep='', collapse='')
             , p_pairs
             , 'png'
             , width = 12
             , height = 12)
    }
  }
}



# (2) Traceplots ----------------------------------------------------------

df.chains = do.call('rbind',lapply(ls.chains, function(x){
  n_rows = nrow(x)
  temp_df = x
  temp_df[n_rows+(1:2),] = temp_df[n_rows,]
  temp_df[n_rows+(1:2),colnames(df.constraints)] = df.constraints
  
  return(melt(temp_df, c('idx', 'i_chain', 'LogLikelihood', 'region')))
}))

df.chains = df.chains[!(df.chains$region == 'wash' & df.chains$i_chain == 4),]

# Remove Chain 1; only use chains 2-11
df.chains = df.chains[df.chains$i_chain != 1,]

for(REGION in c('nyc', 'sflor', 'wash')){
  temp.chains = df.chains[df.chains$region == REGION,]
  temp.chains$i_chain = factor(temp.chains$i_chain-1)
  
  p.traces = ggplot(temp.chains, aes(x = idx, y = value, color = i_chain)) + 
    theme_grey(base_size=14) + 
    geom_line(alpha = 0.2) + 
    facet_wrap('variable', scales = 'free') +
    xlab('iterations')
  
  ggsave(paste('OUTPUT/MCMC Figures/2020-11-12_', REGION, '_TracePlots.png', sep='', collapse='')
         , p.traces, height = 6, width = 11)
  
}





# (3) RHats ---------------------------------------------------------------

temp.prsf = df.prsf
temp.prsf$region = rownames(temp.prsf)
melt.prsf = melt(temp.prsf, 'region')

p.rhats = ggplot(melt.prsf, aes(x = variable, y = value, color = region)) + 
  geom_point(size = 3) + 
  geom_hline(color = 'red', yintercept = 1.01) + 
  theme_minimal(base_size = 12) + 
  coord_flip() + 
  ylab('RHat') + 
  xlab('chain iteration')
  
ggsave('2020-11-12_GMBConvergenceRhats.png', p.rhats, height = 2, width = 8)
