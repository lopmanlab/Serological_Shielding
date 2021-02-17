function R0 = Calc_R0_Theta(Theta, Pars)
    %% Set and Update Parameters
    pars_in = Pars;
    
    % Change wrt Theta
    pars_in.q = Theta(1);
    pars_in.c = Theta(2);
    pars_in.p_symptomatic = Theta(3);
    
    pars_in.socialDistancing_other = Theta(4);
    pars_in.p_reduced = Theta(5);
    
    R0 = Calc_R0(pars_in);
end