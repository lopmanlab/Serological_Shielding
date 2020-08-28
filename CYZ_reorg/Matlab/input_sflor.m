input_defaults

%% Set to default
pars_sflor = pars_default;

%% Read SFLOR Data
sflor_data = csvread('sflor.csv',1,2); % don't read text columns
temp_y = [0;sflor_data]; % 3 is deaths, 2 is cases
l_temp = length(temp_y);
dydt = temp_y(2:l_temp) - temp_y(1:(l_temp-1));

% Set the target as the rate of new deaths.
pars_sflor.target = dydt;

% Other SFLOR Data
pars_sflor.N = 1398572 + 3679331 + 1090711;
pars_sflor.agestruc = [1398572, 3679331, 1090711]/pars_sflor.N;

pars_sflor.t0 = datetime(2020,02,27); % Since the data is weekly, I'm back-inferring the start date.
pars_sflor.tf = datetime(2020,07,01);
pars_sflor.nDays = days(pars_sflor.tf - pars_sflor.t0)+1;
pars_sflor.nWeeks = round(days(pars_sflor.tf - pars_sflor.t0)/7); % 18 data points, 17 weeks. 24 because we include t0.
pars_sflor.times = 1:pars_sflor.nDays;

pars_sflor.date_dist_start = datetime(2020,03,17);
pars_sflor.date_dist_end = datetime(2020,05,20);

pars_sflor.daily_tests = 0;
pars_sflor.tStart_distancing = 1+days(pars_sflor.date_dist_start - pars_sflor.t0);
pars_sflor.tStart_test = 500;
pars_sflor.tStart_target = 1+days(pars_sflor.date_dist_start - pars_sflor.t0);
pars_sflor.tStart_school = 500;
pars_sflor.tStart_reopen = 1+days(pars_sflor.date_dist_end - pars_sflor.t0);

% initial conditions - patient 0
pars_sflor.Isym_c0=0;
pars_sflor.Isym_a0=1;
pars_sflor.Isym_rc0=0;
pars_sflor.Isym_fc0=0;
pars_sflor.Isym_e0=0;

% we assume that a single reported symptomatic case implies a number of asymptomatic cases.
pars_sflor.Iasym_c0=0;
pars_sflor.Iasym_a0=10;
pars_sflor.Iasym_rc0=0;
pars_sflor.Iasym_fc0=0;
pars_sflor.Iasym_e0=0;