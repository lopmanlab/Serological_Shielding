function Theta_Mat_Out = adhoc_append(Theta_Mat, Pars_in)
    Theta_Mat_Out = Theta_Mat;
    Theta_Mat_Out(:,7) = 0;
    
    for i=1:size(Theta_Mat_Out,1)
        Theta_Mat_Out(i,7) = SEIR_model_shields_LL(Pars_in.times', Pars_in.target, Theta_Mat(i, :), Pars_in, false);
    end
    