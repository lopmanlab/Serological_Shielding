rng default;  % For reproducibility
alpha = 2.43;
beta = 1;

theta_init = [0.5, 0.5, 0.5];

pdf = @(theta_init)SEIR_model_shields_pdf(theta_init,pars_in); % Target distribution

proppdf = @(x,y)gampdf(x,floor(alpha),floor(alpha)/alpha);
proprnd = @(x)sum(...
              exprnd(floor(alpha)/alpha,floor(alpha),1));
nsamples = 5000;
smpl = mhsample([1,1],nsamples,'pdf',pdf,'proprnd',proprnd,...
                'proppdf',proppdf);