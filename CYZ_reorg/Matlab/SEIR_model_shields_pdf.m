function loglikelihood = SEIR_model_shields_pdf(Theta, dDdt_target, Pars)
    % Set Default
    pars_in = Pars;
    
    % Change wrt Theta
    pars_in.q = Theta(1);
    pars_in.c = Theta(2);
    pars_in.p_symptomatic = Theta(3);
    
    pars_in.socialDistancing_other = Theta(5);
    pars_in.p_reduced = Theta(5);
    
    [t,y]=ode45(@SEIR_model_shields, [0:1:365], X0, opts, pars_in);

    tot_deaths = sum(y(:,pars_in.D_ids),2)';
    
    dDdt_days = tot_deaths(2:length(tot_deaths)) - ...
        tot_deaths(1:(length(tot_deaths)-1));
    
    
end