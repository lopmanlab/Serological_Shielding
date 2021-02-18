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

    %% Set up MCMC
    model.ssfun  = ssfun;
    model.N = length(data.ydata);  % total number of observations
    options.nsimu = CHAIN_LENGTH;

    % Default Parameters
    params = {
        {'q', 0.1*rand(1), 0, 0.1}
        {'c', rand(1), 0, 1}
        {'p_{sym}', rand(1), 0, 1}
        {'sd_{red}', rand(1), 0, 1}
        {'p_{red}', rand(1), 0, 1}  
        {'init_{scale}', rand(1), 0, Inf}
        {'asymp_{red}', 0.2+0.8*rand(1), .2, 1}
        {'gamma_{e}^{-1}', 3, 0, 7}  
        {'gamma_{a}^{-1}', 7, 0, 14}  
        {'gamma_{s}^{-1}', 7, 0, 14}  
        {'gamma_{hs}^{-1}', 5, 0, 14}  
        {'gamma_{hc}^{-1}', 7, 0, 14}  
        };
    %% Find a good starting point
    ParBounds = [[0.0222, 0.1, 0.51, 0.2, 0.8, 0.005, 0.55, 3, 7, 7, 5, 7];
        [0, 0, 0, 0, 0, 0, 0.2, 0, 0, 0, 0, 0];
        [0.0444, 0.2, 1, 0.4, 1, 0.01, 1, 6, 14, 14, 10, 14]];

    % LHC Sampling
    LHSamples = LHSmid(10000, ParBounds(2,1:N_VARS_IN), ParBounds(3,1:N_VARS_IN));
    LHS_ERROR = zeros(1,10000);
    parfor i=1:10000
        init_para = LHSamples(i,:);
        LHS_LL(i) = ssminfun(init_para); % take the smallest values
    end
    [minLHS, i_minLHS] = mink(LHS_LL, N_CHAINS);
    min_LHS_inits = LHSamples(i_minLHS,:);
    
    % Setup Parameters
    params_in = params(1:N_VARS_IN);
    for i_paramChainSetup = 1:N_CHAINS
        temp_params = params_in;
        for i_param=1:N_VARS_IN
            temp_params{i_param}{2} = min_LHS_inits(i_paramChainSetup, i_param);
        end
        params_LHS{i_paramChainSetup} = temp_params;
    end
        
    %% Run MCMC /w 2x burn-in
    parfor iter=1:N_CHAINS
        % Modify params_in to take the optimal LHC samples     
        iter_params = params_LHS{iter};
        [res_i,chain_i,s2chain_i] = mcmcrun(model,data,iter_params,options);
        for i = 1:CHAIN_REP
            [res_i,chain_i,s2chain_i] = mcmcrun(model,data,iter_params,options,res_i);
        end
        RES_OUT{iter} = {res_i, chain_i, s2chain_i};
    end
    res = RES_OUT;
    
    %% Save results
    save(strcat("OUTPUT/", DATE_IN,"_MCMCRun_", REGION_IN, "_", PARAMETER_SET_IN, "_", LIKELIHOOD_TYPE_IN, "_NVarsFit", int2str(N_VARS_IN), ".mat"))

end