input_defaults

%% Set to default
pars_wash = pars_default;

%% Read WASH Data
wash_data = csvread('wash.csv',1,2); % don't read text columns
temp_y = [0;wash_data]; % 3 is deaths, 2 is cases
l_temp = length(temp_y);
dydt = temp_y(2:l_temp) - temp_y(1:(l_temp-1));

% Set the target as the rate of new deaths.
pars_wash.target = dydt;

% Other WASH Data
pars_wash.N = 974924 + 2563244 + 526665;
pars_wash.agestruc = [974924, 2563244, 526665]/pars_wash.N;

pars_wash.t0 = datetime(2020,02,13); % Since the data is weekly, I'm back-inferring the start date.
pars_wash.tf = datetime(2020,07,01);
pars_wash.nDays = days(pars_wash.tf - pars_wash.t0)+1;
pars_wash.nWeeks = round(days(pars_wash.tf - pars_wash.t0)/7); % 18 data points, 17 weeks. 24 because we include t0.
pars_wash.times = 1:pars_wash.nDays;

pars_wash.date_dist_start = datetime(2020,03,16);
pars_wash.date_dist_end = datetime(2020,05,31);

pars_wash.daily_tests = 0;
pars_wash.tStart_distancing = 1+days(pars_wash.date_dist_start - pars_wash.t0);
pars_wash.tStart_test = 500;
pars_wash.tStart_target = 1+days(pars_wash.date_dist_start - pars_wash.t0);
pars_wash.tStart_school = 500;
pars_wash.tStart_reopen = 1+days(pars_wash.date_dist_end - pars_wash.t0);

% Back-calculate initial conditions from X0_target
pars_wash.X0_target = round(Calc_Init_Conds(pars_wash));

% Seroprevalence
temp_seroData = pars_wash.Sero_table(find(~cellfun('isempty',strfind(pars_wash.Sero_table.location,'wash'))),[3:7]);

pars_wash.sero = temp_seroData.x_Reac;
pars_wash.sero_min = temp_seroData.x95CI_low;
pars_wash.sero_max = temp_seroData.x95CI_high;
pars_wash.sero_date = temp_seroData.sero_end;

pars_wash.tSero = days(pars_wash.sero_date-pars_wash.t0);