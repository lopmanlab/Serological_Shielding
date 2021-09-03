rm(list=ls()) #Clear workspace

load('/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/Results/Opening_CredInt_AllLocs_0714.RData')

dates.site<-data.frame(loc=c('nyc', 'sfl', 'wash'), t0=c(as.Date('02/20/2020', format='%m/%d/%Y'), as.Date('02/27/2020', format='%m/%d/%Y'),
                                                         as.Date('02/13/2020', format='%m/%d/%Y')))

dates.site$Nov1.site<-as.numeric(as.Date('11/01/2020', format='%m/%d/%Y')-dates.site$t0)         
dates.site$June1.site<-as.numeric(as.Date('06/01/2021', format='%m/%d/%Y')-dates.site$t0)

Nov1.all<-subset(model_time2, model_time2$time==model_time2$nov1.numeric)
June1.all<-subset(model_time2, (model_time2$loc=='nyc' & model_time2$time==467)|(model_time2$loc=='sfl' & model_time2$time==460)|
  (model_time2$loc=='wash' & model_time2$time==474))
#write.csv(Nov1.all, '/Users/aliciakraay/Dropbox/COVID Shields Emory/MetroFits/Nov1_dat.csv')
#write.csv(June1.all, '/Users/aliciakraay/Dropbox/COVID Shields Emory/MetroFits/June1_dat.csv')

Nov1t<-Nov1.all[,c(1:7, 12, 16,20,22,23)]
June1t<-June1.all[,c(1:7, 12, 16, 20, 22)]
names(Nov1t)[c(8,10)]<-c('Deaths.nov1', 'CI.nov1')
names(June1t)[c(8, 10)]<-c('Deaths.june1', 'CI.june1')
NovJune<-merge(Nov1t[,c(1:8, 10:12)], June1t[,c(8:11)], by='runid')
NovJune$DeathsLate<-NovJune$Deaths.june1-NovJune$Deaths.nov1
#write.csv(NovJune, '/Users/aliciakraay/Dropbox/COVID Shields Emory/MetroFits/NovJune_dat.csv')

NovJune<-read.csv('/Users/aliciakraay/Dropbox/COVID Shields Emory/MetroFits/NovJune_dat.csv')
NovJune<-NovJune[,c(2:ncol(NovJune))]
#EndAll<-read.csv('/Users/aliciakraay/Dropbox/COVID Shields Emory/MetroFits/CredInt_AllLocs_EndVals.csv')

#EndAll$loc<-NA
#EndAll$loc[which(EndAll$param.id<201)]<-'nyc'
#EndAll$loc[which(EndAll$param.id>200 & EndAll$param.id<401)]<-'sfl'
#EndAll$loc[which(EndAll$param.id>400)]<-'wash'

None<-subset(NovJune[,c(2,3, 11, 12:14)], NovJune$intervention.id==0.125)
LateIdeal<-subset(NovJune[,c(2,3, 11, 12:14)], NovJune$intervention.id==0.625)

NoImmuneMonthlyShield<-subset(NovJune[,c(2, 3, 11, 12:14)], NovJune$intervention.id==0.250)
SuboptMonthNoShield<-subset(NovJune[,c(2, 3, 11, 12:14)], NovJune$intervention.id==0.375)
SuboptMonthShield<-subset(NovJune[,c(2, 3, 11, 12:14)], NovJune$intervention.id==0.500)
IdealAnnualShield<-subset(NovJune[,c(2, 3, 11, 12:14)], NovJune$intervention.id==0.75)
EarlyIdealMonthlyShield<-subset(NovJune[,c(2, 3, 11, 12:14)], NovJune$intervention.id==0.875)
EarlyIdealAnnualShield<-subset(NovJune[,c(2, 3, 11, 12:14)], NovJune$intervention.id==0)

names(None)[4:6]<-c('Deaths.notest', 'Released.notest', 'CI.notest')
names(LateIdeal)[4:6]<-c('Deaths.ideal', 'Released.ideal', 'CI.ideal')
names(NoImmuneMonthlyShield)[4:6]<-c('Deaths.worst', 'Released.worst', 'CI.worst')
names(SuboptMonthNoShield)[4:6]<-c('Deaths.subopta1month', 'Released.subopta1month', 'CI.subopta1month')
names(SuboptMonthShield)[4:6]<-c('Deaths.subopta5month', 'Released.subopta5month', 'CI.subopta5month')
names(IdealAnnualShield)[4:6]<-c('Deaths.IdealAnnual', 'Released.IdealAnnual', 'CI.IdealAnnual')
names(EarlyIdealMonthlyShield)[4:6]<-c('Deaths.EarlyIdealMonth', 'Released.EarlyIdealMonth', 'CI.EarlyIdealMonth')
names(EarlyIdealAnnualShield)[4:6]<-c('Deaths.EarlyIdealYr', 'Released.EarlyIdealYr', 'CI.EarlyIdealYr')

Compare<-merge(None[,c(1, 3:6)], LateIdeal[,c(1, 4:6)], by='param.id')
Compare2<-merge(Compare, NoImmuneMonthlyShield[,c(1, 4:6)], by='param.id')
Compare3<-merge(Compare2, SuboptMonthNoShield[,c(1, 4:6)], by='param.id')
Compare4<-merge(Compare3, SuboptMonthShield[,c(1, 4:6)], by='param.id')
Compare5<-merge(Compare4, IdealAnnualShield[,c(1, 4:6)], by='param.id')
Compare6<-merge(Compare5, EarlyIdealMonthlyShield[,c(1, 4:6)], by='param.id')
Compare7<-merge(Compare6, EarlyIdealAnnualShield[,c(1, 4:6)], by='param.id')

#params.sweep<-read.csv('/Users/aliciakraay/Dropbox/COVID Shields Emory/MetroFits/params_sweep.csv')

Compare7$DeathsAverted.ideal<-Compare7$Deaths.notest-Compare7$Deaths.ideal
Compare7$DeathsAverted.worst<-Compare7$Deaths.notest-Compare7$Deaths.worst
Compare7$DeathsAverted.subopta1month<-Compare7$Deaths.notest-Compare7$Deaths.subopta1month
Compare7$DeathsAverted.subopta5month<-Compare7$Deaths.notest-Compare7$Deaths.subopta5month
Compare7$DeathsAverted.IdealAnnual<-Compare7$Deaths.notest-Compare7$Deaths.IdealAnnual
Compare7$DeathsAverted.EarlyIdealMonth<-Compare7$Deaths.notest-Compare7$Deaths.EarlyIdealMonth
Compare7$DeathsAverted.EarlyIdealYr<-Compare7$Deaths.notest-Compare7$Deaths.EarlyIdealYr

Compare7$DeathsAverted.ShieldSubopt<-Compare7$Deaths.subopta1month-Compare7$Deaths.subopta5month
ddply(Compare7, .(loc), summarize, LCL=quantile(DeathsAverted.ShieldSubopt/Deaths.subopta1month, probs=0.025),
      UCL=quantile(DeathsAverted.ShieldSubopt/Deaths.subopta1month, probs=0.975))

#Compare$CIdiff<-Compare$CI.notest-Compare$CI.ideal
#summary(Compare$DeathsAverted)
ddply(Compare7, .(loc), summarize, meanAvert=mean(DeathsAverted.ideal), LCLavert=quantile(DeathsAverted.ideal, probs=0.025), 
      UCLavert=quantile(DeathsAverted.ideal, probs=0.975))
ddply(Compare7, .(loc), summarize, meanAvert=mean(DeathsAverted.worst), LCLavert=quantile(DeathsAverted.worst, probs=0.025), 
      UCLavert=quantile(DeathsAverted.worst, probs=0.975))
ddply(Compare7, .(loc), summarize, meanAvert=mean(DeathsAverted.IdealAnnual), LCLavert=quantile(DeathsAverted.IdealAnnual, probs=0.025), 
      UCLavert=quantile(DeathsAverted.IdealAnnual, probs=0.975))
ddply(Compare7, .(loc), summarize, meanAvert=mean(DeathsAverted.EarlyIdealMonth), LCLavert=quantile(DeathsAverted.EarlyIdealMonth, probs=0.025), 
      UCLavert=quantile(DeathsAverted.EarlyIdealMonth, probs=0.975))
ddply(Compare7, .(loc), summarize, meanAvert=mean(DeathsAverted.EarlyIdealYr), LCLavert=quantile(DeathsAverted.EarlyIdealYr, probs=0.025), 
      UCLavert=quantile(DeathsAverted.EarlyIdealYr, probs=0.975))
ddply(Compare7, .(loc), summarize, meanAvert=mean(DeathsAverted.subopta1month), LCLavert=quantile(DeathsAverted.subopta1month, probs=0.025), 
      UCLavert=quantile(DeathsAverted.subopta1month, probs=0.975))
ddply(Compare7, .(loc), summarize, meanAvert=mean(DeathsAverted.subopta5month), LCLavert=quantile(DeathsAverted.subopta5month, probs=0.025), 
      UCLavert=quantile(DeathsAverted.subopta5month, probs=0.975))

ddply(Compare7, .(loc), summarize, LCLavert=quantile(DeathsAverted.ideal/Deaths.notest, probs=0.025), 
      UCLavert=quantile(DeathsAverted.ideal/Deaths.notest, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(DeathsAverted.worst/Deaths.notest, probs=0.025), 
      UCLavert=quantile(DeathsAverted.worst/Deaths.notest, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(DeathsAverted.IdealAnnual/Deaths.notest, probs=0.025), 
      UCLavert=quantile(DeathsAverted.IdealAnnual/Deaths.notest, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(DeathsAverted.EarlyIdealMonth/Deaths.notest, probs=0.025), 
      UCLavert=quantile(DeathsAverted.EarlyIdealMonth/Deaths.notest, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(DeathsAverted.EarlyIdealYr/Deaths.notest, probs=0.025), 
      UCLavert=quantile(DeathsAverted.EarlyIdealYr/Deaths.notest, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(DeathsAverted.subopta1month/Deaths.notest, probs=0.025), 
      UCLavert=quantile(DeathsAverted.subopta1month/Deaths.notest, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(DeathsAverted.subopta5month/Deaths.notest, probs=0.025), 
      UCLavert=quantile(DeathsAverted.subopta5month/Deaths.notest, probs=0.975))


ddply(Compare7, .(loc), summarize, LCLreleased=quantile(Released.ideal, probs=0.025), 
        UCLavert=quantile(Released.ideal, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(Released.worst, probs=0.025), 
      UCLavert=quantile(Released.worst, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(Released.IdealAnnual, probs=0.025), 
      UCLavert=quantile(Released.IdealAnnual, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(Released.subopta1month, probs=0.025), 
      UCLavert=quantile(Released.subopta1month, probs=0.975))
ddply(Compare7, .(loc), summarize, LCLavert=quantile(Released.subopta5month, probs=0.025), 
      UCLavert=quantile(Released.subopta5month, probs=0.975))

ddply(Compare7, .(loc), summarize, LCLavert=quantile(Deaths.subopta1month, probs=0.025), 
      UCLavert=quantile(Deaths.subopta1month, probs=0.975))

ddply(Compare7, .(loc), summarize, LCLreleased=quantile(CI.notest, probs=0.025), 
      UCLavert=quantile(CI.notest, probs=0.975))

ddply(Compare7, .(loc), summarize, LCL=quantile(Deaths.notest, probs=0.025), 
      UCLavert=quantile(Deaths.notest, probs=0.975))

#quantile(Compare$DeathsAverted, probs=0.025)
#quantile(Compare$DeathsAverted, probs=0.975)
#mean(Compare$DeathsAverted)

#HighTest<-subset(End, End$intervention.id==0.625)
#NoTest<-subset(End, End$intervention.id==0.125)

#HighTest.deaths<-HighTest[,c(1,11, 22)]
#NoTest.deaths<-NoTest[,c(1, 11, 22)]
#names(HighTest.deaths)[2]<-'Deaths.hightest'
#names(NoTest.deaths)[2]<-'Deaths.notest'

#Compare<-merge(HighTest.deaths[,c(2,3)], NoTest.deaths[,c(2,3)], by='param.id')
#Compare$DeathsAverted<-Compare$Deaths.notest-Compare$Deaths.hightest
#summary(Compare$DeathsAverted)
#quantile(Compare$DeathsAverted, probs=0.025)
#quantile(Compare$DeathsAverted, probs=0.975)
#mean(Compare$DeathsAverted)

DeathsAverted.file<-ddply(NovJune, .(param.id), summarize, 
                    Death.LCL=quantile(Deaths.june1, probs=0.025), Death.UCL=quantile(Deaths.june1, probs=0.975), 
                    Released.LCL=quantile(FracReleased, probs=0.025), Released.UCL=quantile(FracReleased, probs=0.975), 
                    CI.LCL=quantile(CI.june1, probs=0.025), CI.UCL=quantile(CI.june1, probs=0.975))

ddply(params.sweep, .(loc), summarize, qdev=sd(q), pdev=sd(symptomatic_fraction), cdev=sd(c))
#write.csv(CredInt.file, '/Users/aliciakraay/Dropbox/COVID Shields Emory/MetroFits/NYC_CredInt_First100.csv')

Params<-read.csv('/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/Parameters/samp.params.0622.csv')
Params$param.id<-seq(from=1, to=nrow(Params))

EndParams<-merge(NovJune, Params[,c(2:10, 78)], by='param.id')
EndNY.none<-subset(EndParams, EndParams$loc=='nyc' & EndParams$intervention.id==0.125)

plot(EndNY.none$R0, EndNY.none$Deaths)
plot(EndNY.none$c, EndNY.none$Deaths)
plot(EndNY.none$p_reduced, EndNY.none$Deaths)
plot(EndNY.none$socialDistancing_other, EndNY.none$Deaths)

EndWash.none<-subset(EndParams, EndParams$loc=='wash' & EndParams$intervention.id==0.125)
plot(EndWash.none$R0, EndWash.none$Deaths)
plot(EndWash.none$c, EndWash.none$Deaths)
plot(EndWash.none$p_reduced, EndWash.none$Deaths)
plot(EndWash.none$socialDistancing_other, EndWash.none$Deaths)

EndSF.none<-subset(EndParams, EndParams$loc=='sfl' & EndParams$intervention.id==0.125)
plot(EndSF.none$R0, EndSF.none$Deaths)
plot(EndSF.none$c, EndSF.none$Deaths)
plot(EndSF.none$p_reduced, EndSF.none$Deaths)
plot(EndSF.none$socialDistancing_other, EndSF.none$Deaths)

EndAll<-rbind(EndNY.none, EndWash.none, EndSF.none)
A<-ggplot(EndNY.none, aes(x=c, y=Deaths.june1, color=p_reduced))+geom_point(aes(color=p_reduced))+labs(y='Predicted deaths by June 1, 2021')+
  ggtitle('New York City')+theme(legend.position='bottom')+lims(y=c(0, 1.05*10^5))
B<-ggplot(EndWash.none, aes(x=c, y=Deaths.june1, color=p_reduced))+geom_point(aes(color=p_reduced))+labs(y='')+
  ggtitle('Washington')+theme(legend.position='bottom')+lims(y=c(0, 23500))
C<-ggplot(EndSF.none, aes(x=c, y=Deaths.june1, color=p_reduced))+geom_point(aes(color=p_reduced))+labs(y='')+
  ggtitle('South Florida')+theme(legend.position='bottom')+lims(y=c(0, 11500))
require(ggpubr)
ggarrange(A, C, B, nrow=1)
ggsave(plot=ggarrange(A, C, B, nrow=1), filename='/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/Results/DeathsCI_byLoc.pdf',
       w=9, h=5)

ggplot(EndWash.none, aes(x=c, y=Deaths, color=Initial_Condition_Scale))+geom_point(aes(color=Initial_Condition_Scale))+labs(y='Predicted deaths after 1 year')+
  ggtitle('Washington')+theme(legend.position='none')

#initcondnyc <- read.csv("/Users/aliciakraay/Dropbox/COVID Shields Emory/2020-10-07_nyc_chains_summary.csv")
#initcondwash <- read.csv("/Users/aliciakraay/Dropbox/COVID Shields Emory/2020-10-07_nyc_chains_summary.csv")


### ranges for fitted params for SI
ranges.nyc <-subset(EndParams, EndParams$loc=='nyc' & EndParams$intervention.id==0.125)

ranges.sfl <-subset(EndParams, EndParams$loc=='sfl' & EndParams$intervention.id==0.125)

ranges.wash <-subset(EndParams, EndParams$loc=='wash' & EndParams$intervention.id==0.125)


ddply(ranges.nyc, .(intervention.id), summarize,
      symptomatic_fraction=quantile(symptomatic_fraction, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.sfl, .(intervention.id), summarize,
      symptomatic_fraction=quantile(symptomatic_fraction, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.wash, .(intervention.id), summarize,
      symptomatic_fraction=quantile(symptomatic_fraction, probs=c(0.05, 0.5, 0.95)))


ddply(ranges.nyc, .(intervention.id), summarize,
      q=quantile(q, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.sfl, .(intervention.id), summarize,
      q=quantile(q, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.wash, .(intervention.id), summarize,
      q=quantile(q, probs=c(0.05, 0.5, 0.95)))


ddply(ranges.nyc, .(intervention.id), summarize,
      c=quantile(c, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.sfl, .(intervention.id), summarize,
      c=quantile(c, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.wash, .(intervention.id), summarize,
      c=quantile(c, probs=c(0.05, 0.5, 0.95)))


ddply(ranges.nyc, .(intervention.id), summarize,
      p_reduced=quantile(p_reduced, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.sfl, .(intervention.id), summarize,
      p_reduced=quantile(p_reduced, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.wash, .(intervention.id), summarize,
      p_reduced=quantile(p_reduced, probs=c(0.05, 0.5, 0.95)))


ddply(ranges.nyc, .(intervention.id), summarize,
      socialDistancing_other=quantile(socialDistancing_other, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.sfl, .(intervention.id), summarize,
      socialDistancing_other=quantile(socialDistancing_other, probs=c(0.05, 0.5, 0.95)))
ddply(ranges.wash, .(intervention.id), summarize,
      socialDistancing_other=quantile(socialDistancing_other, probs=c(0.05, 0.5, 0.95)))



#EndNY.none<-subset(EndParams, EndParams$loc=='sflor' & EndAll$intervention.id==0.125)
#summary(End.unique$Deaths)
#hist(subset(End.unique, End.unique$intervention.id==0)$Deaths)
#hist(subset(End.unique, End.unique$intervention.id==0.125)$Deaths)



