clear
%% Load Data
input_sflor
pars_in = pars_sflor;

%% Setup
data.xdata = pars_in.times';
data.ydata = pars_in.target; % new deaths reported that day, t=1 == 2/27/2020

ssfun = @(Theta_in, Data_in) -2*SEIR_model_shields_LL(Data_in.xdata, Data_in.ydata, Theta_in, pars_in, false);
ssminfun = @(Theta_in) ssfun(Theta_in, data); % Wrapper for fminsearchbnd

%% Find a good starting point.
[tmin,ssmin]=fminsearchbnd(ssminfun,[0.02;0.25;0.3;0.1;0.25;0;0], [0;0;0;0;0;0;0], [0.05;1;1;1;1;100;100]);

SEIR_model_shields_LL(data.xdata, data.ydata, tmin, pars_in, true)

n = length(data.xdata);
p = 2;
mse = ssmin/(n-p); % estimate for the error variance

%% Set up MCMC
params = {
    {'q', tmin(1), 0, Inf}
    {'c', tmin(2), 0, 1}
    {'p_{sym}', tmin(3), 0, 1}
    {'sd_{red}', tmin(4), 0, 1}
    {'p_{red}', tmin(5), 0, 1}
    {'t_{targ}', tmin(6), 0, 30}
    {'init_{scale}', tmin(7), 0, Inf}
    };

model.ssfun  = ssfun;
model.sigma2 = mse; % (initial) error variance from residuals of the lsq fit

model.N = length(data.ydata);  % total number of observations

options.nsimu = 5000;
 
%% Run MCMC /w 2x burn-in

% 1
[res1,chain1,s2chain1] = mcmcrun(model,data,params,options);
[res1,chain1,s2chain1] = mcmcrun(model,data,params,options,res1);
[res1,chain1,s2chain1] = mcmcrun(model,data,params,options,res1);

% Modify for 2-4
options.nsimu = 5000;

% 2
params = {
    {'q', 2*tmin(1)*rand(1), 0, Inf}
    {'c', rand(1), 0, 1}
    {'p_{sym}', rand(1), 0, 1}
    {'sd_{red}', rand(1), 0, 1}
    {'p_{red}', rand(1), 0, 1}
    {'t_{targ}', 30*rand(1), 0, 30}
    {'init_{scale}', 100*rand(1), 0, Inf}
    };
[res2,chain2,s2chain2] = mcmcrun(model,data,params,options);
[res2,chain2,s2chain2] = mcmcrun(model,data,params,options,res2);
[res2,chain2,s2chain2] = mcmcrun(model,data,params,options,res2);

% 3
params = {
    {'q', 2*tmin(1)*rand(1), 0, Inf}
    {'c', rand(1), 0, 1}
    {'p_{sym}', rand(1), 0, 1}
    {'sd_{red}', rand(1), 0, 1}
    {'p_{red}', rand(1), 0, 1}
    {'t_{targ}', 30*rand(1), 0, 30}
    {'init_{scale}', 100*rand(1), 0, Inf}
    };
[res3,chain3,s2chain3] = mcmcrun(model,data,params,options);
[res3,chain3,s2chain3] = mcmcrun(model,data,params,options,res3);
[res3,chain3,s2chain3] = mcmcrun(model,data,params,options,res3);

% 4
params = {
    {'q', 2*tmin(1)*rand(1), 0, Inf}
    {'c', rand(1), 0, 1}
    {'p_{sym}', rand(1), 0, 1}
    {'sd_{red}', rand(1), 0, 1}
    {'p_{red}', rand(1), 0, 1}
    {'t_{targ}', 30*rand(1), 0, 30}
    {'init_{scale}', 100*rand(1), 0, Inf}
    };
[res4,chain4,s2chain4] = mcmcrun(model,data,params,options);
[res4,chain4,s2chain4] = mcmcrun(model,data,params,options,res4);
[res4,chain4,s2chain4] = mcmcrun(model,data,params,options,res4);

%SEIR_model_shields_LL(data.xdata, data.ydata, res1.mean, pars_in, true)

%% Eval MCMC
res = res3;
chain = chain3;

figure(2); clf
mcmcplot(chain,[],res,'chainpanel');
figure(3); clf
mcmcplot(chain,[],res,'pairs');
figure(4); clf
mcmcplot(chain,[],res,'denspanel',2);

% Did Model Converge?
chainstats(chain,res)

%% Predictions from MCMC
plot_MCMC_res(100, {chain1, chain2, chain3, chain4}, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, {res1, res2, res3, res4})

save OUTPUT/2020-09-11_MCMCRun_sflor_LANCET.mat
