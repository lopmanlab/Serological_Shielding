rm(list=ls())
require(reshape2)
require(ggplot2)

df.in = read.csv('OUTPUT/2020-10-07_targetInits.csv')[1:3,]

Rescale_target = function(init_cond=0.03, X0_target=df.in[1,-1]){
  mat.inits = matrix(unlist(X0_target), nrow=5)
  rownames(mat.inits) = c('c', 'a', 'rc', 'fc', 'e')
  colnames(mat.inits) = c('S', 'E', 'Isym', 'Iasym', 'Hsub', 'Hcri', 'D', 'R')
  
  mat.inits_rescaled = mat.inits
  mat.inits_rescaled[,"S"] = mat.inits[,"S"] - init_cond*rowSums(mat.inits[,c("E", "Isym", "Iasym")])
  mat.inits_rescaled[,c("E", "Isym", "Iasym")] = (1+init_cond)*mat.inits[,c("E", "Isym", "Iasym")]
  
    #print(mat.inits)
    #print(mat.inits_rescaled)
  return(mat.inits_rescaled)
}

Rescale_target()



### Everything after this is to visualize the differences. It doesn't work too well b/c S >>> everything else

temp.res = do.call('rbind', sapply(1:3, function(x){
  res = do.call('rbind', sapply(c(-1, 0, 0.5), function(y){
    return(list(c(Rescale_target(y, df.in[x,-1]),'init_cond' = y)))
  }))
  res = as.data.frame(res)
  res$region = df.in$region[x]
  return(list(res))
}))

colnames(temp.res)[1:40] = colnames(df.in)[-1]


melt.res = melt(temp.res, c('init_cond', 'region'))

ggplot(melt.res[melt.res$region == 'nyc',], aes(x = variable, y = value, fill = factor(init_cond))) + geom_bar(stat = 'identity', color = 'black', position='dodge') + facet_wrap('variable', scales = 'free_x')
ggplot(melt.res[melt.res$region == 'nyc',], aes(x = variable, y = value, fill = factor(init_cond))) + 
  geom_bar(stat = 'identity', color = 'black', position='dodge') + 
  facet_wrap('variable', scales = 'free', ncol=5)
