function loglikelihood = SEIR_model_shields_LL(times, dYdt_target, Theta, Pars)
    % Set Default
    pars_in = Pars;
    
    % Change wrt Theta
    pars_in.q = Theta(1);
    pars_in.c = Theta(2);
    pars_in.p_symptomatic = Theta(3);
    
    pars_in.socialDistancing_other = Theta(4);
    pars_in.p_reduced = Theta(4);
    
    % ODE Options
    opts=odeset();
    
    % ODE Parameters
    X0 = Get_Inits(pars_in);

    [t,y]=ode45(@SEIR_model_shields, times, X0, opts, pars_in);

    tot_deaths = [0; sum(y(:,pars_in.D_ids),2)];
    
    dYdt_model = tot_deaths(2:length(tot_deaths)) - ...
        tot_deaths(1:(length(tot_deaths)-1));
    
    %% Currently running into an issue where the model suggests I have 0 deaths but the actual says more than 0, which pushes log likelihood to -Inf.
    xs = dYdt_target(12:length(dYdt_target))';
    lambdas = round(dYdt_model(12:length(dYdt_target)))';
    
    [xs;lambdas]'
    
    % Dont' forget poisspdf(1,0) is 0.
    likelihoods = poisspdf(xs, lambdas);
    
    loglikelihood = sum(log(likelihoods));
end