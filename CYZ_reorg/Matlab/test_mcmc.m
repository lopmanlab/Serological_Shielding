clear data model options
ny_data = csvread('us-ny.csv',3,2);
temp_y = [0;ny_data(:,3)];
dydt = temp_y(2:123)-temp_y(1:122);

data.tdata = [1:1:122]';
data.ydata = dydt; % new deaths reported that day, t=1 == 3/1/2020


%%%
llfun = @(theta) -1*SEIR_model_shields_LL(data.tdata, data.ydata, theta, pars_default);
[tmin,llmin]=fminsearchbnd(llfun,[0.25; 0.25; 0.25; 0.25], [0;0;0;0], [1;1;1;1]);


n = length(data.xdata);
p = 2;
mse = ssmin/(n-p) % estimate for the error variance

J = [data.xdata./(tmin(2)+data.xdata), ...
     -tmin(1).*data.xdata./(tmin(2)+data.xdata).^2];
tcov = inv(J'*J)*mse

params = {
    {'theta1', tmin(1), 0}
    {'theta2', tmin(2), 0}
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