rm(list=ls())

require(reshape2)
require(ggplot2)

# map
v.map = c('unwt', 'unwt (long)', 'wtd', 'wtd (long)')
names(v.map) = c('2020-10-05c', '2020-10-07', '2020-10-09', '2020-10-12')

# get csv dirs
v.dirs = list.files(path = 'OUTPUT', pattern = 'summary.csv')
temp.dirs = sapply(v.dirs, function(x){strsplit(x, '')})

df.dirs = data.frame('dir' = v.dirs
                     , do.call('rbind', strsplit(v.dirs, '_'))
                     , stringsAsFactors = F)

# fix 
colnames(df.dirs) = c('dir', 'date', 'region', 'chain', 'summary')
rownames(df.dirs) = df.dirs$dir

# get means
temp.res = sapply(df.dirs$dir, function(x){
  temp = read.csv(paste('OUTPUT/', x, sep='', collapse=''))
  temp$X = NULL # holdover form MATLAB mis-writing a blank olumn
  apply(temp, 2, function(y) c(mean(y)))
})
temp.res = t(temp.res)

# fix
df.pars = cbind(df.dirs, temp.res[rownames(df.dirs),])
df.pars$date = v.map[df.pars$date]

melt.pars = melt(df.pars[,1:14], colnames(df.dirs))


# plot
ggplot(melt.pars, aes(x = region, y = value, fill = date)) + 
  geom_bar(stat = 'identity', color = 'black', position = 'dodge') + 
  facet_wrap("variable", scales = 'free_y') +
  scale_fill_brewer(palette = 'Paired')

write.csv(df.pars, "Summary_OUT.csv")