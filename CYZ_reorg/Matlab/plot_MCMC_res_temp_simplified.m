function out = plot_MCMC_res_temp_simplified(NSamples, Chains, Comps, Pars, Ress)
    %% Predictions from MCMC
 
    % For all Chains
    out = figure('Name', 'Res', 'Position', [5 5 500 600]); clf    
    COUNTER = 1;
    for k = 2:2%1:length(Chains)        
        Chain = Chains{k};
        Res = Ress{k};
        
        % Take second half of chain
        burnIn = floor(length(Chain)/2);
        burnOut = burnIn:length(Chain);

        chain_out = Chain(burnOut,:);
        i_samp = randi([1, length(burnOut)], 1,NSamples);

        chain_samp = chain_out(i_samp,:);

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
            
            if j_comp == "S"            % If we're plotting S, include sero
                plot(Pars.tSero, (1-Pars.sero/100)*Pars.N, 's', 'Color', [0.1, 0.1, 0.9], ...
                    'MarkerFaceColor',[1 .6 .6])
            elseif j_comp == "R"        % If we're plotting R, include sero
                plot(Pars.tSero, Pars.sero/100*Pars.N, 's', 'Color', [0.1, 0.1, 0.9], ...
                    'MarkerFaceColor',[1 .6 .6])
            elseif j_comp == "D"        % If deaths, include data
                plot(7*(1:Pars.nWeeks), cumsum(Pars.target), 's', 'Color', [0.1, 0.1, 0.9])
            end
            
            ylim([0, Inf])
            title(j_comp)
    end
end
