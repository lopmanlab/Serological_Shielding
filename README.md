# Serological_Shielding

This folder contains code used to build a model of serological shielding, which explores the impacts of using an imperfect
serological test to inform social distancing policies at a population scale. We use an SEIR-like transmission model structure
and examine the impact of policy changes relating to both relaxing social distancing measures and testing on cumulative deaths,
the number of people released from national social distancing, and US health system burden.

This repository is organized into the following subfolders: 

MCMC_CODE    --> contains all code needed to fit the model using MCMC methods.  Code to make main text Figure 2 as well as supplementary Figures S1-S10 is also included.

MLE_sims     --> contains code needed to simulate the model at the MLE for each location (as estimated using MCMC).  Code to make graphs at the MLE is also in this folder (used to make Figures 3-5 of the main text as well as Table S3 in the supplementary materials)

Credible_Interval_Files --> contains code to select and simulate parameter sets for the credible/simulation intervals from the end of the MCMC chains (used to derive all credible intervals presented in the paper)

ClusterLHS_07092021 --> contains code to run LHS for each site and also derives the PRCCs for each site (making figures S12-S14 of the main text).

vaccinesims --> contains code to run the model with vaccination (summarized in table S4 in the main text).

2021-06-25_AdhocClusterFits --> contains older code for LHS sampling (not used in the manuscript)

Old code files        --> contains code from older versions of the model

The MCMC, MLE, and credible interval folders contain readme files with more details about each subfolder organization.
