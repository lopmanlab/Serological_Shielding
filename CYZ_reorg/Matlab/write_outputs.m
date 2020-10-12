DATE = "2020-10-05c";

for REGION=["nyc", "sflor", "wash"]
    REGION
    
    load(strcat("OUTPUT/", DATE, "_MCMCRun_", REGION, "_LANCET_LLpen_unweighted.mat"))
    
    cHeader = {'q' 'c' 'symptomatic_fraction' 'socialDistancing_other' 'p_reduced' 'Initial_Condition_Scale' 'R0' 'i_chain'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    %write header to file
    fid = fopen(strcat("OUTPUT/", DATE, "_", REGION, "_chains.csv"),'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);

    cHeader = {'q' 'q_sd' ...
        'c' 'c_sd' ...
        'symptomatic_fraction' 'symptomatic_fraction_sd' ...
        'socialDistancing_other' 'socialDistancing_other_sd' ...
        'p_reduced' 'p_reduced_sd' ...
        'Initial_Condition_Scale' 'Initial_Condition_Scale_sd' ...
        'R0' 'R0_sd' ...
        'chain' ...
        'S_c' 'S_a' 'S_rc' 'S_fc' 'S_e' ...
        'E_c' 'E_a' 'E_rc' 'E_fc' 'E_e' ...
        'Isym_c' 'Isym_a' 'Isym_rc' 'Isym_fc' 'Isym_e' ...
        'Iasym_c' 'Iasym_a' 'Iasym_rc' 'Iasym_fc' 'Iasym_e' }; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    fid2 = fopen(strcat("OUTPUT/", DATE, "_", REGION, "_chains_summary.csv"),'w'); 
    fprintf(fid2,'%s\n',textHeader);
    fclose(fid2);

    % X0s
    temp = reshape(pars_in.X0_target, 5, 8);

    for i=1:11
        % Load chains
        test = RES_OUT{i}{2};

        test(:,7) = 0;
        % Calculate R0's
        for j=1:size(test,1)
            test(j,7) = Calc_R0_Theta(test(:,1:6), pars_in);
        end

        % Fix the multiplicative initial condition factor
        test_initMult=test(:,6)+1;
        mle_initMult = mle(test_initMult);
        
        % Keep track of which chain
        test(:,8)=i;

        % Write
        dlmwrite(strcat("OUTPUT/", DATE, "_", REGION, "_chains.csv"),test,'-append');
        test_summary = [mle(test(:,1)) ...
            mle(test(:,2)) ...
            mle(test(:,3)) ...
            mle(test(:,4)) ...
            mle(test(:,5)) ...
            mle_initMult ...
            mle(test(:,7)) ...
            i ...
            reshape(sum(temp, 2) - mle_initMult(1) * sum(temp(:,[2 3 4]),2), 1, 5) ... % Init susceptible
            mle_initMult(1) * pars_in.X0_target([pars_in.E_ids pars_in.Isym_ids pars_in. Iasym_ids])]; % Init Exposed, Sym, ASym
        dlmwrite(strcat("OUTPUT/", DATE, "_", REGION, "_chains_summary.csv"),test_summary,'-append');

    end

end