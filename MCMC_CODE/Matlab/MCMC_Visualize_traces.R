rm(list=ls())
require(readxl)
require(reshape2)
require(ggplot2)
require(GGally)
require(factoextra)

DATE = "2021-02-16" #"2021-02-13" #"2020-10-07"

# Read in Gelman-Rubin RHat results
df.prsf = data.frame(read_xlsx(paste(DATE, '_MCMCSTATmprsf_Diagnostics.xlsx', sep='', collapse=''))
                     , stringsAsFactors = F, row.names = 1)
  # df.prsf = data.frame(read.csv(paste(DATE, '_MCMCSTATmprsf_Diagnostics.csv', sep='', collapse=''))
  #                      , stringsAsFactors = F)

# Constraints
df.constraints = data.frame(read_xlsx(paste(DATE, '_MCMCSTAT_constraints.xlsx', sep='', collapse=''))
                            , stringsAsFactors = F, row.names = 1)

# Read in chain summaries. Nested because I'm bad at regex 
v.chains = grep(value = T, list.files(path = 'OUTPUT/', pattern = DATE)
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

v.col_headers = colnames(ls.chains[[1]])
v.variables = v.col_headers[!v.col_headers %in% c('idx', 'i_chain', 'LogLikelihood', 'region')]

# (1) Pairplots -----------------------------------------------------------

# Contours
if(F){
  for(REGION in c('nyc', 'sflor', 'wash')){
    for(i in 2:11){
      test = ls.chains[[REGION]]
      test = test[test$i_chain == i,v.variables] # obtain variables
      
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
      
      ggsave(paste('OUTPUT/MCMC Figures/', DATE, '_', REGION, '_countour_', i, '.png', sep='', collapse='')
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
  
  ggsave(paste('OUTPUT/MCMC Figures/', DATE, '_', REGION, '_TracePlots.png', sep='', collapse='')
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
  
ggsave(paste('OUTPUT/MCMC Figures/', DATE, '_GMBConvergenceRhats.png', sep='', collapse=''), p.rhats, height = 2, width = 8)