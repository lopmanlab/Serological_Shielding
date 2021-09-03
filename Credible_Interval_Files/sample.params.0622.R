library(dplyr)
rm(list=ls()) #Clear workspace

nyc.chain.1 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain1.csv")
nyc.chain.2 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain2.csv")
nyc.chain.3 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain3.csv")
nyc.chain.4 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain4.csv")
nyc.chain.5 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain5.csv")
nyc.chain.6 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain6.csv")
nyc.chain.7 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain7.csv")
nyc.chain.8 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain8.csv")
nyc.chain.9 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain9.csv")
nyc.chain.10 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_nyc_NVarsFit5_chain10.csv")

sflor.chain.1 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain1.csv")
sflor.chain.2 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain2.csv")
sflor.chain.3 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain3.csv")
sflor.chain.4 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain4.csv")
sflor.chain.5 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain5.csv")
sflor.chain.6 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain6.csv")
sflor.chain.7 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain7.csv")
sflor.chain.8 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain8.csv")
sflor.chain.9 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain9.csv")
sflor.chain.10 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_sflor_NVarsFit5_chain10.csv")

wash.chain.1 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain1.csv")
wash.chain.2 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain2.csv")
wash.chain.3 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain3.csv")
wash.chain.4 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain4.csv")
wash.chain.5 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain5.csv")
wash.chain.6 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain6.csv")
wash.chain.7 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain7.csv")
wash.chain.8 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain8.csv")
wash.chain.9 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain9.csv")
wash.chain.10 <- read.csv("/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/MCMC_results_0504/2021-05-04_wash_NVarsFit5_chain10.csv")


nyc.all <- rbind(nyc.chain.1, nyc.chain.2, nyc.chain.3, nyc.chain.4, nyc.chain.5, nyc.chain.6, nyc.chain.7, nyc.chain.8, nyc.chain.9, nyc.chain.10)

sflor.all <- rbind(sflor.chain.1, sflor.chain.2, sflor.chain.3, sflor.chain.4, sflor.chain.5, sflor.chain.6, sflor.chain.7, sflor.chain.8, sflor.chain.9, sflor.chain.10)

wash.all <- rbind(wash.chain.1, wash.chain.2, wash.chain.3, wash.chain.4, wash.chain.5, wash.chain.6, wash.chain.7, wash.chain.8, wash.chain.9, wash.chain.10)


nyc.all %>%
  group_by(i_chain) %>%
  slice((n()-1000):n()) -> nyc.chains.lastk 

sflor.all %>%
  group_by(i_chain) %>%
  slice((n()-1000):n()) -> sflor.chains.lastk 

wash.all %>%
  group_by(i_chain) %>%
  slice((n()-1000):n()) -> wash.chains.lastk 


nyc.samp.params <- sample_n(nyc.chains.lastk, 20, replace = FALSE)
sflor.samp.params <- sample_n(sflor.chains.lastk, 20, replace = FALSE)
wash.samp.params <- sample_n(wash.chains.lastk, 20, replace = FALSE)

samp.params <- bind_rows(nyc.samp.params, sflor.samp.params, wash.samp.params, .id = "id")

samp.params %>%
  ungroup() %>%  
  dplyr::rename(S.c = S_c,
         S.a = S_a,
         S.rc	= S_rc,
         S.fc	= S_fc,
         S.e	= S_e,
         E.c	= E_c,
         E.a	= E_a,
         E.rc	= E_rc,
         E.fc	= E_fc,
         E.e	= E_e,
         Is.c	= Isym_c,
         Is.a	= Isym_a,
         Is.rc	= Isym_rc,
         Is.fc	= Isym_fc,
         Is.e	= Isym_e,
         Ia.c = Iasym_c,
         Ia.a =	Iasym_a,
         Ia.rc	= Iasym_rc,
         Ia.fc	= Iasym_fc,
         Ia.e	= Iasym_e,
         Hs.c = Hsub_c,
         Hs.a	= Hsub_a,
         Hs.rc	= Hsub_rc,
         Hs.fc	= Hsub_fc,
         Hs.e	= Hsub_e,
         Hc.c	= Hcri_c,
         Hc.a	= Hcri_a,
         Hc.rc = Hcri_rc,
         Hc.fc	= Hcri_fc,
         Hc.e	= Hcri_e,
         D.c	= D_c,
         D.a	= D_a,
         D.rc	= D_rc,
         D.fc	= D_fc,
         D.e	= D_e,
         R.c	= R_c,
         R.a	= R_a,
         R.rc	= R_rc,
         R.fc	= R_fc,
         R.e = R_e) %>%
  mutate(S.c.pos = 0,	E.c.pos = 0, Is.c.pos = 0, Ia.c.pos = 0,	R.c.pos = 0,
         S.a.pos = 0,	E.a.pos = 0,	Is.a.pos = 0,	Ia.a.pos = 0,	R.a.pos = 0,
         S.rc.pos = 0,	E.rc.pos = 0,	Is.rc.pos = 0,	Ia.rc.pos = 0,	R.rc.pos = 0,	
         D.fc = 0,	R.fc = 0,	S.fc.pos = 0,	E.fc.pos = 0,	Is.fc.pos = 0,	Ia.fc.pos = 0,	R.fc.pos = 0,
         S.e.pos = 0,	E.e.pos = 0,	Is.e.pos = 0,	Ia.e.pos = 0,	R.e.pos = 0, H.pos = 0,
          loc = ifelse(id==1, "nyc", 
                    ifelse(id==2, "sfl",
                             ifelse(id==3, "wash", 0)))) %>%
  select("id", "q", "c", "symptomatic_fraction", "socialDistancing_other", "p_reduced", 
         "LogLikelihood", "R0", "i_chain", "loc",
         "S.c",	"E.c",	"Is.c",	"Ia.c",	"Hs.c",	"Hc.c",	"D.c",	"R.c",	"S.c.pos",	"E.c.pos",	"Is.c.pos",	"Ia.c.pos",	"R.c.pos",	
         "S.a",	"E.a",	"Is.a",	"Ia.a",	"Hs.a",	"Hc.a",	"D.a",	"R.a",	"S.a.pos",	"E.a.pos",	"Is.a.pos",	"Ia.a.pos",	"R.a.pos",
         "S.rc",	"E.rc",	"Is.rc",	"Ia.rc",	"Hs.rc",	"Hc.rc",	"D.rc",	"R.rc",	"S.rc.pos",	"E.rc.pos",	"Is.rc.pos",	"Ia.rc.pos",	"R.rc.pos",	
         "S.fc",	"E.fc",	"Is.fc",	"Ia.fc",	"Hs.fc",	"Hc.fc",	"D.fc",	"R.fc",	"S.fc.pos",	"E.fc.pos",	"Is.fc.pos",	"Ia.fc.pos",	"R.fc.pos",	
         "S.e",	"E.e",	"Is.e",	"Ia.e",	"Hs.e",	"Hc.e",	"D.e",	"R.e",	"S.e.pos",	"E.e.pos",	"Is.e.pos",	"Ia.e.pos",	"R.e.pos",
         "H.pos") -> samp.params.1

write.csv(samp.params.1, "/Users/kristinnelson/OneDrive - Emory University/covid-19/Shielding/MCMC Results/samp.params.0622.csv")

