clear
DATE = "2021-02-13";
addpath(genpath(pwd))

%% Set Pars
CHAIN_LENGTH = 500;
CHAIN_REP = 5;
N_CHAINS = 10;
            

%% RUN
for PARAMETER_SET = ["LANCET"] 
    for REGION = ["nyc", "wash", "sflor"]     
        for LIKELIHOOD_TYPE = ["LL"]
            MCMC_find_optimal_parms_for_region(PARAMETER_SET, REGION, LIKELIHOOD_TYPE, CHAIN_LENGTH, CHAIN_REP, N_CHAINS, DATE);
        end
    end
end