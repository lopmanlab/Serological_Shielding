rm(list=ls())
require(readxl)
require(reshape2)
require(ggplot2)
require(GGally)
require(factoextra)

ADD_PLOT_CONSTRAINTS=T
INCLUDE_LOG_SCALE_TRACE=F
DATE = "2021-05-04"

# Read in Gelman-Rubin RHat results
if(file.exists(paste(DATE, '_MCMCSTATmprsf_Diagnostics.xlsx', sep='', collapse=''))){
  df.prsf = data.frame(read_xlsx(paste(DATE, '_MCMCSTATmprsf_Diagnostics.xlsx', sep='', collapse=''))
                       , stringsAsFactors = F, row.names = 1)
}else{
  df.prsf = data.frame(read.csv(paste(DATE, '_MCMCSTATmprsf_Diagnostics.csv', sep='', collapse=''))
                       , stringsAsFactors = F)
}


# Constraints
df.constraints = data.frame(read_xlsx('MCMCSTAT_constraints.xlsx')
                            , stringsAsFactors = F, row.names = 1)

# Read in chain summaries. Nested because I'm bad at regex 
v.chains = grep(value = T, list.files(path = 'OUTPUT/', pattern = DATE)
                , pattern='chain')

# Read in chains
ls.chains = sapply(v.chains, function(x){
  REGION = strsplit(x, '_')[[1]][2]
  
  # Read in csv 
  res = read.csv(paste("OUTPUT/", x, sep='', collapse = ''))
  
  # Data-frame
  res = as.data.frame(res) 
  
  # Remove last column since I still can't write matlab outputs
  res = res[,-ncol(res)]
  
  # Remove the initial condition columns for ease
  v.icCols = c("S_c", "S_a", "S_rc", "S_fc", "S_e"
  ,"E_c", "E_a", "E_rc", "E_fc", "E_e"
  ,"Isym_c", "Isym_a", "Isym_rc", "Isym_fc", "Isym_e"
  ,"Iasym_c", "Iasym_a", "Iasym_rc", "Iasym_fc", "Iasym_e"
  ,"Hsub_c", "Hsub_a", "Hsub_rc", "Hsub_fc", "Hsub_e"
  ,"Hcri_c", "Hcri_a", "Hcri_rc", "Hcri_fc", "Hcri_e"
  ,"D_c", "D_a", "D_rc", "D_fc", "D_e"
  ,"R_c", "R_a", "R_rc", "R_fc", "R_e")
  res = res[,!colnames(res) %in% v.icCols]
  
  # Add positions
  res$idx = 1:(table(res$i_chain)[1])
  
  # add region
  res$region = REGION
  
  # add nVars
  res$nVars = strsplit(strsplit(x, 'NVarsFit')[[1]][2], '_')[[1]][1]
  
  # Return  
  list(res)
})
names(ls.chains) = sapply(names(ls.chains)
                          , function(x) paste(strsplit(x, '_')[[1]][2]
                                              , strsplit(strsplit(x, 'NVarsFit')[[1]][2], '_')[[1]][1]
                                              , sep=''
                                              , collapse=''))
# combine by name
temp.names = unique(names(ls.chains))
temp.chains = sapply(temp.names, function(x){
  temp.in = ls.chains[names(ls.chains)==x]
  res = do.call('rbind', temp.in)
  return(list(res))
})
ls.chainComb = temp.chains

v.col_headers = colnames(df.constraints)
v.variables = v.col_headers[!v.col_headers %in% c('idx', 'i_chain', 'LogLikelihood', 'region', 'nVars')]

# (1) Pairplots -----------------------------------------------------------

# Contours
if(T){
  for(REGION in c('nyc5', 'sflor5', 'wash5')){
    for(i in 1:10){
      b.chains_in = names(ls.chains)==REGION      
      test = do.call('rbind', ls.chains[b.chains_in])
      test = test[test$i_chain == i,v.variables[1:5]] # obtain variables
      
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

ls.plotChains = lapply(ls.chainComb, function(x){
  n_rows = nrow(x)
  n_vars = unique(x$nVars)
  
  # Add constraints for plotting
  temp_df = x
  temp_vars = colnames(x)[colnames(x) %in% colnames(df.constraints)]
  
  if(ADD_PLOT_CONSTRAINTS){
    temp_df[n_rows+(1:2),] = temp_df[n_rows,] # duplicate last rows instead of rbind
    temp_df[n_rows+(1:2), temp_vars] = df.constraints[,temp_vars]
    temp_df[n_rows+(1:2), 'idx'] = NA
    
  }

  # melt
  ret = melt(temp_df, c('idx', 'i_chain', 'LogLikelihood', 'region', 'nVars'))
  ret$i_chain = as.character(ret$i_chain)
  
  return(ret)
})


for(i_chain in names(ls.plotChains)){
  temp.chains = ls.plotChains[[i_chain]]
  p.traces = ggplot(temp.chains, aes(x = idx, y = value, color = i_chain)) +
    theme_grey(base_size=22) +
    geom_line(alpha = 0.5) +
    facet_wrap('variable', scales = 'free') +
    xlab('iterations') + 
    ggtitle(i_chain)
  ggsave(paste('OUTPUT/MCMC Figures/', DATE, '_', i_chain, '_TracePlots.png', sep='', collapse='')
         , p.traces, height = 8, width = 14)
  
  if(INCLUDE_LOG_SCALE_TRACE){
    p.traces_log = ggplot(temp.chains, aes(x = idx, y = value, color = i_chain)) +
      theme_grey(base_size=14) +
      geom_line(alpha = 0.5) +
      facet_wrap('variable', scales = 'free') +
      xlab('iterations') + 
      ggtitle(i_chain) + 
      scale_y_log10()
    ggsave(paste('OUTPUT/MCMC Figures/', DATE, '_', i_chain, '_TracePlots_log.png', sep='', collapse='')
           , p.traces_log, height = 8, width = 12)
  }
}


# (3) RHats ---------------------------------------------------------------

temp.prsf = df.prsf
temp.prsf[temp.prsf==0] = NA
melt.prsf = melt(temp.prsf, c('region', 'n_vars', 'n_chains'))
melt.prsf = na.omit(melt.prsf)
melt.prsf$value = as.numeric(as.character(melt.prsf$value))
melt.prsf$variable = factor(melt.prsf$variable, levels = rev(levels(melt.prsf$variable)))
melt.prsf$n_vars = paste("N vars fit:", melt.prsf$n_vars)

p.rhats = ggplot(melt.prsf, aes(x = variable, y = value, color = region)) + 
  geom_point(size = 3) + 
  scale_y_log10() + 
  geom_hline(color = 'red', yintercept = 1.01) + 
  geom_hline(color = 'blue', yintercept = 1.1) + 
  theme_grey(base_size = 12) + 
  coord_flip() + 
  ylab('RHat') + 
  xlab('') + 
  facet_wrap('n_vars')
p.rhats

ggsave(paste('OUTPUT/MCMC Figures/', DATE, '_GMBConvergenceRhats.png', sep='', collapse='')
       , p.rhats, height = 4, width = 6)
