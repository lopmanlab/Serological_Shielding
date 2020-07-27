rm(list=ls())
require(MCMCpack)

# Get Pars and Inits
source('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/Lopman Covid SeroPos/Serological_Shielding/CYZ_reorg/R/input_fits.R')
X0 = Get_Inits(pars_nyc)

# Observed Data
v.obs = pars_nyc$observed
v.obs_rate = c(0,v.obs[2:length(v.obs)] - v.obs[1:(length(v.obs)-1)])

  # TODO: Figre out parameters, figure out initial conditions, and fit specifics
psi = 1 #overdispersion parameter
  #rho = 0.9 #reporting rate
tolerance = 1e-20

## negative binomial regression with an improper unform prior
## X and y are passed as args to MCMCmetrop1R
seir_err = function(theta, y, X){
  print(theta)
  pars_nyc[['q']] = exp(theta[1])
    #pars_nyc[['socialDistancing_other']] = exp(theta[2])
    #pars_nyc[['p_full']] = exp(theta[3])
    #pars_nyc[['p_reduced']] = exp(theta[4])
  rho = exp(theta[2])
  
  # Run Model
  model_out = ode(y = X
                  , times = pars_nyc$times
                  , fun = seir_model_shields_rcfc_nolatent
                  , parms = pars_nyc
                  , method='ode45')
  model_out = as.data.frame(model_out)[,-1]
  
  # Extract new cases by day
  y_model_byDay = rowSums(model_out[, pars_nyc$D_ids])
  y_rates = y_model_byDay[2:length(y_model_byDay)] - y_model_byDay[1:(length(y_model_byDay)-1)]
  y_rates = c(0, y_rates)
  
  # Aggregate by week
  v.model = unlist(lapply(split(y_rates, rep(1:(length(y_model_byDay)/7), each=7)), sum)) 
  
  # Likelihood of v.obs given v.model
  log_like = dnbinom(y, psi, mu=rho*v.model+tolerance, log=TRUE)
  return(sum(log_like))
}

post.samp = MCMCmetrop1R(seir_err
                          , theta.init=c(-1,0)
                          , y=v.obs
                          , X=X0
                          , mcmc=3000
                          , burnin=1000
                          , verbose=100
                          , logfun=TRUE
                          , seed=list(NA,1))

