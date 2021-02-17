input_defaults % Load pars_default

%% Set to default
pars_nyc = pars_default;
pars_nyc.loc = "New York City";

%% Read NY Data
ny_data = csvread('nyc.csv',1,2); % don't read text columns
temp_y = [0;0;ny_data]; % 3 is deaths, 2 is cases
l_temp = length(temp_y);
dydt = temp_y(2:l_temp) - temp_y(1:(l_temp-1));

% Set the target as the rate of new deaths.
pars_nyc.target = dydt;
pars_nyc.cumulative = temp_y;

% Other NY Data
pars_nyc.N = 2208909 + 5944919 + 1283369;
pars_nyc.agestruc = [2208909, 5944919, 1283369]/pars_nyc.N;

pars_nyc.t0 = datetime(2020,02,20); % Since the data is weekly, I'm back-inferring the start date.
pars_nyc.tf = datetime(2020,07,01);
pars_nyc.nDays = days(pars_nyc.tf - pars_nyc.t0)+1;
pars_nyc.nWeeks = round(days(pars_nyc.tf - pars_nyc.t0)/7); % including t0.
pars_nyc.times = 1:pars_nyc.nDays;

pars_nyc.date_dist_start = datetime(2020,03,16);
pars_nyc.date_dist_end = datetime(2020,06,08);

pars_nyc.daily_tests = 0;
pars_nyc.tStart_distancing = 1+days(pars_nyc.date_dist_start - pars_nyc.t0);
pars_nyc.tStart_test = 500;
pars_nyc.tStart_target = 500; % 2020.10.02 - TARGET was originally for sd lift + testing. 
pars_nyc.tStart_school = 500;
pars_nyc.tStart_reopen = 1+days(pars_nyc.date_dist_end - pars_nyc.t0); % REOPEN means SAH orders are lifted.

% Back-calculate initial conditions from X0_target
pars_nyc.X0_target = round(Calc_Init_Conds(pars_nyc));

% Seroprevalence
temp_seroData = pars_nyc.Sero_table(find(~cellfun('isempty',strfind(pars_nyc.Sero_table.location,'nyc'))),[3:7]);

pars_nyc.sero = temp_seroData.x_Reac;
pars_nyc.sero_min = temp_seroData.x95CI_low;
pars_nyc.sero_max = temp_seroData.x95CI_high;
pars_nyc.sero_date = temp_seroData.sero_end;

pars_nyc.tSero = days(pars_nyc.sero_date-pars_nyc.t0);
