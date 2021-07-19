----------------------------------------------------------------------------------------------------------
MCMC Code for: Modeling serological testing to inform relaxation of social distancing for COVID-19 control
----------------------------------------------------------------------------------------------------------
MATLAB Version 2019a
core mcmcstat function is here: https://mjlaine.github.io/mcmcstat/

Last Updated: 	2021.07.19
Updated by: 	CYZ

To Run:
	(LOCAL)		(1) Set the # of chains and steps/chain in "default_sweep_parameters.m" 

			(2) Set MCMC Pars in "Run_MCMC_Pipeline"
				:: CHAIN_LENGTH				:: # of iterations per repeat
				:: CHAIN_REP				:: # Chain repeats - Total = CHAIN_LENGTH*(CHAIN_REP+1)
				:: N_CHAINS				:: # Independent Chain starts
			
			(3) Set Run Details in "Run_MCMC_Pipeline"
				:: DATE					:: Unique Identifier attached to all outputs
				:: REGION				:: "wash", "nyc", or "sflor" (NOTE: this is overwritten by line 16)
				:: PARAMETER_SET			:: In the current version, only MMWR parameters are provided
				:: LIKELIHOOD_TYPE			:: In the current version, only one LL function is provided
				:: N_VARS				:: Which vars to fit? Fit is in this order:
									:: q, c, p_sym, sd_red, p_red, asymp_red ...
									:: gamma_e, gamma_a, gamma_s, gamma_hs, gamma_hc
			
			(4) Run "Run_MCMC_Pipeline" for the following outputs:
				:: /OUTPUT/<DATE>_MCMCRun_<REGION>_<PSet>_<LLType>_NVarsFit<N_VARS>.mat 
									:: Raw chains (res) and parameters used
				:: /OUTPUT/<REGION>/...			:: Visual results for only the first chain

			(5) Change the Date & Run "MCMC_write_Gelman_Rubin_diagnostic.m"

			(6) Change the Date & Run "MCMC_Visualize_traces.R" for the following outputs:
				:: /OUTPUT/'MCMC Figures'/...		:: Summary figures for all chains & regions

	(CLUSTER)	PBS scripts are provided ("ClusterScripts/Run_On_PACE_mcmc_*.pbs") to generate .mat results. 
			Steps 5&6 still need to be run locally.


This folder contains our MCMC pipeline files:
	[/INPUT]	nyc.csv; sflor.csv; and wash.csv 		:: Deaths Data
	[/INPUT]	seroprevalence.xlsx 				:: Sero Data
	[/INPUT]	SAH orders by location.xlsx 			:: Stay-At-Home orders for 6 different locales.
	[/INPUT]	AgeStructure_byLocation.xlsx 			:: Census of age structure for florida, washington, and nyc

	[~]		MCMC_find_optimal_parms_for_region.m		:: Main model-fitting function. Results saved to /OUTPUT/<region>/...
	[~]		MCMC_write_Gelman_Rubin_diagnostic.m		:: Write *MCMCSTATmpsrf_Diagnostics.csv
	[~]		MCMC_Generate_Figures.m				:: Generates MCMC-related figures
	[~]		MCMC_Visualize_traces.R				:: Visualizes MCMC chains. Example *_chains.csv files used are in /OUTPUT
									:: Plots are in /OUTPUT/MCMC Figures

	[Other]		<DATE>_MCMCSTAT_constraints.xlsx 		:: Bounds for MCMC
	[Other]		<DATE>_MCMCSTATmprsf_Diagnostics.xlsx 		:: Gelman-Rubin Rhats (calcuated /w built-in fx from mcmcstat)

