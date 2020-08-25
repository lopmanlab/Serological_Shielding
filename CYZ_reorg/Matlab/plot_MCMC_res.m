function out = plot_MCMC_res(NSamples, Chain, Comps, Pars, Res)
    %% Predictions from MCMC
    chain_out = Chain(50000:100000,:);
    i_samp = randi([1, 50000], 1,NSamples);

    chain_samp = chain_out(i_samp,:);

    figure; clf
    % For all Components
    for j = 1:length(Comps)
        j_comp = Comps(j);
        subplot(length(Comps), 1, j)
        hold on
        % For all Samples
        for i = 1:NSamples
            i_th = chain_samp(i,:);
            i_res = SEIR_model_shields_Theta(i_th, Pars.times, Pars, j_comp, false);
            plot((1:length(i_res)), i_res, 'Color',[0.9-0.1*rand(),0.9,0.9])
        end
        mean_res = SEIR_model_shields_Theta(Res.mean, Pars.times, Pars, j_comp, false);
        plot((1:length(mean_res)), mean_res, 'LineWidth', 3)
        % If deaths, include data
        if j_comp == "D"
            plot(7*(1:Pars.nWeeks), cumsum(Pars.target), 's')
        end
        title(j_comp)
    out = chain_samp;
end
