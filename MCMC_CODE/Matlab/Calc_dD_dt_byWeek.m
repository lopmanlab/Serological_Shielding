function dD_dt_byWeek = Calc_dD_dt_byWeek(Y, Pars)   
    
    %% Calculate New Deaths per Week
    tot_model_deaths =  sum(Y(:,Pars.D_ids),2);
    temp_model_deaths = [0;tot_model_deaths];
    
    dYdt_model_deaths = temp_model_deaths(2:length(temp_model_deaths)) - ...
        temp_model_deaths(1:(length(temp_model_deaths)-1));
    
    % Bin by week
    dD_dt_byWeek = sum(reshape(dYdt_model_deaths, [7,Pars.nWeeks]),1);
end

%SEIR_model_shields_LL(pars_nyc.times,  pars_nyc.target, [0.1; 0.25; 0.25; 0.25; 100], pars_nyc, true)