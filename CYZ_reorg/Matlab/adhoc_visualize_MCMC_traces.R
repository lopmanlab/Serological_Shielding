rm(list=ls())
require(readxl)
require(reshape2)
require(ggplot2)
require(factoextra)

# Read in Gelman-Rubin RHat results
df.prsf = data.frame(read_xlsx('2020-10-19_MCMCSTATmprsf_Diagnostics.xlsx')
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

# Plot PAs
region = 'wash'
test = t(do.call('cbind', split(ls.chains[[region]][,1:6], ls.chains[[region]]$i_chain)))
v.hab = sapply(rownames(test), function(x){strsplit(x, '\\.')[[1]][2]})

df.pcs = prcomp(test)
fviz_pca_ind(df.pcs, geom.ind = 'point', habillage = v.hab, addEllipses = T)

# (1) Traceplots ----------------------------------------------------------

df.chains = do.call('rbind',lapply(ls.chains, function(x){
  return(melt(x, c('idx', 'i_chain', 'LogLikelihood', 'region')))
}))
df.chains = df.chains[!(df.chains$region == 'wash' & df.chains$i_chain == 4),]
p.traces = ggplot(df.chains, aes(x = idx, y = value, color = factor(i_chain))) + 
  geom_line(alpha = 0.2, aes()) + 
  facet_grid(variable~region, scales='free')



# (2) Pairplots -----------------------------------------------------------


