clear
addpath(genpath(pwd))
DATE = "2021-02-15_TEST";
REGION = "wash";

% Setup Outputs
fileName_targetInits = strcat("OUTPUT/", DATE, "_targetInits.csv");
header_targetInits = ["region"...
    "S_c" "S_a" "S_rc" "S_fc" "S_e" ...
    "E_c" "E_a" "E_rc" "E_fc" "E_e" ...
    "Isym_c" "Isym_a" "Isym_rc" "Isym_fc" "Isym_e" ...
    "Iasym_c" "Iasym_a" "Iasym_rc" "Iasym_fc" "Iasym_e" ...
    "Hsub_c" "Hsub_a" "Hsub_rc" "Hsub_fc" "Hsub_e" ...
    "Hcri_c" "Hcri_a" "Hcri_rc" "Hcri_fc" "Hcri_e" ...
    "D_c" "D_a" "D_rc" "D_fc" "D_e" ...
    "R_c" "R_a" "R_rc" "R_fc" "R_e" ...
    ];
fullHeader_chains = ["q" "c" "symptomatic_fraction" "socialDistancing_other" "p_reduced" "Initial_Condition_Scale"...
    "asymp_red" "latent_period"...
    "symptomat recovery_rate" "asymptomatic_recovery_rate"...
    "hosp_subcrit_length" "hosp_crit_length"...
    "LogLikelihood" "R0" "i_chain"];

% Set up csv for initial conditions
if ~isfile(strcat("OUTPUT/", DATE, "_targetInits.csv"))
    % If file doesn't exist, create targetInits.
    % Code will append new row
    write_csv_header(header_targetInits, fileName_targetInits);
end

% Load Data Mat
load(strcat("OUTPUT/", DATE, "_MCMCRun_", REGION, "_MMWR_LL.mat"))
temp_pars = pars_in; %setup for parfor later

% X0s
temp = reshape(pars_in.X0_target, 5, 8);

% Append Results and Print
for i=1:N_CHAINS
    % Load chains
    df_Results = RES_OUT{i}{2}(1:100,:);
    
    N_VARS = size(df_Results, 2);
    
    % Fix the multiplicative initial condition factor on column 6
    df_Results_initMult = df_Results(:,6);
    mle_initMult = mle(df_Results_initMult);

    % Append Likelihoods
    temp_Theta_Mat_in = df_Results;
    temp_LL_Vec_out = zeros([N_CHAINS 1]);
    temp_times = pars_in.times';
    temp_target = pars_in.target;
    
    parfor i_llChain=1:CHAIN_LENGTH
        temp_LL_Vec_out(i_llChain) = SEIR_model_shields_LL(temp_times, temp_target, temp_Theta_Mat_in(i_llChain, :), temp_pars, false);
    end
    df_Results = [df_Results temp_LL_Vec_out];

    % Append R0's
    temp_df_Results_in = df_Results(:,1:6);
    temp_R0_out = zeros([CHAIN_LENGTH 1]);
    
    parfor j=1:CHAIN_LENGTH
        temp_R0_out(j,1) = Calc_R0_Theta(temp_df_Results_in, temp_pars);
    end
    df_Results = [df_Results temp_R0_out];

    % Append Chain #
    i_chain_column = size(df_Results,2)+1;
    df_Results(:,i_chain_column)=i;

    % Write
    % Print Header
    partialHeader_chains = [fullHeader_chains(1:N_VARS) fullHeader_chains(end-2:end)];
    fileName_chains = strcat("OUTPUT/", DATE, "_", REGION, "_chain", int2str(i), ".csv");
    fid = fopen(fileName_chains, 'w');
    fprintf(fid, [repmat('%s,',1,size(partialHeader_chains, 2)) '\n'], partialHeader_chains);
    fprintf(fid, [repmat('%f,',1,size(df_Results,2)) '\n'], df_Results');
    fclose(fid);
end

temp_targetInits_outputRow = [REGION arrayfun(@(a)num2str(a),pars_in.X0_target,'uni',0)];
fid_targetInits = fopen(fileName_targetInits, 'a');
fprintf(fid_targetInits, [repmat('%s,',1,size(temp_targetInits_outputRow, 2)) '\n'], temp_targetInits_outputRow);
fclose(fid_targetInits);