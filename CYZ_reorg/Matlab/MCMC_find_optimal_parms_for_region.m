 function res = MCMC_find_optimal_parms_for_region(PARAMETER_SET, REGION, LIKELIHOOD_TYPE, CHAIN_LENGTH, CHAIN_REP, N_CHAINS)
    %% Load Data
    if REGION == "sflor"
        input_sflor
        pars_in = pars_sflor;
    elseif REGION == "nyc"
        input_nyc
        pars_in = pars_nyc;
    elseif REGION == "wash"
        input_wash
        pars_in = pars_wash;
    else 
        print("ERROR: Can't load region data")
    end
    
    %% Setup
    data.xdata = pars_in.times';
    data.ydata = pars_in.target; % new deaths reported that day, t=1 == 2/27/2020

    if LIKELIHOOD_TYPE == "LLpen_scaled"
        ssfun = @(Theta_in, Data_in) -2*SEIR_model_shields_LLpen_scaled(Data_in.xdata, Data_in.ydata, Theta_in, pars_in, false);
    elseif LIKELIHOOD_TYPE == "SSpen_scaled"
        ssfun = @(Theta_in, Data_in) -2*SEIR_model_shields_SSpen_scaled(Data_in.xdata, Data_in.ydata, Theta_in, pars_in, false);
    else
        print("ERROR: No Likelihood Specified")
    end

    % Likelihood min function (wrapper)
    ssminfun = @(Theta_in) ssfun(Theta_in, data);

    %% Find a good starting point.
    [tmin,ssmin]=fminsearchbnd(ssminfun,[0.02;0.25;0.3;0.1;0.25;0;0], [0;0;0;0;0;0;0], [0.05;1;1;1;1;100;100]);
        %SEIR_model_shields_LL(data.xdata, data.ydata, tmin, pars_in,
        %true) % Verification check

    n = length(data.xdata);
    p = 2;
    mse = ssmin/(n-p); % estimate for the error variance

    %% Set up MCMC
    params = {
        {'q', tmin(1), 0, .1}
        {'c', tmin(2), 0, 1}
        {'p_{sym}', tmin(3), 0, 1}
        {'sd_{red}', tmin(4), 0, 1}
        {'p_{red}', tmin(5), 0, 1}
        {'t_{targ}', tmin(6), 0, 30}
        {'init_{scale}', tmin(7), 0, Inf}
        };

    model.ssfun  = ssfun;
    model.sigma2 = mse; % (initial) error variance from residuals of the lsq fit

    model.N = length(data.ydata);  % total number of observations

    options.nsimu = CHAIN_LENGTH;

    %% Run MCMC /w 2x burn-in

    % 1
    [res1,chain1,s2chain1] = mcmcrun(model,data,params,options);
    for i = 1:CHAIN_REP
        [res1,chain1,s2chain1] = mcmcrun(model,data,params,options,res1);
    end

    RES_OUT = {{res1, chain1, s2chain1}};
    
    for iter=1:N_CHAINS
        params = {
        {'q', .1*rand(1), 0, 0.1}
        {'c', rand(1), 0, 1}
        {'p_{sym}', rand(1), 0, 1}
        {'sd_{red}', rand(1), 0, 1}
        {'p_{red}', rand(1), 0, 1}  
        {'t_{targ}', rand(1), 0, 30}
        {'init_{scale}', rand(1), 0, Inf}
        };
        [res_i,chain_i,s2chain_i] = mcmcrun(model,data,params,options);
        
        for i = 1:CHAIN_REP
            [res_i,chain_i,s2chain_i] = mcmcrun(model,data,params,options,res_i);
        end
        
        RES_OUT{iter+1} = {res_i, chain_i, s2chain_i};
    end
    
    res = RES_OUT;
    
    %% Save results
    save(strcat("OUTPUT/2020-09-30_MCMCRun_", REGION, "_", PARAMETER_SET, "_", LIKELIHOOD_TYPE,".mat"))

end