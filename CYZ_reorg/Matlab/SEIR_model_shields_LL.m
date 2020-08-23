function loglikelihood = SEIR_model_shields_LL(times, dYdt_target, Theta, Pars)
    % Set Default
    pars_in = Pars;
    
    % Change wrt Theta
    pars_in.q = Theta(1);
    pars_in.c = Theta(2);
    pars_in.p_symptomatic = Theta(3);
    
    pars_in.socialDistancing_other = Theta(4);
    pars_in.p_reduced = Theta(4);
       
    % Fit to Initial Conditions
    pars_in.Isym_a0=Theta(5);     % Symptomatic Adults:
    pars_in.Iasym_a0=Theta(5)/pars_in.p_symptomatic * (1-pars_in.p_symptomatic);     % Asymptomatic Adults:

    % ODE Options
    opts = odeset();
    
    % ODE Parameters
    X0 = Get_Inits(pars_in);

    [t,y]=ode45(@SEIR_model_shields, times, X0, opts, pars_in);

    tot_model_deaths =  sum(y(:,pars_in.D_ids),2);
    temp_model_deaths = [0;tot_model_deaths];
    
    dYdt_model_deaths = temp_model_deaths(2:length(temp_model_deaths)) - ...
        temp_model_deaths(1:(length(temp_model_deaths)-1));
    
    % Bin by week
    dYdt_target_week = dYdt_target'; % sum(reshape(dYdt_target, [7,17]),1);
    dYdt_model_deaths_byWeek = sum(reshape(dYdt_model_deaths, [7,pars_in.nWeeks]),1);
    
    % First week has 0 deaths, which will mess with LL. 
    xs = dYdt_target_week;
    lambdas = dYdt_model_deaths_byWeek;
    
    %[round(xs); round(lambdas)];
    % Dont' forget poisspdf(1,0) is 0.
    %likelihoods = poisspdf(xs, lambdas)
    %loglikelihood = sum(log(likelihoods));
    loglikelihood = -log(sum((xs-lambdas).^2));
end

%SEIR_model_shields_LL(pars_nyc.times,  pars_nyc.target, [0.1; 0.25; 0.25; 0.25], pars_nyc)