clear
for STATE = ["sflor", "wash", "nyc"]
    for PARSET = ["LANCET", "PNAS"]

        load(strcat('OUTPUT/2020-09-07_MCMCRun_', STATE, '_', PARSET, '.mat'))

        %t1 = plot_MCMC_res(500, {chain1, chain2, chain3, chain4}, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, {res1, res2, res3, res4});
        %saveas(t1, strcat('OUTPUT/', STATE, '/', PARSET, '_res.png'));

        t2 = figure(2); clf;
        mcmcplot(chain1,[],res1,'chainpanel');
        saveas(t2, strcat('OUTPUT/', STATE, '/', PARSET, '_chainpanel.png'));

        t3 = figure(3); clf;
        mcmcplot(chain1,[],res1,'pairs');
        saveas(t3, strcat('OUTPUT/', STATE, '/', PARSET, '_pairs.png'));

        t4 = figure(4); clf;
        mcmcplot(chain1,[],res1,'denspanel',2);
        saveas(t4, strcat('OUTPUT/', STATE, '/', PARSET, '_denspanel.png'));

    end
end


%% Predictions from MCMC
%plot_MCMC_res(100, {chain1, chain2, chain3, chain4}, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, {res1, res2, res3, res4})
