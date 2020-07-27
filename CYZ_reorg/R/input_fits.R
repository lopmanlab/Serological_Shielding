require('readxl')
source('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/Lopman Covid SeroPos/Serological_Shielding/CYZ_reorg/R/input_default.R')


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


# NYC
temp.nyc = read.csv('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/SERO_DATA/Deaths data/nyc.csv')
temp.nyc$wk = as.numeric(as.Date(temp.nyc[,2]) - as.Date('2020-01-01'))/7+1

v.nyc = rep(0, max(temp.nyc$wk))
v.nyc[temp.nyc$wk] = temp.nyc$wkdeaths

pars_nyc = pars_default
pars_nyc[['N']] = sum(temp.age[temp.age$Location=='NYC',4])
pars_nyc[['agefrac.0']] = NULL
pars_nyc[['agestruc']] = (as.vector(unlist(temp.age[temp.age$Location=='NYC',3])))

pars_nyc[['nDays']] = max(temp.nyc$wk)*7
pars_nyc[['times']] = 1:pars_nyc$nDays

pars_nyc[['daily_tests']] = 0
pars_nyc[['tStart_distancing']] = as.numeric(1+(as.Date(df.SAH['tStart_distancing', 'nyc'])-as.Date('2020-01-01')))
pars_nyc[['tStart_test']] = 500
pars_nyc[['tStart_target']] = 500
pars_nyc[['tStart_school']] = 500
pars_nyc[['tStart_reopen']] = 500


pars_nyc[['observed']] = v.nyc


rm(temp.SAH, df.SAH, temp.age, temp.nyc, v.nyc)