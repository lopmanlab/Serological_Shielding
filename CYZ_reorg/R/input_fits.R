require('readxl')
source('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/Lopman Covid SeroPos/Serological_Shielding/CYZ_reorg/R/input_default.R')
source('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/Lopman Covid SeroPos/Serological_Shielding/CYZ_reorg/R/input_reduced.R')

# (0) Load Data -----------------------------------------------------------

# SAH orders
temp.SAH = read_xlsx('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/SERO_DATA/Deaths data/SAH orders by location.xlsx')

df.SAH = data.frame('wash' = c('2020-03-16', '2020-05-31')
                    , 'nyc' = c('2020-03-16', '2020-06-08')
                    , 'miami' = c('2020-03-17', '2020-05-20')
                    , 'miss' = c('2020-04-06', '2020-05-03')
                    , 'utah' = c('2020-03-17', '2020-05-01')
                    , 'conn' = c('2020-03-23', '2020-05-20'))
rownames(df.SAH) = c('tStart_distancing', 'tStop_distancing')

# Age structure
temp.age = read_xlsx('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/SERO_DATA/Deaths data/AgeStructure_byLocation.xlsx')

# New York Times Cases
temp.states = read.csv('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/SERO_DATA/07_29_2020_NYT_us-states.csv')


# NYC ---------------------------------------------------------------------

df.nyc = temp.states[temp.states$state == 'New York',]
temp.firstCase = '2020-03-01' # taken from NYT database

# Parse NYC death Data
#temp.nyc_Deaths = df.nyc[,c('date', 'deaths')]
temp.nyc_Deaths = read.csv('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/SERO_DATA/Deaths data/nyc.csv')
colnames(temp.nyc_Deaths)[2]='date'
temp.days_since_p0 = as.numeric(as.Date(temp.nyc_Deaths[,'date']) - as.Date(temp.firstCase))
temp.day_offset = min(temp.days_since_p0[which(temp.days_since_p0>0)])

temp.nyc_Deaths$wk = (temp.days_since_p0 - temp.day_offset)/7+1
temp.nyc_Deaths = temp.nyc_Deaths[temp.nyc_Deaths$wk>0,]

v.nyc = rep(0, max(temp.nyc_Deaths$wk))
v.nyc[temp.nyc_Deaths$wk] = temp.nyc_Deaths$wkdeaths

# Create pars for NYC
pars_nyc = list()
pars_nyc[['N']] = sum(temp.age[temp.age$Location=='NYC',4])
pars_nyc[['agefrac.0']] = NULL
pars_nyc[['agestruc']] = (as.vector(unlist(temp.age[temp.age$Location=='NYC',3])))

# Days
pars_nyc[['t0']] = temp.firstCase
pars_nyc[['nDays']] = max(temp.nyc_Deaths$wk)*7
pars_nyc[['times']] = 1:pars_nyc$nDays

# Only intervention is social distancing
pars_nyc[['daily_tests']] = 0
pars_nyc[['tStart_distancing']] = as.numeric(1+(as.Date(df.SAH['tStart_distancing', 'nyc'])-as.Date(temp.firstCase)))
pars_nyc[['tStart_test']] = 500
pars_nyc[['tStart_target']] = 500 #as.numeric(1+(as.Date(df.SAH['tStart_distancing', 'nyc'])-as.Date(temp.firstCase)))
pars_nyc[['tStart_school']] = 500 #as.numeric(1+(as.Date(df.SAH['tStart_distancing', 'nyc'])-as.Date(temp.firstCase)))
pars_nyc[['tStart_reopen']] = as.numeric(1+(as.Date(df.SAH['tStop_distancing', 'nyc'])-as.Date(temp.firstCase)))

# initial conditions - patient 0
pars_nyc[['Isym_c0']]=0
pars_nyc[['Isym_a0']]=1
pars_nyc[['Isym_rc0']]=0
pars_nyc[['Isym_fc0']]=0
pars_nyc[['Isym_e0']]=0

# we assume that a single reported symptomatic case implies a number of asymptomatic cases.
pars_nyc[['Iasym_c0']]=0
pars_nyc[['Iasym_a0']]=10
pars_nyc[['Iasym_rc0']]=0
pars_nyc[['Iasym_fc0']]=0
pars_nyc[['Iasym_e0']]=0

pars_nyc[['observed']] = v.nyc

# Modify Defaults
pars_nyc_in = pars_default
for(i.par in names(pars_nyc)){
  pars_nyc_in[[i.par]] = pars_nyc[[i.par]]
}

# Modify Defaults
pars_nyc_reduced_in = pars_reduced_default
for(i.par in names(pars_nyc)){
  pars_nyc_reduced_in[[i.par]] = pars_nyc[[i.par]]
}


rm(temp.SAH, df.SAH, temp.age, temp.nyc_Deaths, v.nyc, temp.firstCase)