clear
DATE = "2020-10-13";

for PARAMETER_SET = ["LANCET"] %PNAS     
    for REGION = ["wash", "sflor", "nyc"]        
        for LIKELIHOOD_TYPE = ["LLpen_rescaled"]%, "SSpen_scaled"]

            if isfile(strcat('OUTPUT/', DATE, '_MCMCRun_', REGION, '_', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '.mat'))
                load(strcat('OUTPUT/', DATE, '_MCMCRun_', REGION, '_', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '.mat'))    

                t2 = figure(2); clf;
                mcmcplot(chain1,[],res1,'chainpanel');
                saveas(t2, strcat('OUTPUT/', REGION, '/', DATE, '_', REGION, '_', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '_chainpanel.png'));

                t3 = figure(3); clf;
                mcmcplot(chain1,[],res1,'pairs');
                saveas(t3, strcat('OUTPUT/', REGION, '/', DATE, '_', REGION, '_',  PARAMETER_SET, '_', LIKELIHOOD_TYPE, '_pairs.png'));

                t4 = figure(4); clf;
                mcmcplot(chain1,[],res1,'denspanel',2);
                saveas(t4, strcat('OUTPUT/', REGION, '/', DATE, '_', REGION, '_',  PARAMETER_SET, '_', LIKELIHOOD_TYPE, '_denspanel.png'));

                temp_res = res;%(2:6);
                Chains = cellfun(@(x) x{2}, temp_res, 'un', 0);
                Ress = cellfun(@(x) x{1}, temp_res, 'un', 0);
                t5 = plot_MCMC_res_temp(50, Chains, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, Ress);
                saveas(t5, strcat('OUTPUT/', REGION, '/', DATE, '_', REGION, '_',  PARAMETER_SET, '_', LIKELIHOOD_TYPE, '_fits.png'));
            end
        
        end 
    end
end


%% Predictions from MCMC
%plot_MCMC_res(100, {chain1, chain2, chain3, chain4}, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, {res1, res2, res3, res4})

