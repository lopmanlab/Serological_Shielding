function out = plot_MCMC_results_fig2(NSamples, Chains, Comps, Pars, Ress, REGION)
%% Predictions from MCMC

if REGION == 'nyc'
    region_name = 'New York City';
elseif REGION == 'sflor'
    region_name = 'South Florida';
elseif REGION == 'wash'
    region_name = 'Washington Puget Sound';
end

% For all Chains
out = figure('Name', 'Res', 'Position', [6 6 1000 1000]); clf    
k = 2;
Chain = Chains{k};
Res = Ress{k};

% Take full chain
burnIn = 1;% floor(length(Chain)/2); % Was originally sample half.
burnOut = burnIn:length(Chain);
chain_out = Chain(burnOut,:);

i_samp = randi([1, length(burnOut)], 1,NSamples);
chain_samp = chain_out(i_samp,:);

% Change plot position
x0 = 0;
y0 = 0;
width = 600;
height = 1600;

% Plot by component.
for j = 1:length(Comps)
    j_comp = Comps(j);
    
    % Subplot based on the # of components
    subplot(length(Comps), 1, j)
    sgtitle(region_name, 'FontWeight', 'bold', 'FontSize', 30);
    set(gca,'linewidth',1, 'fontsize', 18);
    set(gcf, 'position', [x0,y0,width,height])
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
    ts = ts+Pars.t0;
    
    % y values
    mean_sampled_fits = mean(sampled_fits);
    std_sampled_fits = std(sampled_fits);
    
    ci_higher_sampled_fits = mean_sampled_fits + 1.96*std_sampled_fits;
    ci_lower_sampled_fits = mean_sampled_fits - 1.96*std_sampled_fits;
    
    % plots
    fill([ts, fliplr(ts)], ...
        [ci_higher_sampled_fits, fliplr(ci_lower_sampled_fits)], ...
        [0.7, 0.7, 0.7],'LineStyle','none','HandleVisibility','off')
    
    plot(ts, ci_higher_sampled_fits, '-.', 'LineWidth', 1, 'Color', [0.3, 0.3, 0.3], ...
        'HandleVisibility','off');
    plot(ts, ci_lower_sampled_fits, '-.', 'LineWidth', 1, 'Color', [0.3, 0.3, 0.3], ...
        'HandleVisibility','off');
    plot(ts, mean_sampled_fits, 'LineWidth', 2, 'Color', [0 0 0], ...
        'HandleVisibility','off');
    
    % For certain components, add additional information to the plot.
    ylabel_xpos = -30;

    if j_comp == "S"            % If we're plotting S, include sero
        plot(Pars.tSero+Pars.t0, (1-Pars.sero/100)*Pars.N, 's', 'Color', [1 0 0], ...
            'MarkerFaceColor',[1 0 0], 'DisplayName', 'S')
        ylabel('Cumulative susceptible','fontweight','bold')
        
    elseif j_comp == "E"        % Exposed
        ylabel('Exposed individuals','fontweight','bold')
        
    elseif j_comp == "Iasym"    % Asymptomatics
        ylabel('Asymptomatic infectees','fontweight','bold')
        
    elseif j_comp == "Isym"     % Symptomatics
        ylabel('Symptomatic individuals','fontweight','bold')
        
    elseif j_comp == "Hsub"     % Subcritical Hospitalizations
        ylabel('Subcritical Hospitalizations','fontweight','bold')
        
    elseif j_comp == "Hcri"     % Critical Care Cases
        yl=ylabel('Crit Cases', 'fontweight', 'bold');
        pos=get(yl,'Pos');
        set(yl,'Pos',[ylabel_xpos pos(2) pos(3)]);
        
    elseif j_comp == "R"        % If we're plotting R, include sero
        plot(Pars.tSero+Pars.t0, Pars.sero/100*Pars.N, 's', 'Color', [.6 0 0], 'MarkerSize', 15, ...
            'MarkerFaceColor',[1 0 0], 'DisplayName', 'Serology data')
        legend({'Serology data'},'Location','southeast', 'fontsize', 18)
        legend boxoff
        yl=ylabel('Recovered','fontweight','bold');
        pos=get(yl,'Pos');
        set(yl,'Pos',[ylabel_xpos pos(2) pos(3)]);
        
    elseif j_comp == "D"        % If deaths, include data
        plot(7*(1:Pars.nWeeks)+Pars.t0, cumsum(Pars.target), 's', 'Color', [0.2, 0.3, 0.6], 'MarkerSize', 15, ...
            'MarkerFaceColor', [0.3, 0.5, 0.9], 'DisplayName', 'Death data')
        legend({'Death data'},'Location','southeast',  'fontsize', 18)
        legend boxoff
        yl=ylabel('Deaths','fontweight','bold');
        pos=get(yl,'Pos');
        set(yl,'Pos',[ylabel_xpos pos(2) pos(3)]);
        
    end
    ylim([0, Inf])
    xlim([Pars.t0, Pars.tf])
    
    
    box on
end

