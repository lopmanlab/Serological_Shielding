rm(list=ls())
require(readxl)
require(reshape2)
require(ggplot2)

# Read in Gelman-Rubin RHat results
df.prsf = data.frame(read_xlsx('2020-10-19_MCMCSTATmprsf_Diagnostics.xlsx')
                     , stringsAsFactors = F, row.names = 1)

# Read in chain summaries. Nested because I'm bad at regex 
v.chains = grep(value = T, list.files(path = 'OUTPUT/', pattern = '2020-10-07')
                , pattern='chains.csv')

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
  
  # melt
  res = melt(res, c('idx', 'i_chain', 'LogLikelihood', 'region'))
  
  # renaming
  # v.map = paste(colnames(df.prsf), round(df.prsf[REGION,],3), sep='=')
  # names(v.map) = levels(res$variable)
  # res$variable = v.map[as.character(res$variable)]
  
  # Return  
  list(res)
})


test = do.call('rbind', ls.chains)
test = test[!(test$region == 'wash' & test$i_chain == 4),]
ggplot(test, aes(x = idx, y = value, color = factor(i_chain))) + 
  geom_line(alpha = 0.2, aes()) + 
  facet_grid(variable~region, scales='free')

# ggplot(test, aes(x = idx, y = value, color = factor(i_chain))) + 
#   geom_line(alpha = 0.4, aes()) + 
#   facet_wrap('variable', ncol=3, scales='free')
