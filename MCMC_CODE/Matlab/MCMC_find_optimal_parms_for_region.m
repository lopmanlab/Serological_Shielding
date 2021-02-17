 function res = MCMC_find_optimal_parms_for_region(DATE_IN, REGION_IN, PARAMETER_SET_IN, LIKELIHOOD_TYPE_IN, N_VARS_IN, CHAIN_LENGTH, CHAIN_REP, N_CHAINS)
    %% Load Data
    REGION = REGION_IN;
    PARAMETER_SET = PARAMETER_SET_IN;
    LIKELIHOOD_TYPE = LIKELIHOOD_TYPE_IN;
    if REGION_IN == "sflor"
        input_sflor
        pars_in = pars_sflor;
    elseif REGION_IN == "nyc"
        input_nyc
        pars_in = pars_nyc;
    elseif REGION_IN == "wash"
        input_wash
        pars_in = pars_wash;
    else 
        print("ERROR: Can't load region data")
    end
    
    %% Setup
    data.xdata = pars_in.times';
    data.ydata = pars_in.target; % new deaths reported that day, t=1 == 2/27/2020
    ssfun = @(Theta_in, Data_in) -2*SEIR_model_shields_LL(Data_in.xdata, Data_in.ydata, Theta_in, pars_in, false);

    % Likelihood min function (wrapper)
    ssminfun = @(Theta_in) ssfun(Theta_in, data);

    %% Find a good starting point
    ParBounds = [[0.0222, 0.1, 0.51, 0.2, 0.8, 0.005, 0.55, 3, 7, 7, 5, 7];
        [0, 0, 0, 0, 0, 0, 0.2, 0, 0, 0, 0, 0];
        [0.0444, 0.2, 1, 0.4, 1, 0.01, 1, 6, 14, 14, 10, 14]];
    temp_x0 = ParBounds(1,:);
    temp_A = eye(size(ParBounds,2));
    temp_b = ParBounds(3,:);
        %[tmin,ssmin]=fmincon(ssminfun, temp_x0, temp_A, temp_b);
    [tmin,ssmin]=fminsearchbnd(ssminfun,ParBounds(1,:)', ParBounds(2,:)', ParBounds(3,:)');

    n = length(data.xdata);
    p = 2;
    mse = ssmin/(n-p); % estimate for the error variance

    %% Set up MCMC
    params = {
        {'q', .0222+(2-rand(1))*(0.0002), 0, 0.1}
        {'c', 0.1+(2-rand(1))*(0.1), 0, 1}
        {'p_{sym}', 0.51+(2-rand(1))*(0.1), 0, 1}
        {'sd_{red}', 0.2+(2-rand(1))*(0.0001), 0, 1}
        {'p_{red}', 0.8+(2-rand(1))*(0.2), 0, 1}  
        {'init_{scale}', 0.005+(2-rand(1))*(0.005), 0, Inf}
        {'asymp_{red}', 0.55, .2, 1}
        {'gamma_{e}^{-1}',3, 0, 7}  
        {'gamma_{a}^{-1}', 7, 0, 14}  
        {'gamma_{s}^{-1}', 7, 0, 14}  
        {'gamma_{hs}^{-1}', 5, 0, 14}  
        {'gamma_{hc}^{-1}', 7, 0, 14}  
        };
    model.ssfun  = ssfun;
    model.sigma2 = mse; % (initial) error variance from residuals of the lsq fit
    model.N = length(data.ydata);  % total number of observations
    options.nsimu = CHAIN_LENGTH;

    % Var Subset
    params = params(1:N_VARS_IN);
    
    %% Run MCMC /w 2x burn-in
    parfor iter=1:N_CHAINS
        [res_i,chain_i,s2chain_i] = mcmcrun(model,data,params,options);
        for i = 1:CHAIN_REP
            [res_i,chain_i,s2chain_i] = mcmcrun(model,data,params,options,res_i);
        end
        RES_OUT{iter} = {res_i, chain_i, s2chain_i};
    end
    res = RES_OUT;
    
    %% Save results
    save(strcat("OUTPUT/", DATE_IN,"_MCMCRun_", REGION_IN, "_", PARAMETER_SET_IN, "_", LIKELIHOOD_TYPE_IN, "_NVarsFit", int2str(N_VARS_IN), ".mat"))

end