% (1) Model Parameters ----------------------------------------------------
model_pars_reduced = [];

% Population
model_pars_reduced.N = 323*10^6;
model_pars_reduced.agefrac_0 = [0.119,0.124,0.134,0.131,0.124,0.133,0.119,0.073,0.03,0.013]; % ref (49)
model_pars_reduced.agestruc = [sum(model_pars_reduced.agefrac_0(1:2)), sum([model_pars_reduced.agefrac_0(3:6), 0.5*model_pars_reduced.agefrac_0(7)]), sum([0.5*model_pars_reduced.agefrac_0(7), model_pars_reduced.agefrac_0(8:10)])];

% Timeline
model_pars_reduced.t0 = "2020-01-01";
model_pars_reduced.nDays = 365; % days
model_pars_reduced.nWeeks = floor(365/7);
model_pars_reduced.times = 0:model_pars_reduced.nDays;

% Indices
model_pars_reduced.subgroups = ["c", "a", "rc", "fc", "e"];
model_pars_reduced.nSubgroups = length(model_pars_reduced.subgroups); %ALWAYS: c, a, rc, fc, e
N = model_pars_reduced.nSubgroups;

model_pars_reduced.compartments = ["S", "E", "Isym", "Iasym", "Hsub", "Hcri", "D", "R"];
model_pars_reduced.nCompartments = length(model_pars_reduced.compartments); %ALWAYS: S, E, Isym, Iasym, Hsub, Hcri, D, R
Nc = model_pars_reduced.nCompartments;

% Variable Names
model_pars_reduced.varNames = Get_Var_Names(model_pars_reduced.compartments, model_pars_reduced.subgroups);

temp_idxNames = 1:(N*Nc);
    %names(temp_idxNames) = model_pars_reduced.varNames; % Matlab doesn't
    %name variables.
model_pars_reduced.idxNames = temp_idxNames;

% Variables in Matrix Format
temp_varMat = reshape(model_pars_reduced.varNames, N, Nc);
    %colnames(temp_varMat) = model_pars_reduced.compartments;
    %rownames(temp_varMat) = model_pars_reduced.subgroups;
model_pars_reduced.varMat = temp_varMat; %columns are compartments, rows are population subclasses

temp_idxMat = reshape(model_pars_reduced.idxNames, N, Nc);
    %colnames(temp_idxMat) = model_pars_reduced.compartments;
    %rownames(temp_idxMat) = model_pars_reduced.subgroups;
model_pars_reduced.idxMat = temp_idxMat; %columns are compartments, rows are population subclasses

% Base Compartment Indices
model_pars_reduced.S_ids = 0*N+(1:N);
model_pars_reduced.E_ids = 1*N+(1:N);
model_pars_reduced.Isym_ids = 2*N+(1:N);
model_pars_reduced.Iasym_ids = 3*N+(1:N);
model_pars_reduced.Hsub_ids = 4*N+(1:N);
model_pars_reduced.Hcri_ids = 5*N+(1:N);
model_pars_reduced.D_ids = 6*N+(1:N);
model_pars_reduced.R_ids = 7*N+(1:N);


% IDs by SubGroup
model_pars_reduced.c_ids = ((1:Nc)-1)*N+1;
model_pars_reduced.a_ids = ((1:Nc)-1)*N+2;
model_pars_reduced.rc_ids = ((1:Nc)-1)*N+3;
model_pars_reduced.fc_ids = ((1:Nc)-1)*N+4;
model_pars_reduced.e_ids = ((1:Nc)-1)*N+5;

model_pars_reduced.nTotSubComp = N*Nc;


% (2) Contact Parameters --------------------------------------------------
contact_pars_reduced = [];

contact_pars_reduced.frac_home = 0.316;
contact_pars_reduced.frac_full = 0.0565;
contact_pars_reduced.frac_reduced = 1-contact_pars_reduced.frac_full-contact_pars_reduced.frac_home;

%3x3 data from Prem et al
contact_pars_reduced.AllContacts = reshape([9.75, 2.57, 0.82, 5.97, 10.32, 2.25, 0.39, 0.46, 1.20],3,3);
contact_pars_reduced.WorkContacts = reshape([0.20, 0.28, 0, 0.64, 4.73, 0, 0, 0, 0],3,3);
contact_pars_reduced.SchoolContacts = reshape([4.32, 0.47, 0.02, 1.10, 0.32, 0.04, 0.01, 0.01, 0.03],3,3);
contact_pars_reduced.HomeContacts = reshape([2.03, 1.02, 0.50, 2.37, 1.82, 0.68, 0.24, 0.14, 0.62],3,3);
contact_pars_reduced.OtherContacts = reshape([3.20, 0.80, 0.30, 1.86, 3.45, 1.53, 0.14, 0.32, 0.55],3,3);

% 5x5 Expansions
contact_pars_reduced.WorkContacts_5x5 = Expand_5x5(contact_pars_reduced.WorkContacts,contact_pars_reduced.frac_home,contact_pars_reduced.frac_reduced,contact_pars_reduced.frac_full);
contact_pars_reduced.HomeContacts_5x5 = Expand_5x5(contact_pars_reduced.HomeContacts,contact_pars_reduced.frac_home,contact_pars_reduced.frac_reduced,contact_pars_reduced.frac_full);
contact_pars_reduced.SchoolContacts_5x5 = Expand_5x5(contact_pars_reduced.SchoolContacts,contact_pars_reduced.frac_home,contact_pars_reduced.frac_reduced,contact_pars_reduced.frac_full);
contact_pars_reduced.OtherContacts_5x5 = Expand_5x5(contact_pars_reduced.OtherContacts,contact_pars_reduced.frac_home,contact_pars_reduced.frac_reduced,contact_pars_reduced.frac_full);



% (3) Intervention Pars ---------------------------------------------------
intervention_pars_reduced = [];

% Test Data for Cellex (from April 2020)
intervention_pars_reduced.sensitivity = 1.00;
intervention_pars_reduced.specificity = 0.998;
intervention_pars_reduced.daily_tests = 10^3;

% Other intervention parameters
intervention_pars_reduced.tStart_distancing = 70;
intervention_pars_reduced.tStart_test = 107;    % can change when in the outbreak testing becomes available
intervention_pars_reduced.tStart_target = 115;
intervention_pars_reduced.tStart_school = 230;
intervention_pars_reduced.tStart_reopen = 500;

intervention_pars_reduced.socialDistancing_other = 0.25; % fraction of contacts reduced to when social distancing
intervention_pars_reduced.p_reduced = 0.5;      % proportion of contacts reduced to
intervention_pars_reduced.p_full = 1;           % proportion of contacts reduced to for full contact adults

intervention_pars_reduced.alpha = 1;            % shielding. Note this is not alpha_JSW, but (alpha_JSW+1)
intervention_pars_reduced.c = 1;

intervention_pars_reduced.socialDistancing_other_c = 0.25;
intervention_pars_reduced.p_reduced_c = 0.1;

% Modified 5x5s
temp_reduction = [0;0;intervention_pars_reduced.p_reduced;intervention_pars_reduced.p_full;0];
contact_pars_reduced.WorkContacts_Distancing_5x5=contact_pars_reduced.WorkContacts_5x5.*temp_reduction;
contact_pars_reduced.OtherContacts_Distancing_5x5=contact_pars_reduced.OtherContacts_5x5*intervention_pars_reduced.socialDistancing_other;


% (4) Epi Pars ------------------------------------------------------------
epi_pars_reduced = [];

epi_pars_reduced.R0 = 2.9;                  % Note on R0: with base structure 63.28q
epi_pars_reduced.q = 0.039;                % Probability of transmission from children
epi_pars_reduced.asymp_red = 0.55;          % Relative infectiousness of asymptomatic vs symptomatic case

epi_pars_reduced.gamma_e = 1/3;             % Latent period (He et al)
epi_pars_reduced.gamma_a = 1/7;             % Recovery rate, undocumented (Kissler et al)
epi_pars_reduced.gamma_s = 1/7;             % Recovery rate, undocumented (Kissler et al)
epi_pars_reduced.gamma_hs = 1/5;           % LOS for subcritical cases (medrxiv paper)
epi_pars_reduced.gamma_hc = 1/7;           % LOS for critical cases (medrxiv paper)
epi_pars_reduced.p_symptomatic = 0.5;      % Fraction "Symptomatic/documented" (Shaman"s paper)

epi_pars_reduced.hosp_frac = [0.002, 0.056, 0.224];     % Of the symptomatic cases, how many are hospitalized?
epi_pars_reduced.hosp_crit = [0.001, 0.0048, 0.099];     % Of the symptomatic cases, how many are critically hospitalized?
epi_pars_reduced.crit_die = [0, 0.5, 0.5];              % Obtained from initial fitting

epi_pars_reduced.hosp_frac_5 = epi_pars_reduced.hosp_frac([1,2,2,2,3]);
epi_pars_reduced.hosp_crit_5 = epi_pars_reduced.hosp_crit([1,2,2,2,3]);
epi_pars_reduced.crit_die_5 = epi_pars_reduced.crit_die([1,2,2,2,3]);  

% Overwrite Using Ferguson Parms


% (5) Inits ---------------------------------------------------------------

% Initial conditions
inits = [];

inits.Isym_c0 = 60;
inits.Isym_a0 = 20;
inits.Isym_rc0 = 50;
inits.Isym_fc0 = 1;
inits.Isym_e0 = 40;

inits.Iasym_c0 = 0;
inits.Iasym_a0 = 0;
inits.Iasym_rc0 = 0;
inits.Iasym_fc0 = 0;
inits.Iasym_e0 = 0;


% (6) Remainder -----------------------------------------------------------

% Combine
pars_default = [];

f = fieldnames(model_pars_reduced);
for i = 1:length(f)
    pars_default.(f{i}) = model_pars_reduced.(f{i});
end

f = fieldnames(contact_pars_reduced);
for i = 1:length(f)
    pars_default.(f{i}) = contact_pars_reduced.(f{i});
end

f = fieldnames(intervention_pars_reduced);
for i = 1:length(f)
    pars_default.(f{i}) = intervention_pars_reduced.(f{i});
end

f = fieldnames(epi_pars_reduced);
for i = 1:length(f)
    pars_default.(f{i}) = epi_pars_reduced.(f{i});
end

f = fieldnames(inits);
for i = 1:length(f)
    pars_default.(f{i}) = inits.(f{i});
end


% (7) Test Cases ----------------------------------------------------------

X0 = Get_Inits(pars_default);

clear("contact_pars_reduced", "epi_pars_reduced", "f", "i", "inits", "intervention_pars_reduced", "model_pars_reduced", "N", "Nc", "temp_idxMat", "temp_idxNames", "temp_varMat", "temp_reduction");