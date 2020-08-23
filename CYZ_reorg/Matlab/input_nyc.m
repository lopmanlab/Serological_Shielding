input_defaults

%% Set to default
pars_nyc = pars_default;

%% Read NY Data
ny_data = csvread('nyc.csv',1,2); % don't read text columns
temp_y = [0;ny_data]; % 3 is deaths, 2 is cases
l_temp = length(temp_y);
dydt = temp_y(2:l_temp) - temp_y(1:(l_temp-1));

% Set the target as the rate of new deaths.
pars_nyc.target = dydt;

% Other NY Data
pars_nyc.N = 2208909 + 5944919 + 1283369;
pars_nyc.agestruc = [2208909, 5944919, 1283369]/pars_nyc.N;

pars_nyc.t0 = datetime(2020,02,27); % Since the data is weekly, I'm back-inferring the start date.
pars_nyc.tf = datetime(2020,07,01);
pars_nyc.nDays = 18*7;
pars_nyc.nWeeks = 18; % 18 data points, 17 weeks. 24 because we include t0.
pars_nyc.times = 1:pars_nyc.nDays;

pars_nyc.date_dist_start = datetime(2020,03,16);
pars_nyc.date_dist_end = datetime(2020,06,08);

pars_nyc.daily_tests = 0;
pars_nyc.tStart_distancing = 1+days(pars_nyc.date_dist_start - pars_nyc.t0);
pars_nyc.tStart_test = 500;
pars_nyc.tStart_target = 500;
pars_nyc.tStart_school = 500;
pars_nyc.tStart_reopen = 1+days(pars_nyc.date_dist_end - pars_nyc.t0);

% initial conditions - patient 0
pars_nyc.Isym_c0=0;
pars_nyc.Isym_a0=1;
pars_nyc.Isym_rc0=0;
pars_nyc.Isym_fc0=0;
pars_nyc.Isym_e0=0;

% we assume that a single reported symptomatic case implies a number of asymptomatic cases.
pars_nyc.Iasym_c0=0;
pars_nyc.Iasym_a0=10;
pars_nyc.Iasym_rc0=0;
pars_nyc.Iasym_fc0=0;
pars_nyc.Iasym_e0=0;