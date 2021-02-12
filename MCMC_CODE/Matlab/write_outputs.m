DATE = "2021-02-11";

cHeader = {'region (NEED TO MANUAL APPEND)'...
    'S_c' 'S_a' 'S_rc' 'S_fc' 'S_e' ...
    'E_c' 'E_a' 'E_rc' 'E_fc' 'E_e' ...
    'Isym_c' 'Isym_a' 'Isym_rc' 'Isym_fc' 'Isym_e' ...
    'Iasym_c' 'Iasym_a' 'Iasym_rc' 'Iasym_fc' 'Iasym_e' ...
    'Hsub_c' 'Hsub_a' 'Hsub_rc' 'Hsub_fc' 'Hsub_e' ...
    'Hcri_c' 'Hcri_a' 'Hcri_rc' 'Hcri_fc' 'Hcri_e' ...
    'D_c' 'D_a' 'D_rc' 'D_fc' 'D_e' ...
    'R_c' 'R_a' 'R_rc' 'R_fc' 'R_e' ...
    }; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
%write header to file
fid = fopen(strcat("OUTPUT/", DATE, "_targetInits.csv"),'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);


for REGION=["nyc", "sflor", "wash"]
    REGION
    
    load(strcat("OUTPUT/", DATE, "_MCMCRun_", REGION, "_LANCET_LL.mat"))
    
    cHeader = {'q' 'c' 'symptomatic_fraction' 'socialDistancing_other' 'p_reduced' 'Initial_Condition_Scale' 'LogLikelihood' 'R0' 'i_chain'}; %dummy header
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
        'Iasym_c' 'Iasym_a' 'Iasym_rc' 'Iasym_fc' 'Iasym_e' ...
        'Hsub_c' 'Hsub_a' 'Hsub_rc' 'Hsub_fc' 'Hsub_e' ...
        'Hcri_c' 'Hcri_a' 'Hcri_rc' 'Hcri_fc' 'Hcri_e' ...
        'D_c' 'D_a' 'D_rc' 'D_fc' 'D_e' ...
        'R_c' 'R_a' 'R_rc' 'R_fc' 'R_e' ...
        }; %dummy header
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
        
        % Add Likelihoods to column 7
        test = adhoc_append(test, pars_in);
        
        % Calculate R0's on column 8
        test(:,8) = 0;
        for j=1:size(test,1)
            test(j,8) = Calc_R0_Theta(test(j,1:6), pars_in);
        end

        % Fix the multiplicative initial condition factor on column 6
        test_initMult=test(:,6);
        mle_initMult = mle(test_initMult);
        
        % Keep track of which chain on column 9
        test(:,9)=i;

        % Write
        dlmwrite(strcat("OUTPUT/", DATE, "_", REGION, "_chains.csv"),test,'-append', 'precision', 9);
        test_summary = [mle(test(:,1)) ...
            mle(test(:,2)) ...
            mle(test(:,3)) ...
            mle(test(:,4)) ...
            mle(test(:,5)) ...
            mle_initMult ...
            mle(test(:,8)) ...
            i ...
            reshape(pars_in.X0_target([pars_in.S_ids])' - mle_initMult(1) * sum(temp(:,[2 3 4]),2), 1, 5) ... % Init susceptible
            (1+mle_initMult(1)) * pars_in.X0_target([pars_in.E_ids pars_in.Isym_ids pars_in.Iasym_ids]) ...
            pars_in.X0_target([pars_in.Hsub_ids pars_in.Hcri_ids pars_in.D_ids pars_in.R_ids])]; % Init Exposed, Sym, ASym
        dlmwrite(strcat("OUTPUT/", DATE, "_", REGION, "_chains_summary.csv"),test_summary,'-append', 'precision', 9);

    end

    dlmwrite(strcat("OUTPUT/", DATE, "_targetInits.csv"), round(pars_in.X0_target),'-append', 'precision', 9);

    
end