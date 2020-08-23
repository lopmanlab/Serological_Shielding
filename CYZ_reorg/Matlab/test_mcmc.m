clear data model options

% Load NYC Data
input_nyc

data.tdata = pars_nyc.times';
data.ydata = pars_nyc.target; % new deaths reported that day, t=1 == 3/1/2020


%%%
ssfun = @(theta) -2*SEIR_model_shields_LL(data.tdata, data.ydata, theta, pars_nyc);
[tmin,ssmin]=fminsearchbnd(ssfun,[0.05; 0.25; 0.86; 0.25; 10], [0;0;0.5;0;1], [0.1;1;1;1;200]);


n = length(data.tdata);
p = 2;
mse = ssmin/(n-p) % estimate for the error variance

J = [data.tdata./(tmin(2)+data.tdata), ...
     -tmin(1).*data.tdata./(tmin(2)+data.tdata).^2];
tcov = inv(J'*J)*mse

params = {
    {'theta1', tmin(1), 0, 1}
    {'theta2', tmin(2), 0, 1}
    {'theta3', tmin(3), 0, 1}
    {'theta4', tmin(4), 0, 1}
    {'theta5', tmin(5), 0, 200}
    };

model.ssfun  = ssfun;
model.sigma2 = mse; % (initial) error variance from residuals of the lsq fit

model.N = length(data.ydata);  % total number of observations
model.S20 = model.sigma2;      % prior mean for sigma2
model.N0  = 4;                 % prior accuracy for sigma2

options.nsimu = 4000;
options.updatesigma = 1;
options.qcov = tcov; % covariance from the initial fit

[res,chain,s2chain] = mcmcrun(model,data,params,options);

figure(2); clf
mcmcplot(chain,[],res,'chainpanel');