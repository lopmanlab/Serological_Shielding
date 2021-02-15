% This calculate convergences for each chain.
% The output is saved in adhoc.csv
DATE = "2021-02-13";

REGION_LIST = ["nyc", "sflor", "wash"];
adhoc_mat = zeros(3,10);

for j_region=1:3
    REGION = REGION_LIST{j_region};
    load(strcat('OUTPUT/', DATE, '_MCMCRun_', REGION, '_', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '.mat'))
    for i=1:9
        adhoc_mat(j_region,i) = mpsrf({RES_OUT{2}{2}(:,i) RES_OUT{3}{2}(:,i) RES_OUT{4}{2}(:,i) RES_OUT{5}{2}(:,i) RES_OUT{6}{2}(:,i) RES_OUT{7}{2}(:,i) RES_OUT{8}{2}(:,i) RES_OUT{9}{2}(:,i) RES_OUT{10}{2}(:,i) RES_OUT{11}{2}(:,i)});
    end
    adhoc_mat(j_region,10) = mpsrf({RES_OUT{2}{2} RES_OUT{3}{2} RES_OUT{4}{2} RES_OUT{5}{2} RES_OUT{6}{2} RES_OUT{7}{2} RES_OUT{8}{2} RES_OUT{9}{2} RES_OUT{10}{2} RES_OUT{11}{2}});
end

dlmwrite("adhoc.csv",adhoc_mat, 'precision', 9)


% load OUTPUT/2020-10-07_MCMCRun_nyc_LANCET_LL.mat
% for i=1:6
%     adhoc_mat(1,i) = mpsrf({RES_OUT{1}{2}(:,i) RES_OUT{2}{2}(:,i) RES_OUT{3}{2}(:,i) RES_OUT{4}{2}(:,i) RES_OUT{5}{2}(:,i) RES_OUT{6}{2}(:,i) RES_OUT{7}{2}(:,i) RES_OUT{8}{2}(:,i) RES_OUT{9}{2}(:,i) RES_OUT{10}{2}(:,i) RES_OUT{11}{2}(:,i)});
% end
% adhoc_mat(1,7) = mpsrf({RES_OUT{1}{2} RES_OUT{2}{2} RES_OUT{3}{2} RES_OUT{4}{2} RES_OUT{5}{2} RES_OUT{6}{2} RES_OUT{7}{2} RES_OUT{8}{2} RES_OUT{9}{2} RES_OUT{10}{2} RES_OUT{11}{2}});
% 
% load OUTPUT/2020-10-07_MCMCRun_sflor_LANCET_LL.mat
% for i=1:6
%     adhoc_mat(2,i) = mpsrf({RES_OUT{1}{2}(:,i) RES_OUT{2}{2}(:,i) RES_OUT{3}{2}(:,i) RES_OUT{4}{2}(:,i) RES_OUT{5}{2}(:,i) RES_OUT{6}{2}(:,i) RES_OUT{7}{2}(:,i) RES_OUT{8}{2}(:,i) RES_OUT{9}{2}(:,i) RES_OUT{10}{2}(:,i) RES_OUT{11}{2}(:,i)});
% end
% adhoc_mat(2,7) = mpsrf({RES_OUT{1}{2} RES_OUT{2}{2} RES_OUT{3}{2} RES_OUT{4}{2} RES_OUT{5}{2} RES_OUT{6}{2} RES_OUT{7}{2} RES_OUT{8}{2} RES_OUT{9}{2} RES_OUT{10}{2} RES_OUT{11}{2}});
% 
% load OUTPUT/2020-10-07_MCMCRun_wash_LANCET_LL.mat
% for i=1:6
%     adhoc_mat(3,i) = mpsrf({RES_OUT{1}{2}(:,i) RES_OUT{2}{2}(:,i) RES_OUT{3}{2}(:,i) RES_OUT{5}{2}(:,i) RES_OUT{6}{2}(:,i) RES_OUT{7}{2}(:,i) RES_OUT{8}{2}(:,i) RES_OUT{9}{2}(:,i) RES_OUT{10}{2}(:,i) RES_OUT{11}{2}(:,i)});
% end
% adhoc_mat(3,7) = mpsrf({RES_OUT{1}{2} RES_OUT{2}{2} RES_OUT{3}{2} RES_OUT{5}{2} RES_OUT{6}{2} RES_OUT{7}{2} RES_OUT{8}{2} RES_OUT{9}{2} RES_OUT{10}{2} RES_OUT{11}{2}});
