clear data model options
data.xdata = [28    55    83    110   138   225   375]';   % x (mg / L COD)
data.ydata = [0.053 0.060 0.112 0.105 0.099 0.122 0.125]'; % y (1 / h)

%data = csvread('us-ny.csv',3,2);


modelfun = @(x,theta) theta(3)*theta(1)*x./(theta(2)+x);
ssfun    = @(theta,data) sum((data.ydata-modelfun(data.xdata,theta)).^2);

[tmin,ssmin]=fminsearch(ssfun,[0.15;100;1],[],data)
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