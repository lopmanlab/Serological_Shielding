library(dplyr)

nyc.chains <- read.csv("/Users/aliciakraay/Dropbox/COVID Shields Emory/Chains_sampling/nyc_mcmc_unwtd_chains.csv")
sflor.chains <- read.csv("/Users/aliciakraay/Dropbox/COVID Shields Emory/Chains_sampling/Sfla_mcmc_unwtd_chains.csv")
wash.chains <- read.csv("/Users/aliciakraay/Dropbox/COVID Shields Emory/Chains_sampling/wash_mcmc_unwtd_chains.csv")

nyc.chainsr<-subset(nyc.chains, !(nyc.chains$i_chain=='1\\'))
nyc.chainsr$chain<-nyc.chainsr$i_chain
nyc.chainsr$chain[which(nyc.chainsr$chain %in% c('11\\', '11}'))]<-'11\\'

nyc.chainsr %>%
  group_by(chain) %>%
  slice((n()-5000):n()) -> nyc.chains.lastk 

sflor.chainsr<-subset(sflor.chains, !(sflor.chains$i_chain=='1\\'))
sflor.chainsr$chain<-sflor.chainsr$i_chain
sflor.chainsr$chain[which(sflor.chainsr$chain %in% c('11\\', '11}'))]<-'11\\'

sflor.chainsr %>%
  group_by(chain) %>%
  slice((n()-5000):n()) -> sflor.chains.lastk 

wash.chainsr<-subset(wash.chains, !(wash.chains$i_chain=='1\\'))
wash.chainsr$chain<-wash.chainsr$i_chain
wash.chainsr$chain[which(wash.chainsr$chain %in% c('11\\', '11}'))]<-'11\\'

wash.chainsr %>%
  group_by(chain) %>%
  slice((n()-5000):n()) -> wash.chains.lastk 


nyc.samp.params <- sample_n(nyc.chains.lastk, 20, replace = FALSE)
sflor.samp.params <- sample_n(sflor.chains.lastk, 20, replace = FALSE)
wash.samp.params <- sample_n(wash.chains.lastk, 20, replace = FALSE)

samp.params <- bind_rows(nyc.samp.params, sflor.samp.params, wash.samp.params, .id = "id")


samp.params %>%
  select(id, q, c, symptomatic_fraction, socialDistancing_other, p_reduced, Initial_Condition_Scale, R0, chain) %>%
  mutate(loc = ifelse(id==1, "nyc", 
               ifelse(id==2, "sfl",
               ifelse(id==3, "wash", 0)))) -> samp.params.1
 
samp.params.1$id_sample<-rep(seq(from=1, to=200, by=1), 3)
Inits<-read.csv('/Users/aliciakraay/Dropbox/COVID Shields Emory/Chains_sampling/2020-10-07_targetInits.csv') 

df.in = read.csv('/Users/aliciakraay/Dropbox/2020-10-07_targetInits.csv')[1:3,]
df.in2 = read.csv("/Users/aliciakraay/Dropbox/COVID Shields Emory/Summary_OUT.csv")

Rescale_target = function(init_cond=0.103, X0_target=Inits[1,-1]){
  mat.inits = matrix(unlist(X0_target), nrow=5)
  rownames(mat.inits) = c('c', 'a', 'rc', 'fc', 'e')
  colnames(mat.inits) = c('S', 'E', 'Isym', 'Iasym', 'Hsub', 'Hcri', 'D', 'R')
  
  mat.inits_rescaled = mat.inits
  mat.inits_rescaled[,"S"] = mat.inits[,"S"] - init_cond*rowSums(mat.inits[,c("E", "Isym", "Iasym")])
  mat.inits_rescaled[,c("E", "Isym", "Iasym")] = (1+init_cond)*mat.inits[,c("E", "Isym", "Iasym")]
  #Convert to vector
  vec<-as.numeric(c(mat.inits_rescaled[1,], rep(0, 5), mat.inits_rescaled[2,], rep(0, 5), mat.inits_rescaled[3,], rep(0, 5),
         mat.inits_rescaled[4,], rep(0, 5), mat.inits_rescaled[5,], rep(0, 5), 0))
    
  #print(mat.inits)
  #print(mat.inits_rescaled)
  return(vec)
}

Rescale_target()
Init.states<-data.frame(matrix(nrow=600, ncol=66))
names(Init.states)<-c('S.c', 'E.c', 'Is.c', 'Ia.c', 'Hs.c', 'Hc.c', 'D.c', 'R.c', 
                      'S.c.pos', 'E.c.pos', 'Is.c.pos', 'Ia.c.pos', 'R.c.pos',
                      'S.a', 'E.a', 'Is.a', 'Ia.a', 'Hs.a', 'Hc.a', 'D.a', 'R.a', 
                      'S.a.pos', 'E.a.pos', 'Is.a.pos', 'Ia.a.pos', 'R.a.pos', 
                      'S.rc', 'E.rc', 'Is.rc', 'Ia.rc', 'Hs.rc', 'Hc.rc', 'D.rc', 'R.rc', 
                      'S.rc.pos', 'E.rc.pos', 'Is.rc.pos', 'Ia.rc.pos', 'R.rc.pos',
                      'S.fc', 'E.fc', 'Is.fc', 'Ia.fc', 'Hs.fc', 'Hc.fc', 'D.fc', 'R.fc', 
                      'S.fc.pos', 'E.fc.pos', 'Is.fc.pos', 'Ia.fc.pos', 'R.fc.pos',
                      'S.e', 'E.e', 'Is.e', 'Ia.e', 'Hs.e', 'Hc.e', 'D.e', 'R.e', 'S.e.pos', 'E.e.pos', 'Is.e.pos', 'Ia.e.pos', 'R.e.pos',
                      'H.pos')
for(i in 1:nrow(samp.params.1)){
#for(i in 1:5){
  Init.states[i,]<-Rescale_target(init_cond=samp.params.1$Initial_Condition_Scale[i], X0_target=Inits[samp.params.1$id[i],-1])
}

samp.params.2<-cbind(samp.params.1, Init.states)
write.csv(samp.params.2, "/Users/aliciakraay/Dropbox/COVID Shields Emory/Chains_sampling/samp.params.2.csv")
