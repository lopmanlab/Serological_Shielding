clear
for PARAMETER_SET = ["PNAS", "LANCET"]    
    for REGION = ["sflor", "nyc", "wash"]        
        for LIKELIHOOD_TYPE = ["SSpen", "SS", "LL"]

        load(strcat('OUTPUT/2020-09-15_MCMCRun_', REGION, '_', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '.mat'))

        %t1 = plot_MCMC_res(500, {chain1, chain2, chain3, chain4}, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, {res1, res2, res3, res4});
        %saveas(t1, strcat('OUTPUT/', STATE, '/', PARSET, '_res.png'));

        %t2 = figure(2); clf;
        %mcmcplot(chain1,[],res1,'chainpanel');
        %saveas(t2, strcat('OUTPUT/', REGION, '/', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '_chainpanel.png'));

        %t3 = figure(3); clf;
        %mcmcplot(chain1,[],res1,'pairs');
        %saveas(t3, strcat('OUTPUT/', REGION, '/', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '_pairs.png'));

        %t4 = figure(4); clf;
        %mcmcplot(chain1,[],res1,'denspanel',2);
        %saveas(t4, strcat('OUTPUT/', REGION, '/', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '_denspanel.png'));
        
        temp_res = res(2:6);
        Chains = cellfun(@(x) x{2}, temp_res, 'un', 0);
        Ress = cellfun(@(x) x{1}, temp_res, 'un', 0);
        t5 = plot_MCMC_res(100, Chains, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, Ress);
        saveas(t5, strcat('OUTPUT/', REGION, '/', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '_fits.png'));
        
        end 
    end
end


%% Predictions from MCMC
%plot_MCMC_res(100, {chain1, chain2, chain3, chain4}, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, {res1, res2, res3, res4})

