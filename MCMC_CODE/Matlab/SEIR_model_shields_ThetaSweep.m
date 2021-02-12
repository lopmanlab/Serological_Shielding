function [t, Y, pars_out] = SEIR_model_shields_ThetaSweep(Theta, times, Pars)
    %% Set and Update Parameters
    pars_in = Pars;
    
    % 1. [0,0.1]    q
    % 2. [0,1]      c
    % 3. [0,1]      p_symptomatic
    % 4. [0,1]      socialDistancing_other
    % 5. [0,1]      p_reduced
    pars_in.q = Theta(1);
    pars_in.c = Theta(2);
    pars_in.p_symptomatic = Theta(3);
    
    pars_in.socialDistancing_other = Theta(4);
    pars_in.p_reduced = Theta(5);
    
    % 6. [0,Inf]    initial condition scaling
    X0 = pars_in.X0_target;
    
    % Only E, Iasym, and Isym will be changed. Ratios are constant.
    Theta_Scale = (1+Theta(6));
    Temp_Tot = X0(pars_in.E_ids) + ...
        X0(pars_in.Iasym_ids) + ...
        X0(pars_in.Isym_ids);
    
    X0(pars_in.E_ids) = Theta_Scale*pars_in.X0_target(pars_in.E_ids);
    X0(pars_in.Iasym_ids) = Theta_Scale*pars_in.X0_target(pars_in.Iasym_ids);
    X0(pars_in.Isym_ids) = Theta_Scale*pars_in.X0_target(pars_in.Isym_ids);

    X0(pars_in.S_ids) = pars_in.X0_target(pars_in.S_ids) - Temp_Tot*Theta(6);
            
    % 7. [0,1]      asymp_red:              Fit relative infectiousness of asymptomatics.
    pars_in.asymp_red = Theta(7);
    
    % 8. [0,1]      gamma_e:                Fit latent period.
    pars_in.gamma_e = Theta(8);
    
    % 9. [0,1]      gamma_hs, gamma_hc:     Fit hospital length of stay.
    pars_in.gamma_hs = Theta(9);
    pars_in.gamma_hc = Theta(9);
    
    %% Run ODEs
    opts = odeset();
    [t,Y]=ode45(@SEIR_model_shields_full, times, X0, opts, pars_in); % model calc

    %% Outputs
    pars_out = pars_in;
end