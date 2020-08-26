clear
% Reproduces S1: Find # of critical care beds over a span of 365 days

% Set Defaults
input_defaults

% Modify Defaults
pars_default.tStart_test = 500;

% Values
reopen_dates = [1; 121; 182; 244; 500]

% Run Calculation
figure()
hold on
for i_reopen = 1:length(reopen_dates)
    % Change Var
    pars_in = pars_default;
    pars_in.tStart_reopen = reopen_dates(i_reopen);
    
    % ODE options
    opts = odeset(); % options
    X0 = Get_Inits(pars_in); % parameters
    [t,Y]=ode45(@SEIR_model_shields_full, pars_in.times, X0, opts, pars_in); % model calc
    
    % Calculate HCris
    out = sum(Y(:,pars_in.Hcri_ids), 2)
    
    % Plot
    plot(pars_in.times, out)
end
