clear
addpath(genpath(pwd))

%% Set Pars
CHAIN_LENGTH = 5000;
CHAIN_REP = 9;
N_CHAINS = 10;

DATE = "2021-04-26";
%REGION = "wash";
PARAMETER_SET = "MMWR";
LIKELIHOOD_TYPE = "LL";
N_VARS = 5;
            
for REGION = ["wash", "nyc", "sflor"]
    %% RUN
    DATE = strcat(DATE);
    MCMC_find_optimal_parms_for_region(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS, CHAIN_LENGTH, CHAIN_REP, N_CHAINS);
    MCMC_Generate_Figures(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS, 1); % Only plot the first chain
    MCMC_write_outputs(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS);
end