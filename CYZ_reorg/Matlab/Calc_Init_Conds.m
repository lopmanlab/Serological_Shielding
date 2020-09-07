function X0_best = Calc_Init_Conds(Pars)

temp_target = Pars.target(1:find(Pars.target~=0,1,"last"));
t_adv = 7*find(temp_target>10, 1); % Check the target vector for # of 0's.
Deaths = sum(temp_target(1:find(temp_target>10, 1))); % Target nDeaths. Note: even though target is a rate, the first # works.

% Initial conditions
Pars.E_a0 = 1;

% Px 0
Pars.Isym_c0 = 0;
Pars.Isym_a0 = 0;
Pars.Isym_rc0 = 0;
Pars.Isym_fc0 = 0;
Pars.Isym_e0 = 0;

Pars.Iasym_c0 = 0;
Pars.Iasym_a0 = 0;
Pars.Iasym_rc0 = 0;
Pars.Iasym_fc0 = 0;
Pars.Iasym_e0 = 0;

% Get Init X0
opts = odeset(); % options
X0 = Get_Inits(Pars);

% Run the sim
times = 1:1000;
[t,Y]=ode45(@SEIR_model_shields_full, times, X0, opts, Pars); % model calc

% Find when ret>0
ret = sum(Y(:, Pars.D_ids),2);
i_ret = find(ret>Deaths, 1) - t_adv; 

X0_best = reshape(Y(i_ret, :), 1, []);
end

