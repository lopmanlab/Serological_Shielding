function Theta_Mat_Out = adhoc_append(Theta_Mat, Pars_in)
    N_VARS = size(Theta_Mat,2)+1;    

    Theta_Mat_Out = Theta_Mat;
    Theta_Mat_Out(:,N_VARS) = 0;
    
    parfor i=1:size(Theta_Mat_Out,1)
        Theta_Mat_Out(i,N_VARS) = SEIR_model_shields_LL(Pars_in.times', Pars_in.target, Theta_Mat(i, :), Pars_in, false);
    end
    