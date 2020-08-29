clear
%% Load Data
input_sflor
pars_in = pars_sflor;

%% Setup
data.xdata = pars_in.times';
data.ydata = pars_in.target; % new deaths reported that day, t=1 == 2/27/2020

ssfun = @(Theta_in, Data_in) -2*SEIR_model_shields_LL(Data_in.xdata, Data_in.ydata, Theta_in, pars_in, false);
ssminfun = @(Theta_in) ssfun(Theta_in, data);
%% Find a good starting point.
[tmin,ssmin]=fminsearchbnd(ssminfun,[0.02;0.25;0.3;0.25;5;0], [0;0;0;0;1;0], [0.05;1;1;1;100000;500]);

SEIR_model_shields_LL(data.xdata, data.ydata, tmin, pars_in, true)

n = length(data.xdata);
p = 2;
mse = ssmin/(n-p) % estimate for the error variance

%% Set up MCMC
params = {
    {'q', tmin(1), 0, 0.05}
    {'c', tmin(2), 0, 1}
    {'p_{sym}', tmin(3), 0, 1}
    {'p_{red}; sd_{red}', tmin(4), 0, 1}
    {'I_{sym}^{a}(t=0)', tmin(5), 0, Inf}
    {'t_{targ}', tmin(6), 0, 500}
        %{'hosp_{frac}', tmin(6), 0, 1}
        %{'hosp_{crit}', tmin(6), 0, 1}
    };

model.ssfun  = ssfun;
model.sigma2 = mse; % (initial) error variance from residuals of the lsq fit

model.N = length(data.ydata);  % total number of observations
%model.S20 = model.sigma2;      % prior mean for sigma2
%model.N0  = 4;                 % prior accuracy for sigma2

options.nsimu = 10000;

%% Run MCMC
[res,chain,s2chain] = mcmcrun(model,data,params,options);
[res,chain,s2chain] = mcmcrun(model,data,params,options,res);
[res,chain,s2chain] = mcmcrun(model,data,params,options,res);

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
plot_MCMC_res(100, chain, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, res)

save OUTPUT/2020-08-28_MCMCRun_sflor.mat
