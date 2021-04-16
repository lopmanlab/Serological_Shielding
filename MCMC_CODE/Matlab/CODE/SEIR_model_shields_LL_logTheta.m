function loglike = SEIR_model_shields_LL_logTheta(times, dYdt_target, ThetaLog, Pars, PLOT_RES)
    % Un-logTransform
    Theta = exp(ThetaLog);

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
    sero_model_S = (pars_in.N - sum(y(pars_in.tSero,pars_in.S_ids),2));
    sero_model_R = sum(y(pars_in.tSero, pars_in.R_ids),2);
    
    % Final Deaths
    final_deaths = sum(y(1+days(pars_in.tf - pars_in.t0),pars_in.D_ids),2);
    final_xs = sum(xs);
    
    % Mid Deaths - day 77, week 11
    mid_deaths = sum(y(78,pars_in.D_ids),2);
    mid_xs  = sum(xs(1:12));
    
    % find nonzeros in data
    b_nonzeros = find(xs~=0);
    xs = xs(b_nonzeros);
    lambdas = lambdas(b_nonzeros);
    lambdas = max(lambdas, 0); % enforce rounding error
    
    % In the main call, this will be multiplied by -2.    
    RESCALE_FACTOR = 1/Pars.N*100000; % Deaths per 100000
    loglike = sum(logpoispdf(lambdas*RESCALE_FACTOR, xs*RESCALE_FACTOR)) + ... % death rates
        logpoispdf(final_deaths*RESCALE_FACTOR, final_xs*RESCALE_FACTOR) + ... % deaths @ end
        logpoispdf(mid_deaths*RESCALE_FACTOR, mid_xs*RESCALE_FACTOR) + ... % deaths @ 77 days
        logpoispdf(Calc_R0(pars_in), R0_expected) + ... % R0
        logpoispdf(sero_model_R*RESCALE_FACTOR, sero_exp*RESCALE_FACTOR); % delayed sero

%     % Rescale for LL
%     loglike = sum(logpoispdf(lambdas, xs)) + ... % death rates
%         logpoispdf(final_deaths, final_xs) + ... % deaths @ end
%         logpoispdf(mid_deaths, mid_xs) + ... % deaths @ 77 days
%         logpoispdf(Calc_R0(pars_in), R0_expected) + ... % R0
%         logpoispdf(sero_model_R, sero_exp); % delayed sero    
    
    
%     RESCALE_FACTOR = 1/Pars.N*1000; % <class> per 1000
%     sum(logpoispdf(lambdas*RESCALE_FACTOR, xs*RESCALE_FACTOR)) % death rates
%     logpoispdf(final_deaths*RESCALE_FACTOR, final_xs*RESCALE_FACTOR) % deaths @ end
%     logpoispdf(mid_deaths*RESCALE_FACTOR, mid_xs*RESCALE_FACTOR) % deaths @ 77 days
%     logpoispdf(Calc_R0(pars_in), R0_expected) % R0
%     logpoispdf(sero_model_R*RESCALE_FACTOR/10, sero_exp*RESCALE_FACTOR/10) % delayed sero $ Sero per 100
end