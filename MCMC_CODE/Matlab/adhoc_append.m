function Theta_Mat_Out = adhoc_append(Theta_Mat, Pars_in)
    % (1) Read results matrix Theta_Mat and parameter set Pars_in
    % (2) Calcualte Log Likelihood from all the columns
    % (3) Appends the log likelihood to Theta_Mat
    N_CHAINS = size(Theta_Mat,1);
        
    temp_Theta_Mat_in = Theta_Mat;
    temp_LL_Vec_out = zeros([N_CHAINS 1]);
    temp_times = Pars_in.times';
    temp_target = Pars_in.target;
    parfor i=1:N_CHAINS
        temp_LL_Vec_out(i) = SEIR_model_shields_LL(temp_times, temp_target, temp_Theta_Mat_in(i, :), Pars_in, false);
    end
    
    Theta_Mat_Out = [Theta_Mat temp_LL_Vec_out];
end

    