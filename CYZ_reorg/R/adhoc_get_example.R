th_opts = c(.04,.5,.5,10,.5)

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

v.obs = round(y_model_byWeek)
#v.obs = round(v.obs*(1+0.05*abs(rnorm(length(v.obs)))))