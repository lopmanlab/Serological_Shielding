function out_plots = MCMC_Generate_Figures(DATE, PARAMETER_SET_IN, REGION_IN, LIKELIHOOD_TYPE_IN, PLOT_CHAIN_NUM)
    % PLOT_CHAIN_NUM: 1 is fminsearch initial conditions; >1 is the actual
    % chains, but note indices are 1-shifted. Chain 2 is PLOT_CHAIN_NUM=3

    if isfile(strcat('OUTPUT/', DATE, '_MCMCRun_', REGION_IN, '_', PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE_IN, '.mat'))
        load(strcat('OUTPUT/', DATE, '_MCMCRun_', REGION_IN, '_', PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE_IN, '.mat'))    

        t2 = figure(2); clf;
        mcmcplot(res{PLOT_CHAIN_NUM}{2},[],res{PLOT_CHAIN_NUM}{1},'chainpanel');
        set(gcf,'Position',[100 100 2000 1000])
        saveas(t2, strcat('OUTPUT/', REGION_IN, '/', DATE, '_', REGION_IN, '_', PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE_IN, '_', int2str(PLOT_CHAIN_NUM), '_chainpanel.png'));

        t3 = figure(3); clf;
        mcmcplot(res{PLOT_CHAIN_NUM}{2},[],res{PLOT_CHAIN_NUM}{1},'pairs');
        set(gcf,'Position',[100 100 1500 1200])
        saveas(t3, strcat('OUTPUT/', REGION_IN, '/', DATE, '_', REGION_IN, '_',  PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE_IN, '_', int2str(PLOT_CHAIN_NUM), '_pairs.png'));

        t4 = figure(4); clf;
        mcmcplot(res{PLOT_CHAIN_NUM}{2},[],res{PLOT_CHAIN_NUM}{1},'denspanel',2);
        saveas(t4, strcat('OUTPUT/', REGION_IN, '/', DATE, '_', REGION_IN, '_',  PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE_IN, '_', int2str(PLOT_CHAIN_NUM), '_denspanel.png'));

        temp_res = res;%(2:6);
        Chains = cellfun(@(x) x{2}, temp_res, 'un', 0);
        Ress = cellfun(@(x) x{1}, temp_res, 'un', 0);

        t5 = plot_MCMC_results_fig2(100, Chains, ["Hcri", "R", "D"], pars_in, Ress, REGION_IN);

        saveas(t5, strcat('OUTPUT/', REGION_IN, '/', DATE, '_', REGION_IN, '_',  PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE_IN, '_', int2str(PLOT_CHAIN_NUM), '_fits.png'));
    else
        'WARNING: MISSING .mat FILE. DOUBLE CHECK INPUTS'
    end
end
