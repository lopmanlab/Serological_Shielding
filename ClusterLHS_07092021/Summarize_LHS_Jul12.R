##Summarize LHS Results##

load('/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/LHS_NYC.RData')
dat.all7<-list()
for(i in 1:length(dat)){
  dat.temp<-dat[[i]]
  if(length(dat.temp)>1){
    dat.all7[[i]]<-do.call('rbind', dat.temp)
    dat.all7[[i]]$intervention.id<-rep(c(1/7, 2/7, 3/7, 4/7, 5/7, 6/7, 0), each=475) 
  }
}

length.vec<-as.numeric(lapply(dat, length))
table(length.vec)
#which(length.vec==1) #This vector shows which parameter sets need to be re-run for NYC
#to.omit<-which(length.vec==1)
#136, 138, 997, 1078, 1113, 1176, 1224, 
#1340, 1510, 1595, 1646, 1872, 1928, 2134, 2400, 2849
require(dplyr)
dat.long<-bind_rows(dat.all7, .id='param_id')
#This will bind all rows together and make the variable 'param_id' be continuous, so we need to fix it to merge with 
#the correct parameter sets
#Just make a separate vector, easiest this way
#vec.all<-rep(seq(from=1, to=3000), each=3800)
#vec.omit<-vec.all[which(!(vec.all %in% to.omit))]
#dat.long$param.id2<-vec.omit

#Now, we need to combine with the corresponding parameter dataset
param.scaled<-matrix(nrow=3000, ncol=6)
for(i in 1:ncol(paramsample)){
  if(i<6){
    param.scaled[,i]<-1/(paramlower[i]+(paramupper[i]-paramlower[i])*paramsample[,i])  
  }
  if(i==6){
    param.scaled[,i]<-paramlower[i]+(paramupper[i]-paramlower[i])*paramsample[,i] 
  }
}

param.vals<-as.data.frame(param.scaled)
names(param.vals)<-c('gamma_hc', 'gamma_hs', 'gamma_a', 'gamma_s', 'gamma_e', 'asy')
param.vals$param_id<-c(seq(from=1, to=3000))

dat.params<-merge(dat.long, param.vals, by='param_id', all.x=TRUE)
dat.end<-subset(dat.params, dat.params$time==474)

dat.reference<-subset(dat.end, dat.end$intervention.id==1/7)
dat.compare<-subset(dat.end, !(dat.end$intervention.id==1/7))
names(dat.reference)<-c('param_id', 'time', 'deaths.notest', 'hosp.notest', 
                        'crit.notest', 'released.notest', 'ci.notest', 'intervention.id', 'gamma_hc',
                        'gamma_hs', 'gamma_a', 'gamma_s', 'gamma_e', 'asy')
dat.merged<-merge(dat.compare, dat.reference[,c(1, 3:7)], by='param_id', all.x=TRUE)
dat.merged$deaths_shields<-dat.merged$deaths.notest-dat.merged$deaths
interventions.sweep$intervention.id<-c(1/7, 2/7, 3/7, 4/7, 5/7, 6/7, 0)
dat.merged2<-merge(dat.merged, interventions.sweep, by='intervention.id')

library(sensitivity)
bonferroni.alpha <- 0.05/6
int.id.vec<-unique(dat.merged2$intervention.id)
summary<-list()
for (i in 1:6){
  dat.int<-subset(dat.merged2, dat.merged2$intervention.id==int.id.vec[i])
  prcc<-pcc(dat.int[,9:14], dat.int[,20], nboot = 1000, rank=TRUE, conf=1-bonferroni.alpha)
  summary[[i]]<-print(prcc)
}
summary.all<-bind_rows(summary, .id='int.order')
summary.all$param.name<-rep(c('gamma_hc', 'gamma_hs', 'gamma_a', 'gamma_s', 'gamma_e', 'asy'), 6)
IDs<-data.frame(int.order=c(1, 2, 3, 4, 5, 6), intervention.id=int.id.vec)
IDs2<-merge(IDs, interventions.sweep, by='intervention.id', all.x=TRUE)
summary.all2<-merge(summary.all, IDs2, by='int.order')
save(summary.all2, file='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_nyc_facetwrap.Rdata')
load('/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_nyc_facetwrap.Rdata')

wrapit <- function(text) {
  wtext <- paste(strwrap(text,width=40),collapse=" \n ")
  return(wtext)
}

summary.all2$wrapped_desc <- llply(summary.all2$description, wrapit)
summary.all2$wrapped_desc <- unlist(summary.all2$wrapped_desc)

PRCC.nyc<-ggplot(summary.all2, aes(x=param.name, y=original, group=intervention.id))+
  facet_wrap(~wrapped_desc)+
  geom_point()+geom_errorbar(ymin=summary.all2[,5], ymax=summary.all2[,6])+
  geom_hline(yintercept=0, linetype=2)+labs(x='parameter', y='PRCC')+theme_bw()+lims(y=c(-1, 1))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=14),
        axis.title.y=element_text(size=14),
        strip.text = element_text(size=12))
ggsave(filename='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/PRCC_nyc_big.pdf', plot=PRCC.nyc,
       device='pdf', w=10, h=10)
#save(prcc, file='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_nyc_lateidealmonthly.Rdata')

###South Florida#######
rm(list=ls()) #Clear workspace
load('/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/LHS_sflor.RData')
dat.all7<-list()
for(i in 1:length(dat)){
  dat.temp<-dat[[i]]
  if(length(dat.temp)>1){
    dat.all7[[i]]<-do.call('rbind', dat.temp)
    dat.all7[[i]]$intervention.id<-rep(c(1/7, 2/7, 3/7, 4/7, 5/7, 6/7, 0), each=475) 
  }
}

length.vec<-as.numeric(lapply(dat, length))
table(length.vec)
dat.long<-bind_rows(dat.all7, .id='param_id')
#This will bind all rows together and make the variable 'param_id' be continuous, so we need to fix it to merge with 
#the correct parameter sets

#Now, we need to combine with the corresponding parameter dataset
param.scaled<-matrix(nrow=3000, ncol=6)
for(i in 1:ncol(paramsample)){
  if(i<6){
    param.scaled[,i]<-1/(paramlower[i]+(paramupper[i]-paramlower[i])*paramsample[,i])  
  }
  if(i==6){
    param.scaled[,i]<-paramlower[i]+(paramupper[i]-paramlower[i])*paramsample[,i] 
  }
}

param.vals<-as.data.frame(param.scaled)
names(param.vals)<-c('gamma_hc', 'gamma_hs', 'gamma_a', 'gamma_s', 'gamma_e', 'asy')
param.vals$param_id<-c(seq(from=1, to=3000))

dat.params<-merge(dat.long, param.vals, by='param_id', all.x=TRUE)
dat.end<-subset(dat.params, dat.params$time==474)

dat.reference<-subset(dat.end, dat.end$intervention.id==1/7)
dat.compare<-subset(dat.end, !(dat.end$intervention.id==1/7))
names(dat.reference)<-c('param_id', 'time', 'deaths.notest', 'hosp.notest', 
                        'crit.notest', 'released.notest', 'ci.notest', 'intervention.id', 'gamma_hc',
                        'gamma_hs', 'gamma_a', 'gamma_s', 'gamma_e', 'asy')
dat.merged<-merge(dat.compare, dat.reference[,c(1, 3:7)], by='param_id', all.x=TRUE)
dat.merged$deaths_shields<-dat.merged$deaths.notest-dat.merged$deaths
interventions.sweep$intervention.id<-c(1/7, 2/7, 3/7, 4/7, 5/7, 6/7, 0)
dat.merged2<-merge(dat.merged, interventions.sweep, by='intervention.id')

library(sensitivity)
bonferroni.alpha <- 0.05/6
int.id.vec<-unique(dat.merged2$intervention.id)
summary<-list()
for (i in 1:6){
  dat.int<-subset(dat.merged2, dat.merged2$intervention.id==int.id.vec[i])
  prcc<-pcc(dat.int[,9:14], dat.int[,20], nboot = 1000, rank=TRUE, conf=1-bonferroni.alpha)
  summary[[i]]<-print(prcc)
}
summary.all<-bind_rows(summary, .id='int.order')
summary.all$param.name<-rep(c('gamma_hc', 'gamma_hs', 'gamma_a', 'gamma_s', 'gamma_e', 'asy'), 6)
IDs<-data.frame(int.order=c(1, 2, 3, 4, 5, 6), intervention.id=int.id.vec)
IDs2<-merge(IDs, interventions.sweep, by='intervention.id', all.x=TRUE)
summary.all2<-merge(summary.all, IDs2, by='int.order')
save(summary.all2, file='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_sflor_facetwrap.Rdata')
load('/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_sflor_facetwrap.Rdata')

wrapit <- function(text) {
  wtext <- paste(strwrap(text,width=40),collapse=" \n ")
  return(wtext)
}

summary.all2$wrapped_desc <- llply(summary.all2$description, wrapit)
summary.all2$wrapped_desc <- unlist(summary.all2$wrapped_desc)

PRCC.sflor<-ggplot(summary.all2, aes(x=param.name, y=original, group=intervention.id))+
  facet_wrap(~wrapped_desc)+
  geom_point()+geom_errorbar(ymin=summary.all2[,5], ymax=summary.all2[,6])+
  geom_hline(yintercept=0, linetype=2)+labs(x='parameter', y='PRCC')+theme_bw()+lims(y=c(-1, 1))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=14),
        axis.title.y=element_text(size=14),
        strip.text = element_text(size=12))
ggsave(filename='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/PRCC_sflor_big.pdf', plot=PRCC.sflor,
       device='pdf', w=10, h=10)

#sflor<-ggplot(summary.all2, aes(x=param.name, y=original, group=intervention.id))+facet_wrap(~description)+
#  geom_point()+geom_errorbar(ymin=summary.all2[,5], ymax=summary.all2[,6])+
#  geom_hline(yintercept=0, linetype=2)+labs(x='parameter', y='PRCC')+theme_bw()+lims(y=c(-1, 1))+
#  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
#ggsave(plot=sflor, filename='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/PRCC_FacetWrap_Sflor.pdf', 
#       device='pdf', w=11, h=9)

#######Washington###############
rm(list=ls()) #Clear workspace
load('/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/LHS_wash.RData')
dat.all7<-list()
for(i in 1:length(dat)){
  dat.temp<-dat[[i]]
  if(length(dat.temp)>1){
    dat.all7[[i]]<-do.call('rbind', dat.temp)
    dat.all7[[i]]$intervention.id<-rep(c(1/7, 2/7, 3/7, 4/7, 5/7, 6/7, 0), each=475) 
  }
}

length.vec<-as.numeric(lapply(dat, length))
table(length.vec)
dat.long<-bind_rows(dat.all7, .id='param_id')
#This will bind all rows together and make the variable 'param_id' be continuous, so we need to fix it to merge with 
#the correct parameter sets

#Now, we need to combine with the corresponding parameter dataset
param.scaled<-matrix(nrow=3000, ncol=6)
for(i in 1:ncol(paramsample)){
  if(i<6){
    param.scaled[,i]<-1/(paramlower[i]+(paramupper[i]-paramlower[i])*paramsample[,i])  
  }
  if(i==6){
    param.scaled[,i]<-paramlower[i]+(paramupper[i]-paramlower[i])*paramsample[,i] 
  }
}

param.vals<-as.data.frame(param.scaled)
names(param.vals)<-c('gamma_hc', 'gamma_hs', 'gamma_a', 'gamma_s', 'gamma_e', 'asy')
param.vals$param_id<-c(seq(from=1, to=3000))

dat.params<-merge(dat.long, param.vals, by='param_id', all.x=TRUE)
dat.end<-subset(dat.params, dat.params$time==474)

dat.reference<-subset(dat.end, dat.end$intervention.id==1/7)
dat.compare<-subset(dat.end, !(dat.end$intervention.id==1/7))
names(dat.reference)<-c('param_id', 'time', 'deaths.notest', 'hosp.notest', 
                        'crit.notest', 'released.notest', 'ci.notest', 'intervention.id', 'gamma_hc',
                        'gamma_hs', 'gamma_a', 'gamma_s', 'gamma_e', 'asy')
dat.merged<-merge(dat.compare, dat.reference[,c(1, 3:7)], by='param_id', all.x=TRUE)
dat.merged$deaths_shields<-dat.merged$deaths.notest-dat.merged$deaths
interventions.sweep$intervention.id<-c(1/7, 2/7, 3/7, 4/7, 5/7, 6/7, 0)
dat.merged2<-merge(dat.merged, interventions.sweep, by='intervention.id')

library(sensitivity)
bonferroni.alpha <- 0.05/6
int.id.vec<-unique(dat.merged2$intervention.id)
summary<-list()
for (i in 1:6){
  dat.int<-subset(dat.merged2, dat.merged2$intervention.id==int.id.vec[i])
  prcc<-pcc(dat.int[,9:14], dat.int[,20], nboot = 1000, rank=TRUE, conf=1-bonferroni.alpha)
  summary[[i]]<-print(prcc)
}
summary.all<-bind_rows(summary, .id='int.order')
summary.all$param.name<-rep(c('gamma_hc', 'gamma_hs', 'gamma_a', 'gamma_s', 'gamma_e', 'asy'), 6)
IDs<-data.frame(int.order=c(1, 2, 3, 4, 5, 6), intervention.id=int.id.vec)
IDs2<-merge(IDs, interventions.sweep, by='intervention.id', all.x=TRUE)
summary.all2<-merge(summary.all, IDs2, by='int.order')
save(summary.all2, file='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_wash_facetwrap.Rdata')
load('/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_sflor_facetwrap.Rdata')

wrapit <- function(text) {
  wtext <- paste(strwrap(text,width=40),collapse=" \n ")
  return(wtext)
}

summary.all2$wrapped_desc <- llply(summary.all2$description, wrapit)
summary.all2$wrapped_desc <- unlist(summary.all2$wrapped_desc)

PRCC.wash<-ggplot(summary.all2, aes(x=param.name, y=original, group=intervention.id))+
  facet_wrap(~wrapped_desc)+
  geom_point()+geom_errorbar(ymin=summary.all2[,5], ymax=summary.all2[,6])+
  geom_hline(yintercept=0, linetype=2)+labs(x='parameter', y='PRCC')+theme_bw()+lims(y=c(-1, 1))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1, size=12), 
        axis.text.y=element_text(size=12),
        axis.title.x=element_text(size=14),
        axis.title.y=element_text(size=14),
        strip.text = element_text(size=12))
ggsave(filename='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/PRCC_wash_big.pdf', plot=PRCC.wash,
       device='pdf', w=10, h=10)

wash<-ggplot(summary.all2, aes(x=param.name, y=original, group=intervention.id))+facet_wrap(~description)+
  geom_point()+geom_errorbar(ymin=summary.all2[,5], ymax=summary.all2[,6])+
  geom_hline(yintercept=0, linetype=2)+labs(x='parameter', y='PRCC')+theme_bw()+lims(y=c(-1, 1))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(plot=wash, filename='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/PRCC_FacetWrap_Wash.pdf', 
       device='pdf', w=11, h=9)

#Just tweak plots
#NYC
rm(list=ls()) #Clear workspace
load('/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_nyc_facetwrap.Rdata')
summary.all3<-subset(summary.all2, summary.all2$test.timing=='Nov1')
nyc_late<-ggplot(summary.all3, aes(x=param.name, y=original, group=intervention.id))+facet_wrap(~description)+
  geom_point()+geom_errorbar(ymin=summary.all3[,5], ymax=summary.all3[,6])+
  geom_hline(yintercept=0, linetype=2)+labs(x='parameter', y='PRCC')+theme_bw()+lims(y=c(-1, 1))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(plot=nyc_late, filename='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/PRCC_FacetWrap_Nyc_late.pdf', 
       device='pdf', w=11, h=9)

#Sflor
rm(list=ls()) #Clear workspace
load('/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_sflor_facetwrap.Rdata')
summary.all3<-subset(summary.all2, summary.all2$test.timing=='Nov1')
sflor_late<-ggplot(summary.all3, aes(x=param.name, y=original, group=intervention.id))+facet_wrap(~description)+
  geom_point()+geom_errorbar(ymin=summary.all3[,5], ymax=summary.all3[,6])+
  geom_hline(yintercept=0, linetype=2)+labs(x='parameter', y='PRCC')+theme_bw()+lims(y=c(-1, 1))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(plot=sflor_late, filename='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/PRCC_FacetWrap_Sflor_late.pdf', 
       device='pdf', w=11, h=9)

#Washington
rm(list=ls()) #Clear workspace
load('/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/prcc_wash_facetwrap.Rdata')
summary.all3<-subset(summary.all2, summary.all2$test.timing=='Nov1')
wash_late<-ggplot(summary.all3, aes(x=param.name, y=original, group=intervention.id))+facet_wrap(~description)+
  geom_point()+geom_errorbar(ymin=summary.all3[,5], ymax=summary.all3[,6])+
  geom_hline(yintercept=0, linetype=2)+labs(x='parameter', y='PRCC')+theme_bw()+lims(y=c(-1, 1))+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggsave(plot=wash_late, filename='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/LHS_samples/PRCC_FacetWrap_Wash_late.pdf', 
       device='pdf', w=11, h=9)