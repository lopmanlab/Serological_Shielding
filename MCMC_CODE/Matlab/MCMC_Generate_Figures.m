clear
DATE = "2021-02-15c";
addpath(genpath(pwd))

for PARAMETER_SET_IN = ["MMWR"] 
    for REGION = ["nyc", "sflor", "wash"]        
        for LIKELIHOOD_TYPE = ["LL"]
            if isfile(strcat('OUTPUT/', DATE, '_MCMCRun_', REGION, '_', PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE, '.mat'))
                load(strcat('OUTPUT/', DATE, '_MCMCRun_', REGION, '_', PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE, '.mat'))    
                
                PLOT_CHAIN_NUM = 2;
                
                t2 = figure(2); clf;
                mcmcplot(res{PLOT_CHAIN_NUM}{2},[],res{PLOT_CHAIN_NUM}{1},'chainpanel');
                set(gcf,'Position',[100 100 2000 1000])
                saveas(t2, strcat('OUTPUT/', REGION, '/', DATE, '_', REGION, '_', PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE, '_chainpanel.png'));

                t3 = figure(3); clf;
                mcmcplot(res{PLOT_CHAIN_NUM}{2},[],res{PLOT_CHAIN_NUM}{1},'pairs');
                set(gcf,'Position',[100 100 1500 1200])
                saveas(t3, strcat('OUTPUT/', REGION, '/', DATE, '_', REGION, '_',  PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE, '_pairs.png'));

                t4 = figure(4); clf;
                mcmcplot(res{PLOT_CHAIN_NUM}{2},[],res{PLOT_CHAIN_NUM}{1},'denspanel',2);
                saveas(t4, strcat('OUTPUT/', REGION, '/', DATE, '_', REGION, '_',  PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE, '_denspanel.png'));

                temp_res = res;%(2:6);
                Chains = cellfun(@(x) x{2}, temp_res, 'un', 0);
                Ress = cellfun(@(x) x{1}, temp_res, 'un', 0);
               
                t5 = plot_MCMC_results_fig2(100, Chains, ["Hcri", "R", "D"], pars_in, Ress, REGION);
                    
                saveas(t5, strcat('OUTPUT/', REGION, '/', DATE, '_', REGION, '_',  PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE, '_fits.png'));
            end
        end 
    end
end

