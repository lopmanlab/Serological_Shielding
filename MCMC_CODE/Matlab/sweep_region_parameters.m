clear
addpath(genpath(pwd))

%% Set Pars
CHAIN_LENGTH = 100;
CHAIN_REP = 1;
N_CHAINS = 3;

DATE = "2021-02-17";
REGION = "nyc";
PARAMETER_SET = "MMWR";
LIKELIHOOD_TYPE = "LL";
N_VARS = 12;
            

%% RUN
for PARAMETER_SET = ["MMWR"] 
    for REGION = ["nyc", "wash", "sflor"]     
        for LIKELIHOOD_TYPE = ["LL"]
            MCMC_find_optimal_parms_for_region(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS, CHAIN_LENGTH, CHAIN_REP, N_CHAINS);
                %MCMC_Generate_Figures(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS, 1); % Only plot the first chain
            MCMC_write_outputs(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS);
        end
    end
end