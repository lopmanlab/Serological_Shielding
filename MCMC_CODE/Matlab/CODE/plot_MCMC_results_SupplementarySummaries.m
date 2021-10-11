function out = plot_MCMC_results_SupplementarySummaries(NSamples, Chains, Comps, Pars, Ress, REGION_IN, DATE_IN, PARAMETER_SET_IN, LIKELIHOOD_TYPE_IN, N_VARS_IN)
%% Predictions from MCMC

if REGION_IN == 'nyc'
    region_name = 'New York City';
elseif REGION_IN == 'sflor'
    region_name = 'South Florida';
elseif REGION_IN == 'wash'
    region_name = 'Washington Puget Sound';
end


% Change plot position
x0 = 10;
y0 = 10;
width = 600*length(Chains);
height = 3600;
out = figure('Name', 'Res', 'Position', [x0 y0 width height]); clf    

% For all Chains
for k = 1:length(Chains)        
    Chain = Chains{k};
    Res = Ress{k};

    % Take full chain
    burnIn = 1;% floor(length(Chain)/2); % Was originally sample half.
    burnOut = burnIn:length(Chain);
    chain_out = Chain(burnOut,:);

    i_samp = randi([1, length(burnOut)], 1,NSamples);
    chain_samp = chain_out(i_samp,:);


    % Plot by component.
    for j = 1:length(Comps)
        j_comp = Comps(j);

        % Subplot based on the # of components
        subplot(length(Comps), length(Chains), k+(j-1)*length(Chains))
        sgtitle(region_name, 'FontWeight', 'bold', 'FontSize', 18);
        set(gca,'linewidth',1, 'fontsize', 14);
        set(gcf, 'position', [x0,y0,width,height])
        hold on

        % Plot the mean chain
        mean_fit = SEIR_model_shields_Theta(Res.mean, Pars.times, Pars, j_comp, false).';
        % Sample the rest
        parfor i = 1:NSamples
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

        if k == 1        % Axis Title
            if j_comp == "S"            % If we're plotting S, include sero
                ylabel('Susceptible','fontweight','bold')

            elseif j_comp == "E"        % Exposed
                ylabel('Exposed','fontweight','bold')

            elseif j_comp == "Iasym"    % Asymptomatics
                ylabel('Asymptomatic','fontweight','bold')

            elseif j_comp == "Isym"     % Symptomatics
                ylabel('Symptomatic','fontweight','bold')

            elseif j_comp == "Hsub"     % Subcritical Hospitalizations
                ylabel('Subcrit Hosp','fontweight','bold')

            elseif j_comp == "Hcri"     % Critical Care Cases
                ylabel('Crit Cases','fontweight','bold')

            elseif j_comp == "R"        % If we're plotting R, include sero
                ylabel('Recovered','fontweight','bold')

            elseif j_comp == "D"        % If deaths, include data
                ylabel('Deaths','fontweight','bold')
            end
        end
        % For certain components, add additional information to the plot.
        if j_comp == "S"            % If we're plotting S, include sero
            plot(Pars.tSero+Pars.t0, (1-Pars.sero/100)*Pars.N, 's', 'Color', [1 0 0], ...
                'MarkerFaceColor',[1 0 0], 'DisplayName', 'S')
        elseif j_comp == "R"        % If we're plotting R, include sero
            plot(Pars.tSero+Pars.t0, Pars.sero/100*Pars.N, 's', 'Color', [.6 0 0], 'MarkerSize', 15, ...
                'MarkerFaceColor',[1 0 0], 'DisplayName', 'Serology data')
            legend({'Serology data'},'Location','northwest', 'fontsize', 13)
            legend boxoff
        elseif j_comp == "D"        % If deaths, include data
            plot(7*(1:Pars.nWeeks)+Pars.t0, cumsum(Pars.target), 's', 'Color', [0.2, 0.3, 0.6], 'MarkerSize', 15, ...
                'MarkerFaceColor', [0.3, 0.5, 0.9], 'DisplayName', 'Death data')
            legend({'Deaths data'},'Location','northwest',  'fontsize', 13)
            legend boxoff
            
        end
        ylim([0, Inf])
        xlim([Pars.t0, Pars.tf])

        box on
    end
end

Supplementary_Fig_File = strcat('OUTPUT/', REGION_IN, '/', DATE_IN, '_', REGION_IN, '_',  PARAMETER_SET_IN, '_', LIKELIHOOD_TYPE_IN, "_NVarsFit", int2str(N_VARS_IN), '_fits')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 32 20])
print(Supplementary_Fig_File, '-dpng')
%% not sure why this donn't work.  