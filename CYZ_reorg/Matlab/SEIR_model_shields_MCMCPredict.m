function dD_dt_byWeek = SEIR_model_shields_MCMCPredict(Theta, times, Pars)
    %% This function is because I can't figure out another way to set up the predictions using what I have.
    %% Set and Update Parameters
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

    %% Run ODEs
    opts = odeset(); % options
    X0 = Get_Inits(pars_in); % parameters
    [t,Y]=ode45(@SEIR_model_shields, times, X0, opts, pars_in); % model calc
    
    dD_dt_byWeek = Calc_dD_dt_byWeek(Y, pars_in);
end