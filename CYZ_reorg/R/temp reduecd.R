# 08.14.2020 - This is an ad-hoc test script to develop  the seir_model_shields_reduced function.
source('input_fits.R')

seir_model_shields_reduced = function(t, X, Pars) {
  # Core transmission model
  #   - Subscripts are defined as follows: c=children, a=non-essential adults, 
  #     rc=reduced contact adults, fc=full contact adults, e=elderly
  #   - For infection equations: The I compartments correspond to infectious 
  #     periods, not periods in which people are symptomatic
  #   - Is are cases that are severe enough to be documented eventually and Ia are undocumented cases
  #   - Since we are not fitting to data we do not need to model specifically when the cases are documented 
  #   - _pos indicates people who have tested positive for COVID-19 by antibody test
  
  
  test.switch1<-sw1fxn(t)
  test.switch2<-sw2fxn(t)
  
  # (0) Setup ---------------------------------------------------------------
  
  # Load all pars
  for(i_par in 1:length(Pars)){
    assign(names(Pars)[i_par], Pars[[i_par]])
  }
  
  # Update Pars
  socialDistancing_other_c = 1-(0.75*c)
  p_reduced_c = 1-(0.9*c)
  
  # Load all Vars
  for(i_var in 1:length(X)){
    assign(names(X)[i_var], X[[i_var]])
  }
  
  # Load in Matrix Form
  mat_X = Vec_to_Mat(X, Subgroups=subgroups, Compartments=compartments)
  
  # Number of infections at time t for each subgroup
  infec = asymp_red*mat_X[,'Iasym'] + mat_X[,'Isym']
  
  # Population sizes/testing status at time t    
  tot = rowSums(mat_X[,colnames(mat_X)!='D'])
  
  #Fraction of population in each group who has tested positive by time
  frac_released = 0
  frac_distanced = rep(1,5)
  frac_comb = as.vector(rbind(frac_released, frac_distanced)) # interleaved
  
  # (1) Derive Contact Matrices ---------------------------------------------

  #Change matrices used over time
  if(t<tStart_distancing | t>=tStart_reopen){ #Use baseline matrices until social distancing starts
    CM = HomeContacts_5x5 + 
      SchoolContacts_5x5 + 
      WorkContacts_5x5 +
      OtherContacts_5x5
  }
  
  if(t>=tStart_distancing & t<tStart_reopen){
    # if(t>=tStart_distancing & t<tStart_target){ #Use these matrices under general social distancing without testing
    CM = HomeContacts_5x5 +
      WorkContacts_Distancing_5x5 +
      OtherContacts_Distancing_5x5
  }
  
  
  # (3) Calculate v.fois ------------------------------------------------------
  
  # Force of infection by group 
  temp.I = infec/tot
  temp.I = t(t(CM)*temp.I)*q
  v.fois = rowSums(temp.I)
  names(v.fois) = c('foi_c_gen','foi_a_gen', 'foi_rc_gen', 'foi_fc_gen', 'foi_e_gen')

  # (4) Sero Testing --------------------------------------------------------
  
  # NONE
  
  
  # (5) Model Equations -----------------------------------------------------
  dS = -v.fois*mat_X[,'S'] - 
    (1-specificity)*test.switch2*1*mat_X[,'S']
  
  dE = v.fois*mat_X[,'S'] - 
    gamma_e*mat_X[,'E'] - 
    (1-specificity)*test.switch2*1*mat_X[,'E']
  
  dIsym = p_symptomatic*gamma_e*mat_X[,'E'] - 
    gamma_s*mat_X[,'Isym']
  
  dIasym = (1-p_symptomatic)*gamma_e*mat_X[,'E'] - 
    gamma_a*mat_X[,'Iasym'] - 
    (1-specificity)*test.switch2*1*mat_X[,'Iasym']
  
  dHsub = gamma_s*(hosp_frac_5-hosp_crit_5)*mat_X[,'Isym'] - 
    gamma_hs*mat_X[,'Hsub']
  
  dHcri = gamma_s*hosp_crit_5*mat_X[,'Isym'] - 
    gamma_hc*mat_X[,'Hcri']
  
  dD = gamma_hc*crit_die_5*mat_X[,'Hcri']
  
  dR = gamma_s*(1-hosp_frac_5)*mat_X[,'Isym'] + 
    gamma_a*mat_X[,'Iasym'] + 
    (1-sensitivity)*test.switch2*gamma_hs*mat_X[,'Hsub'] + 
    (1-sensitivity)*test.switch2*gamma_hc*(1-crit_die_5)*mat_X[,'Hcri'] - 
    sensitivity*test.switch2*1*mat_X[,'R'] + 
    gamma_hc*test.switch1*(1-crit_die_5)*mat_X[,'Hcri'] + 
    gamma_hs*test.switch1*mat_X[,'Hsub']
  
  res = c(dS, dE, dIsym, dIasym, dHsub, dHcri, dD, dR)
  names(res) = varNames
  
  return(list(res))
}

X = Get_Inits(pars_reduced_default)
seir_model_shields_reduced(0, X, pars_reduced_default)


sd



test1 = ode(y = Get_Inits(pars_nyc_reduced_in)
    , times = pars_nyc_reduced_in$times
    , fun = seir_model_shields_reduced
    , parms = pars_nyc_reduced_in
    , method = 'ode45')

test2 = ode(y = Get_Inits(pars_nyc_in)
            , times = pars_nyc_in$times
            , fun = seir_model_shields_rcfc_nolatent
            , parms = pars_nyc_in
            , method = 'ode45')

merp = data.frame('t' = pars_nyc_reduced_in$times
                  , 'red' = rowSums(test1[,-1][,pars_nyc_reduced_in$S_ids])
                  , 'full' = rowSums(test2[,-1][,pars_nyc_in$S_ids]))


ggplot(merp, aes(x = t)) + 
  geom_point(aes(y = red, color = 'red')) + 
  geom_point(aes(y = full, color='full'))
