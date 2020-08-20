rm(list=ls())
require(MCMCpack)
require(adaptMCMC)
require(doParallel)

# (0) Load Data -----------------------------------------------------------

# Get Pars and Inits
source('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/Lopman Covid SeroPos/Serological_Shielding/CYZ_reorg/R/input_fits.R')
X0 = Get_Inits(pars_nyc_reduced_in)

# Observed Data
v.obs = pars_nyc_reduced_in$observed
  #source('C:/Users/czhao/Documents/CYZ GITHUB/Weitz Group/COVID-19/Lopman Covid SeroPos/Serological_Shielding/CYZ_reorg/R/adhoc_get_example.R')

# Theta Conditions
th_init = c(.04, 0.1, 0.25, 10, 0.25)
  #th_init = c(.05, .4, .4, 9, .4)
  #th_init = th_opts
th_min = c(0, 0, 0, 0, 0)
th_max = c(1, 1, 1, 60, 1)

# Logit-Transform
th_init = qlogis(th_init/(th_max-th_min))


# (1) Define Likelihood ---------------------------------------------------

seir_err = function(theta, y, X, Pars = pars_nyc_reduced_in){
  print(theta)
  # Un-transform
  th_norm = plogis(theta)
  th_ori = th_norm*(th_max-th_min)
  
  print(th_ori)
  
  # Load Parms
  Pars_in = Pars
  v.D_observed = y
  
  # Set relevant parameters to th_ori
  Pars_in[['q']] = th_ori[1]                        # Constrianed [0,0.1]
  Pars_in[['c']] = th_ori[2]                        # Constrianed [0,0.1]
  Pars_in[['p_symptomatic']] = th_ori[3]
  
  Pars_in[['socialDistancing_other']] = th_ori[5]
  Pars_in[['p_reduced']] = th_ori[5]
  
  # Timeshift 
  # - just means run the simulation for the shift, and use that as the new X0
  # - at least 10 timesteps /w increments of 0.1
  
  if(th_ori[4]){
    if(th_ori[4]<1){
      time_shift = 1:10*(th_ori[4]/10)
    }else if(th_ori[4]<10){
      temp_t = floor(th_ori[4]*10)
      time_shift = c((1:temp_t)/10, th_ori[4])
    }else{
      temp_t = floor(th_ori[4])
      time_shift = c((1:temp_t), th_ori[4])
    }
    
    model_shift = ode(y = X
                      , times = time_shift
                      , fun = seir_model_shields_reduced
                      , parms = Pars_in
                      , method = 'ode45')
    X0_shift = model_shift[nrow(model_shift),-1]
  }else{
    X0_shift = X
  }
  
  # Run with shift
  model_out = ode(y = X0_shift
                  , times = Pars_in$times
                  , fun = seir_model_shields_reduced
                  , parms = Pars_in
                  , method = 'ode45')
  
  model_out = as.data.frame(model_out)[,-1] # remove the time column
  
  # Cumulative Cases
  v.D_model_byDay = rowSums(model_out[, Pars_in$D_ids])
  v.D_model_byWeek = v.D_model_byDay[1:(length(v.D_model_byDay)/7)*7]
  
  # Aggregate by week
  v.D_model = v.D_model_byWeek
  
  # Calculate the log likelihood of the observed new case rates compared to the model rates
  #log_like = dnbinom(y, psi, mu=rho*v.D_model, log=TRUE) ## negative binomial regression with an improper uninform prior
  #log_like = dpois(x=y, lambda = v.D_model, log=TRUE)
  
  # These should be rates
  dDm.dt = v.D_model[2:length(v.D_model)] - v.D_model[1:(length(v.D_model)-1)]
  dDo.dt = y[2:length(y)] - y[1:(length(y)-1)]
  
  log_like = dpois(x=dDo.dt, lambda = dDm.dt, log=TRUE)
  
    #print(dDm.dt)
    #print(dDo.dt)
  print(sum(log_like))
  return(sum(log_like))
}


# # (2) Run MCMC ------------------------------------------------------------

post.samp = MCMCmetrop1R(seir_err
                         , theta.init=th_init
                         , y=v.obs
                         , X=X0
                         , mcmc=5000
                         , burnin=1000
                         , verbose=100
                         #, optim.method = 'L-BFGS-B'
                         #, optim.lower = c(-3, -1, -2, -4)
                         #, optim.upper = c(3, 1, 2, 4)
                         #, optim.control = list(ndeps=c(.1,.1,.1,.1))
                         , force.samp=TRUE
                         , logfun=TRUE
                         , seed=list(NA,1))

post.samp.out = sweep(plogis(post.samp), 2, (th_max-th_min), "*")
post.samp.out.tail= tail(post.samp.out, 1200)

df.post_samp = data.frame(post.samp.out.tail)
post.samp.optimal_parameters = apply(df.post_samp, 2, function(df_in){
  i_y=which.max(density(df_in)$y)
  x=density(df_in)$x[i_y]
  
  return(x)
})


# # (2) Sample Run ----------------------------------------------------------

th_opts = post.samp.optimal_parameters

# Get NYC Defualts
temp_pars = pars_nyc_reduced_in
temp_X0 = Get_Inits(temp_pars)

# Adjust with MCMC-learned values
temp_pars[['q']] = th_opts[1]
temp_pars[['c']] = th_opts[2]
temp_pars[['p_symptomatic']] = th_opts[3]

temp_pars[['socialDistancing_other']] = th_opts[5]
temp_pars[['p_reduced']] = th_opts[5]

# Timeshift - positive theta means earlier start
if(th_opts[4]){
  if(th_opts[4]<1){
    time_delay = 1:10*(th_opts[4]/10)
  }else if(th_opts[4]<10){
    min_time_delay = floor(th_opts[4]*10)
    time_delay = c((1:min_time_delay)/10, th_opts[4])
  }else{
    min_time_delay = floor(th_opts[4])
    time_delay = c((1:min_time_delay), th_opts[4])
  }
  model_shift = ode(y = temp_X0
                    , times = time_delay
                    , fun = seir_model_shields_reduced
                    , parms = temp_pars
                    , method = 'ode45')
  X_new_init = model_shift[nrow(model_shift),-1]
}else{
  X_new_init = temp_X0
}

# Get Inits
model_out = ode(y = X_new_init
                , times = temp_pars$times
                , fun = seir_model_shields_reduced
                , parms = temp_pars
                , method='ode45')
t = model_out[,1]
model_out = as.data.frame(model_out)[,-1] # remove the time column

# Prevalence
v.prev_byDay = temp_pars$N - rowSums(model_out[, temp_pars$S_ids])

# Cumulative Cases
y_model_byDay = rowSums(model_out[, temp_pars$D_ids])
v.D_byDay = as.vector(round(y_model_byDay))

# Aggregate by week
y_model_byWeek = y_model_byDay[1:(length(y_model_byDay)/7)*7]
v.D_byWeek = as.vector(round(y_model_byWeek))

# Rates
v.D_byDay_rate = c(0,v.D_byDay[-1] - v.D_byDay[-length(v.D_byDay)])
v.D_byWeek_rate = c(0,v.D_byWeek[-1] - v.D_byWeek[-length(v.D_byWeek)])

v.obs_rate = c(0,v.obs[-1] - v.obs[-length(v.obs)])

# Plot Cumulatives
temp.df = data.frame('D_model' = v.D_byDay, 'Prev_model' = v.prev_byDay/temp_pars$N, 'time' = t, 'D_obs' = NA)
temp.df$D_obs[1+7*(1:length(v.obs)-1)] = v.obs
temp.df$time = as.Date(pars_nyc_reduced_in$t0) + temp.df$time + 2

ggplot(temp.df, aes(x = time)) + 
  geom_line(size = 1, aes(y = D_model/1000, linetype = 'D_model')) + 
  #geom_line(size = 1, aes(y = Prev_model/1000, linetype = 'prevalence_model')) +
  #geom_hline(yintercept = temp_pars$N/1000, color = 'blue') + 
  geom_point(color = 'red', size = 2, aes(y = D_obs/1000, color = 'observed')) + 
  ylab('Deaths (x1000)') + 
  xlab(paste('Date (start date:', temp_pars$t0, ')', sep='', collapse=''))

# Plot Rates
temp.df_rate = data.frame('D_model' = v.D_byWeek_rate, 'time' = 1:(length(t)/7), 'D_obs' = v.obs_rate)

ggplot(temp.df_rate, aes(x = time)) + 
  geom_line(size = 1, aes(y = D_model/1000)) + 
  geom_point(color = 'red', size = 2, aes(y = D_obs/1000, color = 'observed')) + 
  ylab('Deaths (x1000)') + 
  xlab(paste('Days since ', temp_pars$t0, sep='', collapse=''))


#print((dnbinom(v.obs, 1, mu=y_model_byWeek, log=TRUE))).
tail(model_out)
print(v.D_byWeek)
print(v.obs)


# stats -------------------------------------------------------------------
X_init = temp_X0
X_fin = model_out[nrow(model_out),]

tot_D = sum(X_fin[pars_nyc_reduced_in$D_ids])
tot_infec = sum(X_fin[c(pars_nyc_reduced_in$D_ids, pars_nyc_reduced_in$R_ids, pars_nyc_reduced_in$Isym_ids, pars_nyc_reduced_in$Iasym_ids)])



# CFR = D/Sym


# IFR = D/total infections




# outputs -----------------------------------------------------------------
save(post.samp,post.samp.out, seir_err, th_init, th_max, th_min, X0, file='2020-08-14_Fit_TEST2-q-c-psymp-tstart-p_red-sd_other.R')

