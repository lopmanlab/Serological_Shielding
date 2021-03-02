clear
% For Running on PACE
addpath(genpath(pwd))

% Defaults
default_sweep_parameters

% Region-specifics
N_VARS = 6;
            

%% RUN
DATE = strcat(DATE);

for REGION=["nyc", "wash"]%, "sflor"]
    MCMC_write_outputs(DATE, REGION, PARAMETER_SET, LIKELIHOOD_TYPE, N_VARS);
end

