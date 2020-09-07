clear
%% Load Data
input_wash
pars_in = pars_wash;

%% Setup
data.xdata = pars_in.times';
data.ydata = pars_in.target; % new deaths reported that day, t=1 == 2/27/2020

ssfun = @(Theta_in, Data_in) -2*SEIR_model_shields_LL(Data_in.xdata, Data_in.ydata, Theta_in, pars_in, false);
ssminfun = @(Theta_in) ssfun(Theta_in, data);
%% Find a good starting point.
[tmin,ssmin]=fminsearchbnd(ssminfun,[0.02;0.25;0.3;0.1;0.25;0], [0;0;0;0;0;0], [0.05;1;1;1;1;100]);

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
    {'t_{targ}', tmin(6), 0, Inf}
        %{'hosp_{frac}', tmin(6), 0, 1}
        %{'hosp_{crit}', tmin(6), 0, 1}
    };

model.ssfun  = ssfun;
model.sigma2 = mse; % (initial) error variance from residuals of the lsq fit

model.N = length(data.ydata);  % total number of observations

options.nsimu = 10000;
 
%% Run MCMC
% 2x burn-in 20000
[res_burn,chain,s2chain] = mcmcrun(model,data,params,options);
[res_burn,chain,s2chain] = mcmcrun(model,data,params,options,res_burn);

% 3x out
[res1,chain1,s2chain1] = mcmcrun(model,data,params,options,res_burn);
[res2,chain2,s2chain2] = mcmcrun(model,data,params,options,res_burn);
[res3,chain3,s2chain3] = mcmcrun(model,data,params,options,res_burn);

options.nsimu = 100000;
[res4,chain4,s2chain4] = mcmcrun(model,data,params,options,res_burn);


%% Eval MCMC
res = res4;
chain = chain4;

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

save OUTPUT/2020-09-07_MCMCRun_wash_PNAS.mat
