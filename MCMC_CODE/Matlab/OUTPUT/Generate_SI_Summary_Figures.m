addpath(genpath(pwd))
DATE = "2021-05-04";
PARAMETER_SET = "MMWR";
LIKELIHOOD_TYPE = "LL";
N_VARS = 5;
            
for REGION = ["wash", "nyc", "sflor"]
    %% RUN
    DATE = strcat(DATE);

    load(strcat("OUTPUT/", DATE,"_MCMCRun_", REGION, "_", PARAMETER_SET, "_", LIKELIHOOD_TYPE, "_NVarsFit", int2str(N_VARS), ".mat"))
    
    PLOT_CHAIN_NUM = 1;

    t2 = figure(2); clf;
    mcmcplot(res{PLOT_CHAIN_NUM}{2},[],res{PLOT_CHAIN_NUM}{1},'chainpanel');
    set(gcf,'Position',[100 100 2000 1000])
    saveas(t2, strcat('OUTPUT/', REGION_IN, '/', DATE_IN, '_', REGION_IN, '_', PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE_IN, "_NVarsFit", int2str(N_VARS_IN), '_', int2str(PLOT_CHAIN_NUM), '_chainpanel.png'));

    t3 = figure(3); clf;
    mcmcplot(res{PLOT_CHAIN_NUM}{2},[],res{PLOT_CHAIN_NUM}{1},'pairs');
    set(gcf,'Position',[100 100 1500 1200])
    saveas(t3, strcat('OUTPUT/', REGION_IN, '/', DATE_IN, '_', REGION_IN, '_',  PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE_IN, "_NVarsFit", int2str(N_VARS_IN), '_', int2str(PLOT_CHAIN_NUM), '_pairs.png'));

    temp_res = res;%(2:6);
    Chains = cellfun(@(x) x{2}, temp_res, 'un', 0);
    Ress = cellfun(@(x) x{1}, temp_res, 'un', 0);

    t5 = plot_MCMC_results_SupplementarySummaries(100, Chains, ["S", "E", "Iasym", "Isym", "R", "D"], pars_in, Ress, REGION_IN, DATE_IN, PARAMETER_SET_IN, LIKELIHOOD_TYPE_IN, N_VARS_IN);

end
