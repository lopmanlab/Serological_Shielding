clear

% Set Defaults
input_defaults

% Modify Defaults
pars_default.tStart_test = 500;

% Values
reopen_dates = [1; 121; 182; 244; 500];
cvals = 0:0.1:1;
pred_vals = 0:0.1:1;

% Run Calculation
figure()
hold on

res = zeros(length(cvals), length(pred_vals));
for i_cval = 1:length(cvals)
    for j_pred_val = 1:length(pred_vals)
        % Change Var
        pars_in = pars_default;
        pars_in.c = cvals(i_cval);
        pars_in.p_reduced = pred_vals(j_pred_val);
        pars_in.socialDistancing_other = pred_vals(j_pred_val);

        % ODE options
        opts = odeset(); % options
        X0 = Get_Inits(pars_in); % parameters
        [t,Y]=ode45(@SEIR_model_shields_full, pars_in.times, X0, opts, pars_in); % model calc

        % Calculate HCris
        out = sum(Y(:,pars_in.D_ids), 2);

        res(i_cval,j_pred_val) = out(length(out));
        
        % Plot
        plot(pars_in.times, out)
    end
end