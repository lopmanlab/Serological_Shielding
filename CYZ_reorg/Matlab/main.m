input_defaults;

opts=odeset();
%[t,y]=ode45(@SEIR_model_shields, [0:1:365], X0, opts, pars_default);

t_final = 365;
D_res = zeros(11, t_final+1);
cs = 0:0.01:1;

for i = 1:length(cs)
    pars_sweep = pars_default;
    pars_sweep.q = i;
    [t,y]=ode45(@SEIR_model_shields, [0:1:t_final], X0, opts, pars_sweep);
    
    D_res(i,:) = sum(y(:,pars_sweep.D_ids),2)';
end


