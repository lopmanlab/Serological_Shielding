clear

theta_targ = [0.4, 1, 0.5, 0.5, 10];

%% Load NYC Pars
input_nyc

%% Define a Theta parameterset & Target
[t, y_targ, pars_targ] = SEIR_model_shields_ThetaSweep(theta_targ, pars_nyc.times, pars_nyc);

% Calculate New Deaths per Week
pars_targ.target = round(Calc_dD_dt_byWeek(y_targ, pars_targ))';

%% MCMC Start point:
pars_test = pars_nyc;
pars_test.target = pars_targ.target;

data.xdata = pars_test.times';
data.ydata = pars_test.target; % new deaths reported that day, t=1 == 2/27/2020

%% Find a good starting point.
ssfun = @(Theta_in, Data_in) -2*SEIR_model_shields_LL(Data_in.xdata, Data_in.ydata, Theta_in, pars_nyc, false);
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

options.nsimu = 4000;

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
modelfun = @(Data, Theta) SEIR_model_shields_MCMCPredict(Theta, Data(:,1), pars_test)';

nsample = 500;
out = mcmcpred(res,chain,s2chain,data.xdata,modelfun,nsample);

figure(4); clf
mcmcpredplot(out);
% add the 'y' observations to the plot
hold on
for i=1:3
  subplot(3,1,i)
  hold on
  plot(data.ydata(:,1),data.ydata(:,i+1),'s');
  ylabel(''); title(data.ylabels(i+1));
  hold off
end
xlabel('days');