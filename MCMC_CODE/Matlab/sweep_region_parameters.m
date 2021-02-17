clear
DATE = "2021-02-15_TEST";
addpath(genpath(pwd))

%% Set Pars
CHAIN_LENGTH = 100;
CHAIN_REP = 1;
N_CHAINS = 1;
            

%% RUN
for PARAMETER_SET = ["MMWR"] 
    for REGION = ["nyc", "wash", "sflor"]     
        for LIKELIHOOD_TYPE = ["LL"]
            MCMC_find_optimal_parms_for_region(PARAMETER_SET, REGION, LIKELIHOOD_TYPE, CHAIN_LENGTH, CHAIN_REP, N_CHAINS, DATE);
            MCMC_Generate_Figures(DATE, PARAMETER_SET, REGION, LIKELIHOOD_TYPE, 2);
            MCMC_write_outputs(DATE, REGION);
        end
    end
end