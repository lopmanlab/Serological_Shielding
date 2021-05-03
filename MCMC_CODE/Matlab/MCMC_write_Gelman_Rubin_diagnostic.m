% This calculate convergences for each chain.
% The output is saved in adhoc.csv
addpath(genpath(pwd))

DATE = "2021-05-03";
REGION_LIST = ["nyc", "sflor", "wash"];
N_VARS_LIST = [5 6 8 10 12];
PARAMETER_SET = "MMWR";
LIKELIHOOD_TYPE = "LL";
N_TOTAL_VARS = 12;

% Setup CSVs
fullHeader_Convergence = ["region" "n_vars" "n_chains"...
    "q" "c" "symptomatic_fraction" "socialDistancing_other" "p_reduced" "Initial_Condition_Scale"...
    "asymp_red" "latent_period"...
    "symptomat recovery_rate" "asymptomatic_recovery_rate"...
    "hosp_subcrit_length" "hosp_crit_length"...
    "full_chain"];
fileName_Convergence = strcat(DATE, "_MCMCSTATmprsf_Diagnostics.csv");


for i_N_NVARS=1:length(N_VARS_LIST)     % Loop through regions and calculate convergence
    Convergence_Results = zeros(3,N_TOTAL_VARS+1);
    N_VARS = N_VARS_LIST(i_N_NVARS);
    
    for j_region=1:3
        REGION = REGION_LIST{j_region};
        
        if isfile(strcat("OUTPUT/", DATE,"_MCMCRun_", REGION, "_", PARAMETER_SET, "_", LIKELIHOOD_TYPE, "_NVarsFit", int2str(N_VARS), ".mat"))
            load(strcat("OUTPUT/", DATE,"_MCMCRun_", REGION, "_", PARAMETER_SET, "_", LIKELIHOOD_TYPE, "_NVarsFit", int2str(N_VARS), ".mat"))
               
            % Allow for manual chain selection
            Convergence_Results_AllNVars = string(zeros(12,N_TOTAL_VARS+4));
            CHAINS_LIST = 1:N_CHAINS;
            N_CHAINS_IN = length(CHAINS_LIST);

            for i_VAR=1:N_VARS
                temp_Convergence_byVar = {0};

                for i_CHAIN=1:N_CHAINS_IN
                    i_CHAIN_in = CHAINS_LIST(i_CHAIN);
                    temp_Convergence_byVar{i_CHAIN} = RES_OUT{i_CHAIN_in}{2}(:,i_VAR); 
                end

                Convergence_Results(j_region,i_VAR) = mpsrf(temp_Convergence_byVar);
            end

            temp_Convergence_full = {0};
            for i_CHAIN=1:N_CHAINS_IN
                i_CHAIN_in = CHAINS_LIST(i_CHAIN);
                temp_Convergence_full{i_CHAIN} = RES_OUT{i_CHAIN_in}{2}; 
            end

            Convergence_Results(j_region,N_VARS+1) = mpsrf(temp_Convergence_full);
        else
            strcat("OUTPUT/", DATE,"_MCMCRun_", REGION, "_", PARAMETER_SET, "_", LIKELIHOOD_TYPE, "_NVarsFit", int2str(N_VARS), ".mat is MISSING")
            Convergence_Results(j_region,:) = 0;
        end
        
    end
    
    Convergence_Results_AllNVars((1+(i_N_NVARS-1)*3):(3+(i_N_NVARS-1)*3),:) = [REGION_LIST' [N_VARS; N_VARS; N_VARS] [N_CHAINS_IN; N_CHAINS_IN; N_CHAINS_IN] string(Convergence_Results)];
end

fid_Convergence = fopen(fileName_Convergence, 'w');
fprintf(fid_Convergence, [repmat('%s,',1,size(fullHeader_Convergence, 2)) '\n'], fullHeader_Convergence);
fprintf(fid_Convergence, [repmat('%s,',1,size(Convergence_Results_AllNVars, 2)) '\n'], Convergence_Results_AllNVars');
fclose(fid_Convergence);

Convergence_Results_AllNVars