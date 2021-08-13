clear
addpath(genpath(pwd))

%% Set MCMC Pars
CHAIN_LENGTH = 1000;
CHAIN_REP = 1;
N_CHAINS = 3;

%% Set Run Details
DATE = "2021-05-04";
PARAMETER_SET = "MMWR";
LIKELIHOOD_TYPE = "LL";
N_VARS = 5;
            
for REGION = ["wash"]%, "nyc", "sflor"]
    %% RUN
    DATE = strcat(DATE);
    MCMC_find_optimal_parms_for_region(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS, CHAIN_LENGTH, CHAIN_REP, N_CHAINS);
    MCMC_Generate_Figures(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS, 1); % Only plot the first chain
    MCMC_write_outputs(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS);
end