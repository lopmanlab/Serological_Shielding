function [t, Y, pars_out] = SEIR_model_shields_ThetaSweep(Theta, times, Pars)
    %% Set and Update Parameters
    pars_in = Pars;
    
    % Change wrt Theta
    pars_in.q = Theta(1);
    pars_in.c = Theta(2);
    pars_in.p_symptomatic = Theta(3);
    
    pars_in.socialDistancing_other = Theta(4);
    pars_in.p_reduced = Theta(5);

    % Fit target date
    pars_in.tStart_target=pars_in.tStart_distancing+Theta(6);
    
    % Fit to Initial Conditions
    X0 = pars_in.X0_target;
    
    % Only E, Iasym, and Isym will be changed. Ratios are constant. XXX 09.07.2020 - initial cond hotfix
    Theta_Scale = (1+Theta(7));
    Temp_Tot = X0(pars_in.E_ids) + ...
        X0(pars_in.Iasym_ids) + ...
        X0(pars_in.Isym_ids);
    
    X0(pars_in.E_ids) = Theta_Scale*pars_in.X0_target(pars_in.E_ids);
    X0(pars_in.Iasym_ids) = Theta_Scale*pars_in.X0_target(pars_in.Iasym_ids);
    X0(pars_in.Isym_ids) = Theta_Scale*pars_in.X0_target(pars_in.Isym_ids);

    X0(pars_in.S_ids) = pars_in.X0_target(pars_in.S_ids) - Temp_Tot*Theta(7);
    
            
    %% Run ODEs
    opts = odeset(); % options
        %X0 = round(Calc_Init_Conds(pars_in));
        %X0 = Get_Inits(pars_in); % parameters
    [t,Y]=ode45(@SEIR_model_shields_full, times, X0, opts, pars_in); % model calc

    %% Outputs
    pars_out = pars_in;
end