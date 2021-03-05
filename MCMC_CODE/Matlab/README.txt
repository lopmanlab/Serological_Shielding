----------------------------------------------------------------------------------------------------------
MCMC Code for: Modeling serological testing to inform relaxation of social distancing for COVID-19 control
----------------------------------------------------------------------------------------------------------
MATLAB Version 2019a
core mcmcstat function is here: https://mjlaine.github.io/mcmcstat/

Last Updated: 	2021.03.02
Updated by: 	CYZ

To Run:
	(LOCAL)		(1) Set the # of chains and steps/chain in "default_sweep_parameters.m" 
			(2) Run "sweep_region_parameters_*_5var.m"
			(3) Update the constraint excel sheet (copy into new one titled "<date>_MCMCSTAT_*.xlsx"
			(4) Run "MCMC_Visualize_traces.R"

	(CLUSTER)	PBS scripts are provided ("Run_On_PACE_mcmc_*.pbs")


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

	[Other]		2020-10-19_MCMCSTAT_constraints.xlsx 		:: Bounds for MCMC
	[Other]		2020-10-19_MCMCSTATmprsf_Diagnostics.xlsx 	:: mcmcstat's built-in Gelman-Rubin ddx criteria

