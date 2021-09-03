rm(list=ls()) #Clear workspace

require(ggplot2)
require(reshape2)
require(cowplot)
require(here)
require(plyr)
require(dplyr)
require(ggpubr)

Nov1<-as.Date('11/01/2020', format='%m/%d/%Y')
June1<-as.Date('06/01/2021', format='%m/%d/%Y')

# NYC
load("/Users/aliciakraay/Dropbox/COVIDShieldsEmory/MetroFits/NY_Reopening_July14.RData")

t0.nyc<-as.Date('02/20/2020', format='%m/%d/%Y')
schooltime <- school.start.time
late.testtime <-  as.numeric(Nov1-t0.nyc)
june.nyc<-as.numeric(June1-t0.nyc)
reopentime <- start.time.reopen
distancetime <- start.time.distance

dates.nyc <- c(distancetime, late.testtime, reopentime, schooltime)
End.nyc <- subset(model_time, model_time$time==june.nyc)

for(i in 1:dim(sweep)[1]){
  data.summary[[i]]$sweepnum<-i
}

require(plyr)
require(dplyr)
UnlistDat<-bind_rows(data.summary, .id = "sweepnum")


#UnlistDat<-bind_rows(data.full, .id = "sweepnum")
sweep$sweepnum<-c(1:nrow(sweep))
model_time<-merge(sweep, UnlistDat[,1:ncol(UnlistDat)], by='sweepnum', all.y=TRUE)

NoTest<-subset(model_time, model_time$testval==0)
NoTest.rep<-rbind(NoTest, NoTest, NoTest, NoTest, NoTest, NoTest,
                  NoTest, NoTest, NoTest, NoTest, NoTest, NoTest)
Full.test<-subset(model_time, model_time$testval==max(model_time$testval))
library(dplyr)
Conds<-ddply(Full.test, .(sweepnum), function(x) head(x,1))
NoTest.rep$alpha<-rep(Conds$alpha, each=475)
NoTest.rep$specificity<-rep(Conds$specificity, each=475)
NoTest.rep$start.time.test<-rep(Conds$start.time.test, each=475)
NoTest.rep$sweepnum<-rep(c(101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112), each=475)
model_time_tested<-subset(model_time, model_time$testval>0)
model_time2<-rbind(model_time_tested, NoTest.rep)

model_time.nyc <-subset(model_time2, !(model_time2$testval %in% c(N/90, N/60, N/180, N/(365*5))))
model_time.nyc$Date<-t0.nyc+model_time.nyc$time
#write.csv(End.nyc, '/Users/kristinnelson/Box Sync/covid-19/Shielding/Results/NY_Reopening_Sweep2_End.csv')
#write.csv(model_time.nyc, '/Users/kristinnelson/Box Sync/covid-19/Shielding/Results/NY_Reopening_Sweep2_model_time.csv')

#rm(list=ls()) 
# SOUTH FLORIDA
load("/Users/aliciakraay/Dropbox/COVIDShieldsEmory/MetroFits/Sflor_Reopening_July14.RData")

t0.sfl<-as.Date('02/27/2020', format='%m/%d/%Y')
schooltime <- school.start.time
late.testtime <-as.numeric(Nov1-t0.sfl)
june.sfl<-as.numeric(June1-t0.sfl)
reopentime <- start.time.reopen
distancetime <- start.time.distance

dates.sflor <- c(distancetime, late.testtime, reopentime, schooltime)
#dates.sflor[2]<-255
End.sflor <- subset(model_time, model_time$time==june.sfl)

for(i in 1:dim(sweep)[1]){
  data.summary[[i]]$sweepnum<-i
}

require(plyr)
require(dplyr)
UnlistDat<-bind_rows(data.summary, .id = "sweepnum")


#UnlistDat<-bind_rows(data.full, .id = "sweepnum")
sweep$sweepnum<-c(1:nrow(sweep))
model_time<-merge(sweep, UnlistDat[,1:ncol(UnlistDat)], by='sweepnum', all.y=TRUE)

NoTest<-subset(model_time, model_time$testval==0)
NoTest.rep<-rbind(NoTest, NoTest, NoTest, NoTest, NoTest, NoTest,
                  NoTest, NoTest, NoTest, NoTest, NoTest, NoTest)
Full.test<-subset(model_time, model_time$testval==max(model_time$testval))
Conds<-ddply(Full.test, .(sweepnum), function(x) head(x,1))
NoTest.rep$alpha<-rep(Conds$alpha, each=475)
NoTest.rep$specificity<-rep(Conds$specificity, each=475)
NoTest.rep$start.time.test<-rep(Conds$start.time.test, each=475)
NoTest.rep$sweepnum<-rep(c(101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112), each=475)
model_time_tested<-subset(model_time, model_time$testval>0)
model_time2<-rbind(model_time_tested, NoTest.rep)

model_time.sflor <-subset(model_time2, !(model_time2$testval %in% c(N/90, N/60, N/180, N/(365*5))))
model_time.sflor$Date<-t0.sfl+model_time.sflor$time
#write.csv(End.sflor, '/Users/kristinnelson/Box Sync/covid-19/Shielding/Results/SFlorida_Reopening_Sweep2_End.csv')
#write.csv(model_time.sflor, '/Users/kristinnelson/Box Sync/covid-19/Shielding/Results/SFlorida_Reopening_Sweep2_model_time.csv')

#rm(list=ls()) 

# WASHINGTON
load("/Users/aliciakraay/Dropbox/COVIDShieldsEmory/MetroFits/Wash_Reopening_July14.RData")

t0.wash<-as.Date('02/13/2020', format='%m/%d/%Y')
schooltime <- school.start.time
late.testtime <- as.numeric(Nov1-t0.wash)
reopentime <- start.time.reopen
distancetime <- start.time.distance
june.wash<-June1-t0.wash

dates.wash <- c(distancetime, late.testtime, reopentime, schooltime)
End.wash <- subset(model_time, model_time$time==june.wash)


for(i in 1:dim(sweep)[1]){
  data.summary[[i]]$sweepnum<-i
}

require(plyr)
require(dplyr)
UnlistDat<-bind_rows(data.summary, .id = "sweepnum")


#UnlistDat<-bind_rows(data.full, .id = "sweepnum")
sweep$sweepnum<-c(1:nrow(sweep))
model_time<-merge(sweep, UnlistDat[,1:ncol(UnlistDat)], by='sweepnum', all.y=TRUE)

NoTest<-subset(model_time, model_time$testval==0)
NoTest.rep<-rbind(NoTest, NoTest, NoTest, NoTest, NoTest, NoTest,
                  NoTest, NoTest, NoTest, NoTest, NoTest, NoTest)
Full.test<-subset(model_time, model_time$testval==max(model_time$testval))
Conds<-ddply(Full.test, .(sweepnum), function(x) head(x,1))
NoTest.rep$alpha<-rep(Conds$alpha, each=475)
NoTest.rep$specificity<-rep(Conds$specificity, each=475)
NoTest.rep$start.time.test<-rep(Conds$start.time.test, each=475)
NoTest.rep$sweepnum<-rep(c(101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112), each=475)
model_time_tested<-subset(model_time, model_time$testval>0)
model_time2<-rbind(model_time_tested, NoTest.rep)

model_time.wash <-subset(model_time2, !(model_time2$testval %in% c(N/90, N/60, N/180, N/(365*5))))
model_time.wash$Date<-t0.wash+model_time.wash$time
#write.csv(End.wash, '/Users/kristinnelson/Box Sync/covid-19/Shielding/Results/Wash_Reopening_Sweep2_End.csv')
#write.csv(model_time.wash, '/Users/kristinnelson/Box Sync/covid-19/Shielding/Results/Wash_Reopening_Sweep2_model_time.csv')

#rm(list=ls()) 

#############
# FIGURE 2 
#############

####PART A
testing.nyc<-as.numeric(names(table(End.nyc$testval)))
End.nyc.nt<-subset(End.nyc, End.nyc$testval==0)[,c(1, 6:ncol(End.nyc))]
conds.nyc<-data.frame(sweepnum=rep(97, 6), alpha=rep(c(1, 5), 3), specificity=rep(c(rep(0.5, 2), rep(0.90, 2), rep(0.998, 2))),
                     start.time.test=rep(255, 6), testval=rep(0, 6))
End.nyc.nt2<-merge(End.nyc.nt, conds.nyc, by='sweepnum')
End.nyc2<-rbind(subset(End.nyc, !(End.nyc$testval==0) & End.nyc$start.time.test==255), End.nyc.nt2)
alphaplot <- 5
ggplot(data=subset(End.nyc2, End.nyc2$testval==0|(End.nyc2$testval>0 &End.nyc2$alpha==alphaplot)), 
       aes(x=testval, y=Deaths, group=interaction(specificity, start.time.test))) +
  geom_line(aes(linetype=factor(start.time.test), color=factor(specificity)))+
  geom_abline(intercept=42576, color='grey60')+
  annotate("text", x = testing.nyc[4], y=42576+15000, label=paste("\nNo testing"), angle=0, color="grey40", size=7) +
  scale_color_viridis_d(begin = 0, end = 0.9,
                        name="Specificity",
                        labels=c("50%", "96%", "99.8%")) +
  xlab("Daily testing rate") +
  ylab("Cumulative deaths") +
  lims(y=c(0, 2.75*42576))+
  labs(color = "Distancing intensity", linetype ='Test performance') +
  scale_x_log10(breaks=c(testing.nyc[1], testing.nyc[2], testing.nyc[3], testing.nyc[5], testing.nyc[9]),
                labels=c('0', '1%/yr', '10%/yr', 'Yearly', 'Monthly')) +
  #scale_linetype_manual(values=c("dotted", "solid"),
  #                      name = "Testing start date",
  #                      labels = c("Reopening", "Novemeber 1, 2020")) +
  ggtitle("New York City") +
  theme(legend.position='none',    
        legend.key = element_blank(),
        legend.key.size = unit(0.5, "cm"),
        legend.text=element_text(size=6),
        legend.title=element_text(size=6),
        legend.key.height = unit(0.5, "cm"),
        panel.background = element_rect(fill = "white", size = 0.5, linetype = "solid"),
        plot.title = element_text(hjust = 0),
        #axis.text=element_text(size=6),
        #axis.title=element_text(size=6),
        axis.title.x = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.title.y = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.text.x = element_text(colour = "black", size = 12),
        axis.text.y = element_text(colour = "black", size = 12),
        axis.line.x = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.ticks.length=unit(.25, "cm"),
        legend.box='horizontal')+labs(color='Specificity', linetype='Start target') -> fig2a.nyc; fig2a.nyc

testing.sflor<-as.numeric(names(table(End.sflor$testval)))
End.sflor.nt<-subset(End.sflor, End.sflor$testval==0)[,c(1, 6:ncol(End.sflor))]
conds.sf<-data.frame(sweepnum=rep(97, 6), alpha=rep(c(1, 5), 3), specificity=rep(c(rep(0.5, 2), rep(0.90, 2), rep(0.998, 2))),
                      start.time.test=rep(248, 6), testval=rep(0, 6))
End.sflor.nt2<-merge(End.sflor.nt, conds.sf, by='sweepnum')
End.sflor2<-rbind(subset(End.sflor, !(End.sflor$testval==0) & End.sflor$start.time.test==dates.sflor[2]), End.sflor.nt2)


ggplot(data=subset(End.sflor2, End.sflor2$testval==0|(End.sflor2$testval>0 &End.sflor2$alpha==alphaplot)), 
       aes(x=testval, y=Deaths, group=interaction(specificity, start.time.test))) +
  geom_line(aes(linetype=factor(start.time.test), color=factor(specificity)))+
  #scale_linetype_manual(values=c("dotted", "solid")) +
  geom_abline(intercept=10368, color='grey60')+
  annotate("text", x = testing.sflor[4], y=10368+3500, label=paste("\nNo testing"), angle=0, color="grey40", size=7) +
  scale_color_viridis_d(begin = 0, end = 0.9) +
  xlab("Daily testing rate") +
  ylab("Cumulative deaths") +
  labs(color = "Distancing intensity", linetype ='Test performance') +
  lims(y=c(0, 2.75*10368))+
  scale_x_log10(breaks=c(testing.sflor[1], testing.sflor[2], testing.sflor[3], testing.sflor[5], testing.sflor[9]),
                labels=c('0', '1%/yr', '10%/yr', 'Yearly', 'Monthly')) +
  ggtitle("South Florida") +
  theme(legend.position='none',    
        legend.key = element_blank(),
        legend.key.size = unit(0.5, "cm"),
        legend.text=element_text(size=6),
        legend.title=element_text(size=6),
        legend.key.height = unit(0.5, "cm"),
        panel.background = element_rect(fill = "white", size = 0.5, linetype = "solid"),
        plot.title = element_text(hjust = 0),
        axis.text=element_text(size=6),
        axis.title=element_text(size=6),
        axis.title.x = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.title.y = element_blank(),
        axis.text.x = element_text(colour = "black", size = 12),
        axis.text.y = element_text(colour = "black", size = 12),
        axis.line.x = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.ticks.length=unit(.25, "cm"),
        legend.box='horizontal')+labs(color='Specificity', linetype='Start target') -> fig2a.sflor; fig2a.sflor

testing.wash<-as.numeric(names(table(End.wash$testval)))
End.wash.nt<-subset(End.wash, End.wash$testval==0)[,c(1, 6:ncol(End.wash))]
conds.wash<-data.frame(sweepnum=rep(97, 6), alpha=rep(c(1, 5), 3), specificity=rep(c(rep(0.5, 2), rep(0.96, 2), rep(0.998, 2))),
                     start.time.test=rep(262, 6), testval=rep(0, 6))
End.wash.nt2<-merge(End.wash.nt, conds.wash, by='sweepnum')
End.wash2<-rbind(subset(End.wash, !(End.wash$testval==0) & End.wash$start.time.test==262), End.wash.nt2)

ggplot(data=subset(End.wash2, End.wash2$testval==0|(End.wash2$testval>0 & End.wash2$alpha==alphaplot)), 
       aes(x=testval, y=Deaths, group=interaction(specificity, start.time.test))) +
  geom_line(aes(linetype=factor(start.time.test), color=factor(specificity)))+
  geom_abline(intercept=19156, color='grey60')+
  lims(y=c(0, 19156*2.75))+
  annotate("text", x = testing.wash[4], y=19156+7000, label=paste("\nNo testing"), angle=0, color="grey40", size=7) +
  #scale_linetype_manual(values=c("dotted", "solid"),
  #                      name = "Testing start date",
  #                      labels = c("Reopening", "November 1, 2020")) +
  scale_color_viridis_d(begin = 0, end = 0.9,
                        name="Specificity",
                        labels=c("50%", "96%", "99.8%")) +
  xlab("Daily testing rate") +
  #ylab("Cumulative deaths") +
  labs(color = "Distancing intensity", linetype ='Test performance') +
  scale_x_log10(breaks=c(testing.wash[1], testing.wash[2], testing.wash[3], testing.wash[5], testing.wash[9]),
                labels=c('0', '1%/yr', '10%/yr', 'Yearly', 'Monthly')) +
  ggtitle("Washington Puget Sound") +
  theme(legend.position='none',     
        #legend.position=c(0.35, 0.85),
        legend.key = element_blank(),
        legend.key.size = unit(0.5, "cm"),
        legend.text=element_text(size=12),
        legend.title=element_text(size=12),
        legend.key.height = unit(0.5, "cm"),
        panel.background = element_rect(fill = "white", size = 0.5, linetype = "solid"),
        plot.title = element_text(hjust = 0),
        #axis.text=element_text(size=6),
        #axis.title=element_text(size=6),
        axis.title.x = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.title.y = element_blank(),
        axis.text.x = element_text(colour = "black", size = 10),
        axis.text.y = element_text(colour = "black", size = 10),
        axis.line.x = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.ticks.length=unit(.25, "cm"),
        legend.box='vertical')+labs(color='Specificity', linetype='Start target') -> fig2a.wash; fig2a.wash

ggsave(plot=ggarrange(fig2a.nyc, fig2a.sflor, fig2a.wash, nrow=1), 
       file='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/MetroFits/DeathsJune2021_All3.pdf', device='pdf',
       w=12, h=4)

#ggsave(plot=ggarrange(fig2a.nyc, fig2a.wash, nrow=1), 
#       file='/Users/aliciakraay/Dropbox/COVID Shields Emory/MetroFits/DeathsJune2021_NatComRevis.pdf', device='pdf',
#       w=12, h=4)

#### PART B
require(scales)
# USENYC pop
alphaplot<-5
subset(model_time.nyc , model_time.nyc$alpha == alphaplot &
         model_time.nyc$start.time.test==dates.nyc[2] & model_time.nyc$specificity %in% c(0.90, 0.998)) -> model_time_plot2
model_time_plot2 %>%
  ggplot(aes(x=Date, y=Released/(9.3*10^6), group = sweepnum, color = factor(testval))) +
  geom_line(aes(linetype=factor(specificity))) +
  xlab("Date") +
  scale_x_date(date_breaks='4 months',labels = date_format("%b-%Y"))+
  ylab("Proportion released") +
  scale_color_viridis_d(option="plasma", begin = 0.1, end = 0.9, direction = -1,
                        name="Per capita testing rate",
                        labels=c("No testing", "1% per year", "10% per year",  "Yearly", "Monthly")) +
  scale_linetype_manual(values = c("solid", "dashed"),
                        name = "Specificity",
                        labels = c("90%", "99.8%")) +
  #labs(color = "Per capita testing rate") +
  coord_cartesian(ylim=c(0, 1)) +
  geom_vline(xintercept = t0.nyc+dates.nyc[c(1,2,3,4)], color = "grey60") +
  annotate("text", x = t0.nyc+dates.nyc[1], y=0.4, label=paste("\nGeneral distancing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.nyc+dates.nyc[2], y=0.4, label=paste("\nStart testing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.nyc+dates.nyc[3], y=0.4, label=paste("\nSAH order lifted"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.nyc+dates.nyc[4], y=0.4, label=paste("\nOpen schools"), angle=90, color="grey40", size=5.5) +
  #ggtitle("New York City") +
  theme(legend.position='none',
        #legend.position=c(0.6, 0.75),    
        legend.key = element_blank(),
        legend.key.size = unit(0.5, "cm"),
        legend.title = element_text(size=6),
        legend.key.height = unit(0.5, "cm"),
        legend.text = element_text(size=6),
        panel.background = element_rect(fill = "white", size = 0.5, linetype = "solid"),
        plot.title = element_text(hjust = 0),
        axis.title.x = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.title.y = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.text.x = element_text(colour = "black", size = 12),
        axis.text.y = element_text(colour = "black", size = 12),
        axis.line.x = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.ticks.length=unit(.25, "cm")) -> fig2b.nyc; fig2b.nyc

# USE S. Florida pop
alphaplot<-5
subset(model_time.sflor , model_time.sflor$alpha == alphaplot &
         model_time.sflor$start.time.test==dates.sflor[2] & model_time.sflor$specificity %in% c(0.90, 0.998)) -> model_time_plot2
model_time_plot2 %>%
  ggplot(aes(x=Date, y=FracReleased, group = sweepnum, color = factor(testval))) +
  geom_line(aes(linetype=factor(specificity))) +
  xlab("Date") +
  scale_x_date(date_breaks='4 months',labels = date_format("%b-%Y"))+
  ylab(" ") +
  scale_color_viridis_d(option="plasma", begin = 0.1, end = 0.9, direction = -1,
                        name="Per capita testing rate",
                        labels=c("No testing", "1% per year", "10% per year",  "Yearly", "Monthly")) +
  scale_linetype_manual(values = c("solid", "dashed"),
                        name = "Specificity",
                        labels = c("90%", "99.8%")) +
  labs(color = "Per capita testing rate") +
  coord_cartesian(ylim=c(0, 1)) +
  geom_vline(xintercept = t0.sfl+dates.sflor[c(1,2,3,4)], color = "grey60") +
  annotate("text", x = t0.sfl+dates.sflor[1], y=0.4, label=paste("\nGeneral distancing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.sfl+dates.sflor[2], y=0.4, label=paste("\nStart testing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.sfl+dates.sflor[3], y=0.4, label=paste("\nSAH order lifted"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.sfl+dates.sflor[4], y=0.4, label=paste("\nOpen schools"), angle=90, color="grey40", size=5.5) +
  #ggtitle("New York City") +
  theme(legend.position='none',
        #legend.position=c(0.6, 0.75),    
        legend.key = element_blank(),
        legend.key.size = unit(0.5, "cm"),
        legend.title = element_text(size=6),
        legend.key.height = unit(0.5, "cm"),
        legend.text = element_text(size=6),
        panel.background = element_rect(fill = "white", size = 0.5, linetype = "solid"),
        plot.title = element_text(hjust = 0),
        axis.title.x = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.title.y = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.text.x = element_text(colour = "black", size = 12),
        axis.text.y = element_text(colour = "black", size = 12),
        axis.line.x = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.ticks.length=unit(.25, "cm")) -> fig2b.sflor; fig2b.sflor


# USE Washington pop
alphaplot<-5
subset(model_time.wash , model_time.wash$alpha == alphaplot &
         model_time.wash$start.time.test==dates.wash[2] & model_time.wash$specificity %in% c(0.90, 0.998)) -> model_time_plot2
model_time_plot2 %>%
  ggplot(aes(x=Date, y=FracReleased, group = sweepnum, color = factor(testval))) +
  geom_line(aes(linetype=factor(specificity))) +
  xlab("Date") +
  scale_x_date(date_breaks='4 months',labels = date_format("%b-%Y"))+
  ylab(" ") +
  scale_color_viridis_d(option="plasma", begin = 0.1, end = 0.9, direction = -1,
                        name="Per capita testing rate",
                        labels=c("No testing", "1% per year", "10% per year",  "Yearly", "Monthly")) +
  scale_linetype_manual(values = c("solid", "dashed"),
                        name = "Specificity",
                        labels = c("90%", "99.8%")) +
  #labs(color = "Per capita testing rate") +
  coord_cartesian(ylim=c(0, 1)) +
  geom_vline(xintercept = t0.wash+dates.wash[c(1,2,3,4)], color = "grey60") +
  annotate("text", x = t0.wash+dates.wash[1], y=0.4, label=paste("\nGeneral distancing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.wash+dates.wash[2], y=0.4, label=paste("\nStart testing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.wash+dates.wash[3], y=0.4, label=paste("\nSAH order lifted"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.wash+dates.wash[4], y=0.4, label=paste("\nOpen schools"), angle=90, color="grey40", size=5.5) +
  #ggtitle("New York City") +
  theme(legend.position='none',
        #legend.position=c(0.4, 0.8),    
        #legend.key = element_blank(),
        #legend.key.size = unit(0.4, "cm"),
        #legend.title = element_text(size=10),
        #legend.key.height = unit(0.4, "cm"),
        #legend.text = element_text(size=10),
        panel.background = element_rect(fill = "white", size = 0.2, linetype = "solid"),
        plot.title = element_text(hjust = 0),
        axis.title.x = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.title.y = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
        axis.text.x = element_text(colour = "black", size = 12),
        axis.text.y = element_text(colour = "black", size = 12),
        axis.line.x = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.line.y = element_line(colour = 'black', size=0.25, linetype='solid'),
        axis.ticks.length=unit(.25, "cm")) -> fig2b.wash; fig2b.wash



#fig2 <- ggarrange(fig2a.nyc, fig2a.wash,
#                  fig2b.nyc, fig2b.wash,
#                  nrow = 2, ncol = 2)

#fig2

fig2 <- ggarrange(fig2a.nyc, fig2a.sflor, fig2a.wash,
                  fig2b.nyc, fig2b.sflor, fig2b.wash,
                       nrow = 2, ncol = 3)

fig2

ggsave(fig2, file='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/MetroFits/Fig2_July2021_3sites.pdf', 
       width = 17, height = 10, units = "in",  dpi = 300)

#ggsave(fig2, file='/Users/aliciakraay/Dropbox/COVID Shields Emory/MetroFits/Fig2_June2021_2sites.pdf', 
#              width = 13, height = 9, units = "in",  dpi = 300)
#############
# FIGURE 3 
#############

ggplot(data=subset(model_time.nyc, model_time.nyc$start.time.test==dates.nyc[2] & model_time.nyc$alpha==5 & model_time.nyc$specificity %in% c(0.90, 0.998)), 
         aes(x=Date, y=CriticalCare, group = sweepnum, color = factor(testval))) +
  geom_line(aes(linetype=factor(specificity))) +
  scale_x_date(date_breaks='4 months',labels = date_format("%b-%Y"))+
  ylab("Critical care cases") +
  scale_color_viridis_d(option="plasma", begin = 0.1, end = 0.9, direction = -1,
                        name="Per capita testing rate",
                        labels=c("No testing", "1% per year", "10% per year",  "Yearly", "Monthly")) +
  #labs(color = "Per capita testing rate") +
  geom_vline(xintercept = t0.nyc+dates.nyc[c(1,2,3,4)], color = "grey60") +
  annotate("text", x = t0.nyc+dates.nyc[1], y=2000, label=paste("\nGeneral distancing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.nyc+dates.nyc[2], y=2000, label=paste("\nStart testing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.nyc+dates.nyc[3], y=2000, label=paste("\nSAH order lifted"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.nyc+dates.nyc[4], y=2000, label=paste("\nOpen schools"), angle=90, color="grey40", size=5.5) +
  ggtitle("New York City") +
  theme(legend.position='none',
    #legend.position=c(0.7, 0.7),    
    legend.key = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    legend.title = element_text(size=6),
    legend.key.height = unit(0.5, "cm"),
    legend.text = element_text(size=6),
    panel.background = element_rect(fill = "white", size = 0.5, linetype = "solid"),
    plot.title = element_text(hjust = 0),
    axis.title.x = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
    axis.title.y = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
    axis.text.x = element_text(colour = "black", size = 12),
    axis.text.y = element_text(colour = "black", size = 12),
    axis.line.x = element_line(colour = 'black', size=0.25, linetype='solid'),
    axis.line.y = element_line(colour = 'black', size=0.25, linetype='solid'),
    axis.ticks.length=unit(.25, "cm"))+
  labs(color='Per capita testing rate', linetype='Specificity')-> fig3.nyc; fig3.nyc


ggplot(data=subset(model_time.sflor, model_time.sflor$start.time.test==dates.sflor[2] & 
                     model_time.sflor$alpha==5 & model_time.sflor$specificity %in% c(0.90, 0.998)), 
       aes(x=Date, y=CriticalCare, group = sweepnum, color = factor(testval))) +
  geom_line(aes(linetype=factor(specificity))) +
  scale_x_date(date_breaks='4 months',labels = date_format("%b-%Y"))+
  ylab("Critical care cases") +
  scale_color_viridis_d(option="plasma", begin = 0.1, end = 0.9, direction = -1,
                        name="Per capita testing rate",
                        labels=c("No testing", "1% per year", "10% per year",  "Yearly", "Monthly")) +
  labs(color = "Per capita testing rate") +
  geom_vline(xintercept = t0.sfl+dates.sflor[c(1,2,3,4)], color = "grey60") +
  annotate("text", x = t0.sfl+dates.sflor[1], y=2000, label=paste("\nGeneral distancing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.sfl+dates.sflor[2], y=2000, label=paste("\nStart testing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.sfl+dates.sflor[3], y=2000, label=paste("\nSAH order lifted"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.sfl+dates.sflor[4], y=2000, label=paste("\nOpen schools"), angle=90, color="grey40", size=5.5) +
  ylim(0, 5000) +
  ggtitle("South Florida") +
  theme(legend.position='none',
    legend.key = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    legend.title = element_text(size=6),
    legend.key.height = unit(0.5, "cm"),
    legend.text = element_text(size=6),
    panel.background = element_rect(fill = "white", size = 0.5, linetype = "solid"),
    plot.title = element_text(hjust = 0),
    axis.title.x = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
    axis.title.y=element_blank(),
    #axis.title.y = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=12),
    axis.text.x = element_text(colour = "black", size = 12),
    axis.text.y = element_text(colour = "black", size = 12),
    axis.line.x = element_line(colour = 'black', size=0.25, linetype='solid'),
    axis.line.y = element_line(colour = 'black', size=0.25, linetype='solid'),
    axis.ticks.length=unit(.25, "cm"))+
  labs(color='Per capita testing rate', linetype='Specificity')-> fig3.sflor; fig3.sflor

ggplot(data=subset(model_time.wash, model_time.wash$start.time.test==dates.wash[2] & model_time.wash$alpha==5 & model_time.wash$specificity %in% c(0.90, 0.998)), 
       aes(x=Date, y=CriticalCare, group = sweepnum, color = factor(testval))) +
  geom_line(aes(linetype=factor(specificity))) +
  scale_x_date(date_breaks='4 months',labels = date_format("%b-%Y"))+
  ylab("Critical care cases") +
  scale_color_viridis_d(option="plasma", begin = 0.1, end = 0.9, direction = -1,
                        name="Per capita testing rate",
                        labels=c("No testing", "1% per year", "10% per year",  "Yearly", "Monthly")) +
  #labs(color = "Per capita testing rate") +
  geom_vline(xintercept = t0.wash+dates.wash[c(1,2, 3,4)], color = "grey60") +
  annotate("text", x = t0.wash+dates.wash[1], y=2000, label=paste("\nGeneral distancing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.wash+dates.wash[2], y=2000, label=paste("\nStart testing"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.wash+dates.wash[3], y=2000, label=paste("\nSAH order lifted"), angle=90, color="grey40", size=5.5) +
  annotate("text", x = t0.wash+dates.wash[4], y=2000, label=paste("\nOpen schools"), angle=90, color="grey40", size=5.5) +
  ylim(0, 5000) +
  ggtitle("Washington Puget Sound") +
  theme(legend.position='none',
    #legend.position=c(0.8, 0.7), 
    legend.key = element_blank(),
    legend.key.size = unit(0.5, "cm"),
    legend.title = element_text(size=6),
    legend.key.height = unit(0.5, "cm"),
    legend.text = element_text(size=6),
    panel.background = element_rect(fill = "white", size = 0.5, linetype = "solid"),
    plot.title = element_text(hjust = 0),
    axis.title.x = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=16),
    #axis.title.y = element_text(colour = "black", margin = margin(t = 10, r = 10, b = 0, l = 0), size=12),
    axis.title.y=element_blank(),
    axis.text.x = element_text(colour = "black", size = 12),
    axis.text.y = element_text(colour = "black", size = 12),
    axis.line.x = element_line(colour = 'black', size=0.25, linetype='solid'),
    axis.line.y = element_line(colour = 'black', size=0.25, linetype='solid'),
    axis.ticks.length=unit(.25, "cm"))+
  labs(color='Per capita testing rate', linetype='Specificity')-> fig3.wash; fig3.wash

#fig3 <- ggarrange(fig3.nyc, fig3.wash,
#                  nrow = 1, ncol = 2)

#fig3

#ggsave(fig3, file='/Users/aliciakraay/Dropbox/COVID Shields Emory/Fig3_June2021_2sites.pdf', 
#       width = 12, height = 4, units = "in",  dpi = 300)

fig3 <- ggarrange(fig3.nyc, fig3.sflor, fig3.wash,
                  nrow = 1, ncol = 3)

fig3


ggsave(fig3, file='/Users/aliciakraay/Dropbox/COVIDShieldsEmory/MetroFits/Fig3_July2021_3sites.pdf', 
       width = 14, height = 4, units = "in",  dpi = 300)


