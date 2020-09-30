clear

%% Set Pars
CHAIN_LENGTH = 3000;
CHAIN_REP = 4;
N_CHAINS = 5;
            

%% RUN
for PARAMETER_SET = ["LANCET", "PNAS"]    
    for REGION = ["wash", "sflor"] %"nyc"]       
        for LIKELIHOOD_TYPE = ["LLpen_scaled", "SSpen_scaled"]
            MCMC_find_optimal_parms_for_region(PARAMETER_SET, REGION, LIKELIHOOD_TYPE, CHAIN_LENGTH, CHAIN_REP, N_CHAINS);
        end
    end
end

%% Evaluate MCMC
%load OUTPUT/2020-09-19_MCMCRun_nyc_LANCET_SS.mat

%res = res3;
%chain = chain3;

%figure(2); clf
%mcmcplot(chain,[],res,'chainpanel');
%figure(3); clf
%mcmcplot(chain,[],res,'pairs');
%figure(4); clf
%mcmcplot(chain,[],res,'denspanel',2);

% Did Model Converge?
%chainstats(chain,res)

% Predictions
%test = res;
%test{1} = test{2};
%hains = cellfun(@(x) x{2}, test, 'un', 0);
%Ress = cellfun(@(x) x{1}, test, 'un', 0);
%plot_MCMC_res(25, Chains, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, Ress)
%plot_MCMC_res(100, {chain1, chain2, chain3, chain4}, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, {res1, res2, res3, res4})