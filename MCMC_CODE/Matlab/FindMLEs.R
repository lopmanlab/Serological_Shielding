rm(list=ls())
require(MASS)

v.files = list.files('OUTPUT/', pattern = 'chain')
v.files = paste('OUTPUT/', v.files, sep='')

b.filter = grepl('NVarsFit5', v.files)
v.files = v.files[b.filter]

ls.out = list()
ls.out2 = list()
for(location in c('nyc', 'sflor', 'wash')){
  b.loc = grepl(location, v.files)
  temp.files = v.files[b.loc]
  
  temp.lsChains = sapply(temp.files, function(x){df.in = list(as.data.frame(read.csv(x)))})
  temp.dfChains = do.call('rbind', temp.lsChains)
  
  temp.dfChains_sub = temp.dfChains[,-ncol(temp.dfChains)]
  temp.res = apply(temp.dfChains_sub, 2, function(x){fitdistr(x,'normal')[[1]][1]})
  
  ls.out[[location]] = temp.res
  
  ls.out2[[location]] = unique(temp.dfChains[which(temp.dfChains$LogLikelihood==max(temp.dfChains$LogLikelihood)),])
}

df.out = do.call('rbind', ls.out)

df.logout = do.call('rbind', ls.out2)

write.csv(df.out, '2021-06-17_MLEs.csv')
write.csv(df.logout, '2021-06-17_MLEs_by_LL.csv')
