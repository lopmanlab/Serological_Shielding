% Reproduces S1: Find # of critical care beds over a span of 365 days

% Values
cvals = 0:0.1:1;

% Run Calculation
figure()
hold on
for i_c = 1:length(cvals)

    % Change Var
    pars_in = pars_nyc;
    pars_in.c = cvals(i_c);
    
    % ODE options
    opts = odeset(); % options
    X0 = Get_Inits(pars_in); % parameters
    [t,Y]=ode45(@SEIR_model_shields_full, pars_in.times, X0, opts, pars_in); % model calc
    
    % Calculate HCris
    out = sum(Y(:,pars_in.D_ids), 2);
    
    % Plot
    plot(pars_in.times, out)
end
