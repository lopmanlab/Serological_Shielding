load OUTPUT/2020-10-05c_MCMCRun_nyc_LANCET_LLpen_scaled.mat

cHeader = {'q' 'c' 'symptomatic_fraction' 'socialDistancing_other' 'p_reduced' 'Initial_Condition_Scale' 'i_chain'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
%write header to file
fid = fopen('OUTPUT/nyc_chains.csv','w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);

cHeader = {'q' 'q_sd' ...
    'c' 'c_sd' ...
    'symptomatic_fraction' 'symptomatic_fraction_sd' ...
    'socialDistancing_other' 'socialDistancing_other_sd' ...
    'p_reduced' 'p_reduced_sd' ...
    'Initial_Condition_Scale' 'Initial_Condition_Scale_sd' ...
    'chain' ...
    'S_c' 'S_a' 'S_rc' 'S_fc' 'S_e' ...
    'E_c' 'E_a' 'E_rc' 'E_fc' 'E_e' ...
    'Isym_c' 'Isym_a' 'Isym_rc' 'Isym_fc' 'Isym_e' ...
    'Iasym_c' 'Iasym_a' 'Iasym_rc' 'Iasym_fc' 'Iasym_e' }; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
fid2 = fopen('OUTPUT/nyc_chains_summary.csv','w'); 
fprintf(fid2,'%s\n',textHeader);
fclose(fid2);

% X0s
temp = reshape(pars_in.X0_target, 5, 8);
for i=1:11
    test = RES_OUT{i}{2};
    test(:,6)=test(:,6)+1;
    test(:,7)=i;
    dlmwrite('OUTPUT/nyc_chains.csv',test,'-append');
    
    test_summary = [mle(test(:,1)) ...
        mle(test(:,2)) ...
        mle(test(:,3)) ...
        mle(test(:,4)) ...
        mle(test(:,5)) ...
        mle(test(:,6)) ...
        i ...
        reshape(sum(temp(:,[1 5 6 7 8]), 2), 1, 5) ...
        pars_in.X0_target([pars_in.E_ids pars_in.Isym_ids pars_in. Iasym_ids])];
    dlmwrite('OUTPUT/nyc_chains_summary.csv',test_summary,'-append');

end