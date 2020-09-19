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

% Back-calculate initial conditions from X0_target
pars_sflor.X0_target = round(Calc_Init_Conds(pars_sflor));

% Seroprevalence
temp_seroData = pars_sflor.Sero_table(find(~cellfun('isempty',strfind(pars_sflor.Sero_table.location,'sflor'))),[3:7]);

pars_sflor.sero = temp_seroData.x_Reac;
pars_sflor.sero_min = temp_seroData.x95CI_low;
pars_sflor.sero_max = temp_seroData.x95CI_high;
pars_sflor.sero_date = temp_seroData.sero_end;

pars_sflor.tSero = days(pars_sflor.sero_date-pars_sflor.t0);