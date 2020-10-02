function loglike = SEIR_model_shields_LLpen_scaled(times, dYdt_target, Theta, Pars, PLOT_RES)
    [t, y, pars_in] = SEIR_model_shields_ThetaSweep(Theta, times, Pars);
    
    %% Calculate New Deaths per Week
    dYdt_target_week = dYdt_target'; % sum(reshape(dYdt_target, [7,17]),1);    
    dYdt_model_deaths_byWeek = Calc_dD_dt_byWeek(y, pars_in);
    
    %% Calculate Log Likelihood
    xs = dYdt_target_week;
    lambdas = dYdt_model_deaths_byWeek;
    
        %if PLOT_RES
        %    figure(1); clf
        %    hold on
        %    plot(1:pars_in.nWeeks, xs, 'Markerface', [0, 0.4470, 0.7410])
        %    plot(1:pars_in.nWeeks, xs, 's', 'Markerface', [0, 0.4470, 0.7410])
        %    plot(1:pars_in.nWeeks, lambdas, 'Markerface', [0.8500, 0.3250, 0.0980])
        %    plot(1:pars_in.nWeeks, lambdas, 's' , 'Markerface', [0.8500, 0.3250, 0.0980])
        %end

    % R0 penalty
    R0_expected = 3;
    
    % Sero Penalty
    sero_exp = pars_in.N*pars_in.sero/100;
        %sero_low = pars_in.N*pars_in.sero_min/100; % data entered as percentages, hence /100
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

        %Error = logpoispdf(lambdas, xs)
        %R0Pen = logpoispdf(100*Calc_R0(pars_in), 100*R0_expected)
        %SeroPen = logpoispdf(sero_model_S/100, sero_exp/100) + logpoispdf(sero_model_R/100, sero_exp/100)
    
    % In the main call, this will be multiplied by -2. 
    %loglike = sum(Error) + R0Pen + SeroPen;
    
    loglike = sum(logpoispdf(lambdas, xs)) + ...
        logpoispdf(10*final_deaths, 10*final_xs) + ...
        logpoispdf(10*mid_deaths, 10*mid_xs) + ...
        logpoispdf(100*Calc_R0(pars_in), 100*R0_expected) + ...
        logpoispdf(sero_model_S/100, sero_exp/100) + ...
        logpoispdf(sero_model_R/100, sero_exp/100);
    
    %error is good. 
end

%SEIR_model_shields_LL(pars_nyc.times,  pars_nyc.target, [0.1; 0.25; 0.25; 0.25; 100], pars_nyc, true)