% This calculate convergences for each chain.
% The output is saved in adhoc.csv

adhoc_mat = zeros(3,7);
load OUTPUT/2020-10-07_MCMCRun_wash_LANCET_LL.mat
for i=1:6
    adhoc_mat(3,i) = mpsrf({RES_OUT{1}{2}(:,i) RES_OUT{2}{2}(:,i) RES_OUT{3}{2}(:,i) RES_OUT{5}{2}(:,i) RES_OUT{6}{2}(:,i) RES_OUT{7}{2}(:,i) RES_OUT{8}{2}(:,i) RES_OUT{9}{2}(:,i) RES_OUT{10}{2}(:,i) RES_OUT{11}{2}(:,i)});
end
adhoc_mat(3,7) = mpsrf({RES_OUT{1}{2} RES_OUT{2}{2} RES_OUT{3}{2} RES_OUT{5}{2} RES_OUT{6}{2} RES_OUT{7}{2} RES_OUT{8}{2} RES_OUT{9}{2} RES_OUT{10}{2} RES_OUT{11}{2}});

load OUTPUT/2020-10-07_MCMCRun_nyc_LANCET_LL.mat
for i=1:6
    adhoc_mat(1,i) = mpsrf({RES_OUT{1}{2}(:,i) RES_OUT{2}{2}(:,i) RES_OUT{3}{2}(:,i) RES_OUT{4}{2}(:,i) RES_OUT{5}{2}(:,i) RES_OUT{6}{2}(:,i) RES_OUT{7}{2}(:,i) RES_OUT{8}{2}(:,i) RES_OUT{9}{2}(:,i) RES_OUT{10}{2}(:,i) RES_OUT{11}{2}(:,i)});
end
adhoc_mat(1,7) = mpsrf({RES_OUT{1}{2} RES_OUT{2}{2} RES_OUT{3}{2} RES_OUT{4}{2} RES_OUT{5}{2} RES_OUT{6}{2} RES_OUT{7}{2} RES_OUT{8}{2} RES_OUT{9}{2} RES_OUT{10}{2} RES_OUT{11}{2}});

load OUTPUT/2020-10-07_MCMCRun_sflor_LANCET_LL.mat
for i=1:6
    adhoc_mat(2,i) = mpsrf({RES_OUT{1}{2}(:,i) RES_OUT{2}{2}(:,i) RES_OUT{3}{2}(:,i) RES_OUT{4}{2}(:,i) RES_OUT{5}{2}(:,i) RES_OUT{6}{2}(:,i) RES_OUT{7}{2}(:,i) RES_OUT{8}{2}(:,i) RES_OUT{9}{2}(:,i) RES_OUT{10}{2}(:,i) RES_OUT{11}{2}(:,i)});
end
adhoc_mat(2,7) = mpsrf({RES_OUT{1}{2} RES_OUT{2}{2} RES_OUT{3}{2} RES_OUT{4}{2} RES_OUT{5}{2} RES_OUT{6}{2} RES_OUT{7}{2} RES_OUT{8}{2} RES_OUT{9}{2} RES_OUT{10}{2} RES_OUT{11}{2}});

dlmwrite("adhoc.csv",adhoc_mat, 'precision', 9)