function res = SEIR_model_shields_Theta(Theta, times, Pars, Comp, RATE)
    [t, Y, pars_out] = SEIR_model_shields_ThetaSweep(Theta, times, Pars);
    %D = sum(Y(:,Pars.D_ids),2);
    if RATE
        res=Calc_dD_dt_byWeek(Y, Pars);
    else
        res=sum(Y(:,Pars.(strcat(Comp, "_ids"))),2);
    end
end