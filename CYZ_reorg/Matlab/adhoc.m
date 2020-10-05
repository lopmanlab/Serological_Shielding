clear
DATE = "2020-10-03";

PARAMETER_SET = "LANCET"; %PNAS     
REGION = "sflor";     
LIKELIHOOD_TYPE = "LLpen_scaled";

if isfile(strcat('OUTPUT/', DATE, '_MCMCRun_', REGION, '_', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '.mat'))
    load(strcat('OUTPUT/', DATE, '_MCMCRun_', REGION, '_', PARAMETER_SET, '_', LIKELIHOOD_TYPE, '.mat'))    
end
                
temp_res = res;
Chains = cellfun(@(x) x{2}, temp_res, 'un', 0);
Ress = cellfun(@(x) x{1}, temp_res, 'un', 0);
t5 = plot_MCMC_res_temp(100, Chains, ["S", "E", "Isym", "Iasym", "R", "D"], pars_in, Ress);
saveas(t5, strcat('OUTPUT/', REGION, '/TEMP', DATE, '_', REGION, '_',  PARAMETER_SET, '_', LIKELIHOOD_TYPE, '_fits.png'));