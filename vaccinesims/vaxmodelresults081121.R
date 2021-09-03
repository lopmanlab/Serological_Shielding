June1<-as.Date('06/01/2021', format='%m/%d/%Y')

############
#WASH
############

load("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/Results/Wash_Reopening_SweepLong_AddVax_July2021.RData")

t0.wash<-as.Date('02/13/2020', format='%m/%d/%Y')
june.wash<-June1-t0.wash

End.wash <- subset(model_time, model_time$time==june.wash)

subset(End.wash, testval == (N/30) & # no testing (0), yearly (N/365) and monthly (N/30)
         start.time.test == 248 & # early is 108, late is 262
         alpha == 5 &
         specificity == 0.998,
       select=c(testval, alpha, specificity, start.time.test, Deaths, PR.released, FracReleased, CI, CriticalCare)) 

# + Vax Deaths: 5884.279
#FracReleased: 0.8150754
#CI: 0.7745907    
#CriticalCare: 0.0245416

load("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/Results/Wash_Reopening_July14.RData")

End.wash <- subset(model_time, model_time$time==june.wash)

subset(End.wash, testval == (N/30) & # no testing (0), yearly (N/365) and monthly (N/30)
         start.time.test == 262 & # early is 108, late is 262
         alpha == 5 &
         specificity == 0.998,
       select=c(testval, alpha, specificity, start.time.test, Deaths, PR.released, FracReleased, CI, CriticalCare))

# Shielding alone Deaths: 7861.055
#FracReleased: 0.2072572
#CI: 0.1967317
#CriticalCare: 3.27447

subset(End.wash, testval == 0 ,
       select=c(testval, alpha, specificity, start.time.test, Deaths, PR.released, FracReleased, CI, CriticalCare))

# No intervention deaths: 19155.95 
              
############
#NYC
############
load("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/Results/NYC_Reopening_AddVax.RData")
t0.nyc<-as.Date('02/20/2020', format='%m/%d/%Y')
june.nyc<-as.numeric(June1-t0.nyc)

End.nyc <- subset(model_time, model_time$time==june.nyc)

subset(End.nyc, testval == (N/30) & # no testing (0), yearly (N/365) and monthly (N/30)
         start.time.test == 255 & # early is 109, late is 255
         alpha == 5 &
         specificity == 0.998,
       select=c(testval, alpha, specificity, start.time.test, Deaths, FracReleased,  PR.released, CI, CriticalCare)) 

# + Vax Deaths: 41012.02
#FracReleased: 0.870491
#CI: 0.8487413
#CriticalCare: 0.000324529



load("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/Results/NY_Reopening_July14.RData")


End.nyc <- subset(model_time, model_time$time==june.nyc)

subset(End.nyc, testval == (N/30) & # no testing (0), yearly (N/365) and monthly (N/30)
         start.time.test == 255 & # early is 109, late is 255
         alpha == 5 &
         specificity == 0.998,
       select=c(testval, alpha, specificity, start.time.test, Deaths, FracReleased,  PR.released,  CI, CriticalCare)) 

# Shielding alone Deaths: 39273.91
#FracReleased: 0.5132617 
#CI: 0.9745527
#CriticalCare:0.01328576

subset(End.nyc, testval == 0 ,
       select=c(testval, alpha, specificity, start.time.test, Deaths, PR.released, FracReleased, CI, CriticalCare))

# No intervention deaths: 42576.15


#SFLOR
load("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/Results/SFlor_Reopening_SweepLong_AddVax_July2021.RData")

t0.sfl<-as.Date('02/27/2020', format='%m/%d/%Y')
june.sfl<-as.numeric(June1-t0.sfl)

End.sflor <- subset(model_time, model_time$time==june.sfl)

subset(End.sflor, testval == (N/30) & # no testing (0), yearly (N/365) and monthly (N/30)
         start.time.test == 248 & # early is 83, late is 248
         alpha == 5 &
         specificity == 0.998,
       select=c(testval, alpha, specificity, start.time.test, Deaths, FracReleased, CI, CriticalCare)) 

# + Vax deaths: 8851.812
#FracReleased: 0.8868662
#CI: 0.8546208
#CriticalCare:0.002589529



load("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/Results/SFlor_Reopening_July14.RData")

End.sflor <- subset(model_time, model_time$time==june.sfl)

subset(End.sflor, testval == (N/30) & # no testing (0), yearly (N/365) and monthly (N/30)
         start.time.test == 248 & # early is 83, late is 248
         alpha == 5 &
         specificity == 0.998,
       select=c(testval, alpha, specificity, start.time.test, Deaths, FracReleased, CI, CriticalCare)) 

# Shielding alone deaths: 8876.865
#FracReleased: 0.4067076 
#CI: 0.3948961
#CriticalCare: 0.1275447

subset(End.sflor, testval == 0 ,
       select=c(testval, alpha, specificity, start.time.test, Deaths, PR.released, FracReleased, CI, CriticalCare))

# No intervention deaths: 10368.13



#Compare deaths in main scenario (sp = 0.998, late start testing, aalpha = 5, monthly testing)
# Deaths very similar in shielding and shielding + vax scenarios inn Sflor and Wash, in NYC +vax adds to deaths?
