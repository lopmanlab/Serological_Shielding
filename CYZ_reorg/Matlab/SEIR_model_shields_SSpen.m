function sumsq = SEIR_model_shields_SS(times, dYdt_target, Theta, Pars, PLOT_RES)
    [t, y, pars_in] = SEIR_model_shields_ThetaSweep(Theta, times, Pars);
    
    %% Calculate New Deaths per Week
    dYdt_target_week = dYdt_target'; % sum(reshape(dYdt_target, [7,17]),1);    
    dYdt_model_deaths_byWeek = Calc_dD_dt_byWeek(y, pars_in);
    
    %% Calculate Log Likelihood
    xs = dYdt_target_week;
    lambdas = dYdt_model_deaths_byWeek;
    
    if PLOT_RES
        figure(1); clf
        hold on
        plot(1:pars_in.nWeeks, xs, 'Markerface', [0, 0.4470, 0.7410])
        plot(1:pars_in.nWeeks, xs, 's', 'Markerface', [0, 0.4470, 0.7410])
        plot(1:pars_in.nWeeks, lambdas, 'Markerface', [0.8500, 0.3250, 0.0980])
        plot(1:pars_in.nWeeks, lambdas, 's' , 'Markerface', [0.8500, 0.3250, 0.0980])
    end
    
       
    % R0 penalty
    R0_expected = 3;
    
    % Sero Penalty
    % <INSERT SERO PENALTY!>
    
    % In the main call, this will be multiplied by -2. 
    sumsq = -(sum((xs-lambdas).^2)) - (R0_expected - Calc_R0(pars_in))^2; % for sum of squares, low
    %error is good. 
end

%SEIR_model_shields_LL(pars_nyc.times,  pars_nyc.target, [0.1; 0.25; 0.25; 0.25; 100], pars_nyc, true)