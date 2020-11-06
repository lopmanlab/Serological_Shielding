function out = plot_MCMC_res_temp_simplified(NSamples, Chains, Comps, Pars, Ress)
%% Predictions from MCMC

% For all Chains
out = figure('Name', 'Res', 'Position', [5 5 500 600]); clf    
COUNTER = 1;
k = 2;
Chain = Chains{k};
Res = Ress{k};

% Take second half of chain
burnIn = floor(length(Chain)/2);
burnOut = burnIn:length(Chain);

chain_out = Chain(burnOut,:);
i_samp = randi([1, length(burnOut)], 1,NSamples);

chain_samp = chain_out(i_samp,:);

% Plot by component.
for j = 1:length(Comps)
    j_comp = Comps(j);
    
    % Subplot based on the # of components
    subplot(length(Comps), 1, j)
    hold on

    % Plot the mean chain
    mean_fit = SEIR_model_shields_Theta(Res.mean, Pars.times, Pars, j_comp, false).';
    % Sample the rest
    for i = 1:NSamples
        i_th = chain_samp(i,:);
        sampled_fits(i,:) = SEIR_model_shields_Theta(i_th, Pars.times, Pars, j_comp, false);
    end
    
    % x values
    ts = 1:size(sampled_fits,2); % I can only do this b/c I set days as the unit
    
    % y values
    mean_sampled_fits = mean(sampled_fits);
    std_sampled_fits = std(sampled_fits);
    
    ci_higher_sampled_fits = mean_sampled_fits + 1.96*std_sampled_fits;
    ci_lower_sampled_fits = mean_sampled_fits - 1.96*std_sampled_fits;
    
    % plots
    fill([ts, fliplr(ts)], ...
        [ci_higher_sampled_fits, fliplr(ci_lower_sampled_fits)], ...
        [0.7, 0.7, 0.7],'LineStyle','none')
    
    plot(ts, ci_higher_sampled_fits, '-.', 'LineWidth', 1, 'Color', [0.3, 0.3, 0.3]);
    plot(ts, ci_lower_sampled_fits, '-.', 'LineWidth', 1, 'Color', [0.3, 0.3, 0.3]);
    plot(ts, mean_sampled_fits, 'LineWidth', 2);
    
 
    % For certain components, add additional information to the plot.
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
