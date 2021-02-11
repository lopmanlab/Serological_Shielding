----------------------------------------------------------------------------------------------------------
MCMC Code for: Modeling serological testing to inform relaxation of social distancing for COVID-19 control
----------------------------------------------------------------------------------------------------------
MATLAB Version 2019a
https://mjlaine.github.io/mcmcstat/

Last Updated: 	2020.11.18
Updated by: 	CYZ


This folder contains our MCMC pipeline files:
	[Data]	nyc.csv; sflor.csv; and wash.csv 	:: Deaths Data
	[Data]	seroprevalence.xlsx 			:: Sero Data
	[Data]	SAH orders by location.xlsx 		:: Stay-At-Home orders for 6 different locales.
	[Data]	AgeStructure_byLocation.xlsx 		:: Census of age structure for florida, washington, and nyc

	[Main]	MCMC_find_optimal_parms_for_region.m	:: Main model-fitting function. Results saved to /OUTPUT/<region>/...
	[Main]	MCMC_Generate_Figures.m			:: Generates MCMC-related figures
	[Main]  Visualize_MCMC_traces.R			:: Visualizes MCMC chains. Example *_chains.csv files used are in /OUTPUT
							:: Plots are in /OUTPUT/MCMC Figures

	[Other]	2020-10-19_MCMCSTAT_constraints.xlsx 	:: Bounds for MCMC
	[Other]	2020-10-19_MCMCSTATmprsf_Diagnostics.xlsx :: mcmcstat's built-in Gelman-Rubin ddx criteria

