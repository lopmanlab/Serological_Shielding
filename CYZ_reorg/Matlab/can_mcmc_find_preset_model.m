clear

theta_targ = [0.4, 1, 0.5, 0.5, 10];

%% Load NYC Pars
input_nyc

%% Define a Theta parameterset & Target
[t, y_targ, pars_targ] = SEIR_model_shields_ThetaSweep(theta_targ, pars_nyc.times, pars_nyc);

% Calculate New Deaths per Week
pars_targ.target = round(Calc_dD_dt_byWeek(y_targ, pars_targ))';

%% MCMC Start point:
data.xdata = pars_targ.times';
data.ydata = pars_targ.target; % new deaths reported that day, t=1 == 2/27/2020

%% Find a good starting point.
ssfun = @(Theta_in, Data_in) -2*SEIR_model_shields_LL(Data_in.xdata, Data_in.ydata, Theta_in, pars_targ, false);
ssminfun = @(Theta_in) ssfun(Theta_in, data);
[tmin,ssmin]=fminsearchbnd(ssminfun,[0.2; 0.25; 0.3; 0.25; 5], [0;0;0;0;1], [1;1;1;1;200]);

SEIR_model_shields_LL(data.xdata, data.ydata, tmin, pars_nyc, true)

n = length(data.xdata);
p = 2;
mse = ssmin/(n-p); % estimate for the error variance

%% Set up MCMC
params = {
    {'q', tmin(1), 0, 1}
    {'c', tmin(2), 0, 1}
    {'p_{sym}', tmin(3), 0, 1}
    {'p_{red}; sd_{red}', tmin(4), 0, 1}
    {'I_{sym}^{a}(t=0)', tmin(5), 0, 200}
    };

model.ssfun  = ssfun;
model.sigma2 = mse; % (initial) error variance from residuals of the lsq fit

model.N = length(data.ydata);  % total number of observations
model.S20 = model.sigma2;      % prior mean for sigma2
model.N0  = 4;                 % prior accuracy for sigma2

options.nsimu = 10000;

%% Run MCMC
[res,chain,s2chain] = mcmcrun(model,data,params,options);

%% Eval MCMC
figure(2); clf
mcmcplot(chain,[],res,'chainpanel');
figure(3); clf
mcmcplot(chain,[],res,'pairs');
figure(4); clf
mcmcplot(chain,[],res,'denspanel',2);

% Did Model Converge?
chainstats(chain,res)

%% Predictions from MCMC

plot_MCMC_res(100, chain, ["S", "E", "Isym", "Iasym", "R", "D"], pars_nyc, res)

save OUTPUT/2020-08-26_MCMCRun.mat