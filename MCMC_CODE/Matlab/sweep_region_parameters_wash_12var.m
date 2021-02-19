clear
% For Running on PACE
addpath(genpath(pwd))

% Defaults
default_sweep_parameters

% Region-specifics
REGION = "wash";
N_VARS = 12;
            

%% RUN
DATE = strcat(DATE);
MCMC_find_optimal_parms_for_region(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS, CHAIN_LENGTH, CHAIN_REP, N_CHAINS);
MCMC_Generate_Figures(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS, 1); % Only plot the first chain
MCMC_write_outputs(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS);

% for i=1:10
%     MCMC_Generate_Figures(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS, i); % Only plot the first chain
% end