#Table S3
AllContacts<-matrix(data=c(9.75, 2.57, 0.82, 5.97, 10.32, 2.25, 0.39, 0.46, 1.20), nrow=3)
WorkContacts<-matrix(data=c(0.20, 0.28, 0, 0.64, 4.73, 0, 0, 0, 0), nrow=3)
SchoolContacts<-matrix(data=c(4.32, 0.47, 0.02, 1.10, 0.32, 0.04, 0.01, 0.01, 0.03), nrow=3)
HomeContacts<-matrix(data=c(2.03, 1.02, 0.50, 2.37, 1.82, 0.68, 0.24, 0.14, 0.62), nrow=3)
OtherContacts<-matrix(data=c(3.20, 0.80, 0.30, 1.86, 3.45, 1.53, 0.14, 0.32, 0.55), nrow=3)
#Expand the 3x3 matrix to a 5x5 based on the fraction of the population in each of the worker
#subgroups
expand_5x5<-function(oldmatrix, phome, preduced, pfull){
  newmatrix<-matrix(NA, ncol=5, nrow=5)
  newmatrix[1,1]<-oldmatrix[1,1]
  newmatrix[2:4,1]<-oldmatrix[2,1]
  newmatrix[5,1]<-oldmatrix[3,1]
  newmatrix[1,5]<-oldmatrix[1,3]
  newmatrix[2:4,5]<-oldmatrix[2,3]
  newmatrix[5,5]<-oldmatrix[3,3]
  vec1<-c(oldmatrix[1,2]*phome, oldmatrix[1,2]*preduced, oldmatrix[1,2]*pfull)
  newmatrix[1,2:4]<-vec1
  vec2<-c(oldmatrix[2,2]*phome, oldmatrix[2,2]*preduced, oldmatrix[2,2]*pfull)
  newmatrix[2,2:4]<-vec2
  newmatrix[3,2:4]<-vec2
  newmatrix[4,2:4]<-vec2
  vec3<-c(oldmatrix[3,2]*phome, oldmatrix[3,2]*preduced, oldmatrix[3,2]*pfull)
  newmatrix[5,2:4]<-vec3
  newmatrix
}

prob.home<-0.316
#prob.home<-0.4
prob.full<-0.0565
prob.reduced<-1-prob.full-prob.home
#prob.reduced<-0.678
#preduced<-0.5
pfull<-1
#sd.other<-0.25

WorkContacts_5x5<-expand_5x5(oldmatrix=WorkContacts, 
                             phome=prob.home, preduced=prob.reduced, pfull=prob.full)
HomeContacts_5x5<-expand_5x5(oldmatrix=HomeContacts, 
                             phome=prob.home, preduced=prob.reduced, pfull=prob.full)
SchoolContacts_5x5<-expand_5x5(oldmatrix=SchoolContacts, 
                               phome=prob.home, preduced=prob.reduced, pfull=prob.full)
OtherContacts_5x5<-expand_5x5(oldmatrix=OtherContacts, 
                              phome=prob.home, preduced=prob.reduced, pfull=prob.full)

WorkContacts2<-WorkContacts_5x5
WorkContacts2[2,]<-0
WorkContacts2[3,]<-(1-((1-0.641)*0.366))*WorkContacts_5x5[3,]
NYC.work<-(sum(WorkContacts2[2,])*0.316)+(sum(WorkContacts2[3,])*(1-(0.316+0.0565)))+(sum(WorkContacts2[4,])*0.0565)
(sum(WorkContacts[2,])-NYC.work)/sum(WorkContacts[2,]) #0.398

WorkContacts3<-WorkContacts_5x5
WorkContacts3[2,]<-0
WorkContacts3[3,]<-(1-((1-0.241)*0.8))*WorkContacts_5x5[3,]
Sflor.work<-(sum(WorkContacts3[2,])*0.316)+(sum(WorkContacts3[3,])*(1-(0.316+0.0565)))+(sum(WorkContacts3[4,])*0.0565)
(sum(WorkContacts[2,])-Sflor.work)/sum(WorkContacts[2,]) #0.697

WorkContacts4<-WorkContacts_5x5
WorkContacts4[2,]<-0
WorkContacts4[3,]<-(1-((1-0.202)*0.156))*WorkContacts_5x5[3,]
Wash.work<-(sum(WorkContacts4[2,])*0.316)+(sum(WorkContacts4[3,])*(1-(0.316+0.0565)))+(sum(WorkContacts4[4,])*0.0565)
(sum(WorkContacts[2,])-Wash.work)/sum(WorkContacts[2,]) #0.394

#1-((1-sd.other)*c)

NYC.adults<-HomeContacts+(0.5*SchoolContacts)+((1-0.356)*OtherContacts)+((1-0.398)*WorkContacts)
Sflor.adults<-HomeContacts+(0.5*SchoolContacts)+((1-0.704)*OtherContacts)+((1-0.697)*WorkContacts)
Wash.adults<-HomeContacts+(0.5*SchoolContacts)+((1-0.105)*OtherContacts)+((1-0.321)*WorkContacts)

(sum(AllContacts[2,])-sum(NYC.adults[2,]))/sum(AllContacts[2,])
(sum(AllContacts[2,])-sum(Sflor.adults[2,]))/sum(AllContacts[2,])
(sum(AllContacts[2,])-sum(Wash.adults[2,]))/sum(AllContacts[2,])

NYC.old<-HomeContacts+(0.5*SchoolContacts)+((1-0.356)*OtherContacts)
Sflor.old<-HomeContacts+(0.5*SchoolContacts)+((1-0.704)*OtherContacts)
Wash.old<-HomeContacts+(0.5*SchoolContacts)+((1-0.105)*OtherContacts)

(sum(AllContacts[3,])-sum(NYC.old[3,]))/sum(AllContacts[3,])
(sum(AllContacts[3,])-sum(Sflor.old[3,]))/sum(AllContacts[3,])
(sum(AllContacts[3,])-sum(Wash.old[3,]))/sum(AllContacts[3,])