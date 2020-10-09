function loglike = SEIR_model_shields_LLpen_scaled(times, dYdt_target, Theta, Pars, PLOT_RES)
    [t, y, pars_in] = SEIR_model_shields_ThetaSweep(Theta, times, Pars);
    
    %% Calculate New Deaths per Week
    dYdt_target_week = dYdt_target';
    dYdt_model_deaths_byWeek = Calc_dD_dt_byWeek(y, pars_in);
    
    %% Calculate Log Likelihood
    xs = dYdt_target_week;
    lambdas = dYdt_model_deaths_byWeek;
   
    % R0 penalty
    R0_expected = 3;
    
    % Sero Penalty
    sero_exp = pars_in.N*pars_in.sero/100; % data entered as percentages, hence /100
        %sero_low = pars_in.N*pars_in.sero_min/100; 
        %sero_high = pars_in.N*pars_in.sero_max/100;

    sero_model_S = (pars_in.N - sum(y(pars_in.tSero,pars_in.S_ids),2));
    sero_model_R = sum(y(pars_in.tSero, pars_in.R_ids),2);
    
    % Final Deaths
    final_deaths = sum(y(1+days(pars_in.tf - pars_in.t0),pars_in.D_ids),2);
    final_xs = sum(xs);
    
    % Mid Deaths - day 77, week 11
    mid_deaths = sum(y(78,pars_in.D_ids),2);
    mid_xs  = sum(xs(1:12));
    
    % find zeros in data
    b_zeros = find(xs~=0);
    xs = xs(b_zeros);
    lambdas = lambdas(b_zeros);
    
    % In the main call, this will be multiplied by -2.    
    loglike = sum(logpoispdf(lambdas, xs)) + ... % death rates
        logpoispdf(10*final_deaths, 10*final_xs) + ... % deaths @ end
        logpoispdf(10*mid_deaths, 10*mid_xs) + ... % deaths @ 77 days
        logpoispdf(100*Calc_R0(pars_in), 100*R0_expected) + ... % R0
        logpoispdf(sero_model_R/100, sero_exp/100); % delayed sero

end