#General setup
require(deSolve)
require(ggplot2)
require(reshape2)
require(cowplot)
require(here)
require(plyr)
require(beepr)

source('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/Lopman Covid SeroPos/Serological_Shielding/CYZ_reorg/R/utils.R')

# (1) Model Parameters ----------------------------------------------------
model_pars_reduced=list()

# Population
model_pars_reduced[['N']]=323*10^6
model_pars_reduced[['agefrac.0']]=c(0.12,0.13,0.13,0.13,0.13,0.13,0.11,0.06,0.04,0.02) # from Weitz model
model_pars_reduced[['agestruc']]=c(sum(model_pars_reduced$agefrac.0[1:2])
                           , sum(model_pars_reduced$agefrac.0[3:6], 0.5*model_pars_reduced$agefrac.0[7])
                           , sum(0.5*model_pars_reduced$agefrac.0[7], model_pars_reduced$agefrac.0[8:10]))

# Timeline
model_pars_reduced[['t0']]='2020-01-01'
model_pars_reduced[['nDays']]=365 # days
model_pars_reduced[['times']]=0:model_pars_reduced$nDays

# Indices
model_pars_reduced[['subgroups']] = c('c', 'a', 'rc', 'fc', 'e')
model_pars_reduced[['nSubgroups']] = length(model_pars_reduced$subgroups) #ALWAYS: c, a, rc, fc, e
N=model_pars_reduced$nSubgroups

model_pars_reduced[['compartments']] = c('S', 'E', 'Isym', 'Iasym', 'Hsub', 'Hcri', 'D', 'R')
model_pars_reduced[['nCompartments']]=length(model_pars_reduced$compartments) #ALWAYS: S, E, Isym, Iasym, Hsub, Hcri, D, R, S_pos, E_pos, Isym_pos, Iasym_pos, R_pos
Nc=model_pars_reduced$nCompartments

# Variable Names
model_pars_reduced[['varNames']] = Get_Var_Names(model_pars_reduced$subgroups, model_pars_reduced$compartments)

temp_idxNames = 1:(N*Nc)
names(temp_idxNames) = model_pars_reduced$varNames
model_pars_reduced[['idxNames']] = temp_idxNames

# Variables in Matrix Format
temp.varMat = matrix(model_pars_reduced$varNames, ncol = Nc)
colnames(temp.varMat) = model_pars_reduced$compartments
rownames(temp.varMat) = model_pars_reduced$subgroups
model_pars_reduced[['varMat']] = temp.varMat #columns are compartments, rows are population subclasses

temp.idxMat = matrix(model_pars_reduced$idxNames, ncol = Nc)
colnames(temp.idxMat) = model_pars_reduced$compartments
rownames(temp.idxMat) = model_pars_reduced$subgroups
model_pars_reduced[['idxMat']] = temp.idxMat #columns are compartments, rows are population subclasses

# Base Compartment Indices
model_pars_reduced[['S_ids']]=0*N+(1:N)
model_pars_reduced[['E_ids']]=1*N+(1:N)
model_pars_reduced[['Isym_ids']]=2*N+(1:N)
model_pars_reduced[['Iasym_ids']]=3*N+(1:N)
model_pars_reduced[['Hsub_ids']]=4*N+(1:N)
model_pars_reduced[['Hcri_ids']]=5*N+(1:N)
model_pars_reduced[['D_ids']]=6*N+(1:N)
model_pars_reduced[['R_ids']]=7*N+(1:N)

# IDs by SubGroup
model_pars_reduced[['c_ids']]=(1:Nc-1)*N+1
model_pars_reduced[['a_ids']]=(1:Nc-1)*N+2
model_pars_reduced[['rc_ids']]=(1:Nc-1)*N+3
model_pars_reduced[['fc_ids']]=(1:Nc-1)*N+4
model_pars_reduced[['e_ids']]=(1:Nc-1)*N+5

model_pars_reduced[['nTotSubComp']]=N*Nc


# (2) Contact Parameters --------------------------------------------------
contact_pars_reduced=list()

contact_pars_reduced[['frac_home']]=0.316
contact_pars_reduced[['frac_full']]=0.0565
contact_pars_reduced[['frac_reduced']]=1-contact_pars_reduced$frac_full-contact_pars_reduced$frac_home

#3x3 data from Prem et al
contact_pars_reduced[['AllContacts']]=matrix(c(9.75, 2.57, 0.82, 5.97, 10.32, 2.25, 0.39, 0.46, 1.20), nrow=3)
contact_pars_reduced[['WorkContacts']]=matrix(c(0.20, 0.28, 0, 0.64, 4.73, 0, 0, 0, 0), nrow=3)
contact_pars_reduced[['SchoolContacts']]=matrix(c(4.32, 0.47, 0.02, 1.10, 0.32, 0.04, 0.01, 0.01, 0.03), nrow=3)
contact_pars_reduced[['HomeContacts']]=matrix(c(2.03, 1.02, 0.50, 2.37, 1.82, 0.68, 0.24, 0.14, 0.62), nrow=3)
contact_pars_reduced[['OtherContacts']]=matrix(c(3.20, 0.80, 0.30, 1.86, 3.45, 1.53, 0.14, 0.32, 0.55), nrow=3)

# 5x5 Expansions
contact_pars_reduced[['WorkContacts_5x5']]=Expand_5x5(contactMatrix=contact_pars_reduced$WorkContacts
                                              , p_Home=contact_pars_reduced$frac_home
                                              , p_Reduced=contact_pars_reduced$frac_reduced
                                              , p_Full=contact_pars_reduced$frac_full)
contact_pars_reduced[['HomeContacts_5x5']]=Expand_5x5(contactMatrix=contact_pars_reduced$HomeContacts
                                              , p_Home=contact_pars_reduced$frac_home
                                              , p_Reduced=contact_pars_reduced$frac_reduced
                                              , p_Full=contact_pars_reduced$frac_full)
contact_pars_reduced[['SchoolContacts_5x5']]=Expand_5x5(contactMatrix=contact_pars_reduced$SchoolContacts
                                                , p_Home=contact_pars_reduced$frac_home
                                                , p_Reduced=contact_pars_reduced$frac_reduced
                                                , p_Full=contact_pars_reduced$frac_full)
contact_pars_reduced[['OtherContacts_5x5']]=Expand_5x5(contactMatrix=contact_pars_reduced$OtherContacts
                                               , p_Home=contact_pars_reduced$frac_home
                                               , p_Reduced=contact_pars_reduced$frac_reduced
                                               , p_Full=contact_pars_reduced$frac_full)

# (3) Intervention Pars ---------------------------------------------------
intervention_pars_reduced=list()

# Test Data for Cellex (from April 2020)
intervention_pars_reduced[['sensitivity']]=1.00
intervention_pars_reduced[['specificity']]=0.998
intervention_pars_reduced[['daily_tests']]=10**3

# Other intervention parameters
intervention_pars_reduced[['tStart_distancing']]=70
intervention_pars_reduced[['tStart_test']]=107    # can change when in the outbreak testing becomes available
intervention_pars_reduced[['tStart_target']]=115
intervention_pars_reduced[['tStart_school']]=230
intervention_pars_reduced[['tStart_reopen']]=500

intervention_pars_reduced[['socialDistancing_other']]=0.25 # fraction of contacts reduced to when social distancing
intervention_pars_reduced[['p_reduced']]=0.5      # proportion of contacts reduced to
intervention_pars_reduced[['p_full']]=1           # proportion of contacts reduced to for full contact adults

intervention_pars_reduced[['alpha']]=1          # shielding. Note this is not alpha_JSW, but (alpha_JSW+1)
intervention_pars_reduced[['c']]=1

intervention_pars_reduced[['socialDistancing_other_c']]=0.25
intervention_pars_reduced[['p_reduced_c']]=0.1

# Modified 5x5s
temp.reduction = c(0,0,intervention_pars_reduced$p_reduced, intervention_pars_reduced$p_full,0)
contact_pars_reduced[['WorkContacts_Distancing_5x5']]=contact_pars_reduced$WorkContacts_5x5*temp.reduction
contact_pars_reduced[['OtherContacts_Distancing_5x5']]=contact_pars_reduced$OtherContacts_5x5*intervention_pars_reduced$socialDistancing_other

# (4) Epi Pars ------------------------------------------------------------
epi_pars_reduced=list()

epi_pars_reduced[['R0']]=3.1                # Note on R0: with base structure 63.28q
epi_pars_reduced[['q']]=epi_pars_reduced$R0/79.27   # Probability of transmission from children
epi_pars_reduced[['asymp_red']]=0.55        # Relative infectiousness of asymptomatic vs symptomatic case

epi_pars_reduced[['gamma_e']]=1/3           # Latent period (He et al)
epi_pars_reduced[['gamma_a']]=1/7           # Recovery rate, undocumented (Kissler et al)
epi_pars_reduced[['gamma_s']]=1/7           # Recovery rate, undocumented (Kissler et al)
epi_pars_reduced[['gamma_hs']]=1/5          # LOS for subcritical cases (medrxiv paper)
epi_pars_reduced[['gamma_hc']]=1/7          # LOS for critical cases (medrxiv paper)
epi_pars_reduced[['p_symptomatic']]=0.5#0.14            # Fraction 'Symptomatic'documented' (Shaman's paper)

epi_pars_reduced[['hosp_frac']]=c(0.002, 0.056, 0.224)  # From MMWR -- Of the symptomatic cases, how many are hospitalized?
epi_pars_reduced[['hosp_crit']]=c(0.001, 0.0048, 0.099) # From CDC, MMWR -- Of the symptomatic cases, how many are critically hospitalized?
epi_pars_reduced[['crit_die']]=c(0, 0.5, 0.5)           # Obtained from initial fitting

epi_pars_reduced[['hosp_frac_5']]=epi_pars_reduced$hosp_frac[c(1,2,2,2,3)]
epi_pars_reduced[['hosp_crit_5']]=epi_pars_reduced$hosp_crit[c(1,2,2,2,3)]
epi_pars_reduced[['crit_die_5']]=epi_pars_reduced$crit_die[c(1,2,2,2,3)]  

# Overwrite Using Ferguson Parms


# (5) Inits ---------------------------------------------------------------

# Initial conditions
inits=list()

inits[['Isym_c0']]=60
inits[['Isym_a0']]=20
inits[['Isym_rc0']]=50
inits[['Isym_fc0']]=1
inits[['Isym_e0']]=40

inits[['Iasym_c0']]=0
inits[['Iasym_a0']]=0
inits[['Iasym_rc0']]=0
inits[['Iasym_fc0']]=0
inits[['Iasym_e0']]=0


# (6) Remainder -----------------------------------------------------------

#Might want a ramp up period for these, ignore for now
tswitch1.dat=data.frame(times=model_pars_reduced$times, test.switch1=c(rep(1, 366)))
tswitch2.dat=data.frame(times=model_pars_reduced$times, test.switch2=c(rep(0, 366)))

sw1fxn=approxfun(tswitch1.dat$times, tswitch1.dat$test.switch1, rule=2)
sw2fxn=approxfun(tswitch2.dat$times, tswitch2.dat$test.switch2, rule=2)

# Combine
pars_reduced_default = c(model_pars_reduced, contact_pars_reduced, intervention_pars_reduced, epi_pars_reduced, inits)
# pars_reduced_default = list('model_pars_reduced' = model_pars_reduced
#                     , 'contact_pars_reduced' = contact_pars_reduced
#                     , 'intervention_pars_reduced'= intervention_pars_reduced
#                     , 'epi_pars_reduced' = epi_pars_reduced)


# (7) Test Cases ----------------------------------------------------------

X0_reduced = Get_Inits(pars_reduced_default)

# # Test
# set.seed(1234)
# Xtest = round(runif(length(X0))*pars_reduced_default$N)
# names(Xtest) = names(X0)
# 
# seir_model_shields_rcfc_nolatent(0, X0, pars_reduced_default)
