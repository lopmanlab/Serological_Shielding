function X0 = Get_Inits(Pars)
%GET_INITS Gets Initial Conditions
X0 = zeros(1,Pars.nTotSubComp);

% Remove from susceptible pool ...
X0(Pars.varNames=="S_c") = Pars.agestruc(1)*Pars.N-Pars.Isym_c0-Pars.Iasym_c0;
X0(Pars.varNames=="S_a") = Pars.agestruc(2)*Pars.frac_home*Pars.N-Pars.Isym_a0-Pars.Iasym_a0;
X0(Pars.varNames=="S_rc") = Pars.agestruc(2)*Pars.frac_reduced*Pars.N-Pars.Isym_rc0-Pars.Iasym_rc0;
X0(Pars.varNames=="S_fc") = Pars.agestruc(2)*Pars.frac_full*Pars.N-Pars.Isym_fc0-Pars.Iasym_fc0;
X0(Pars.varNames=="S_e") = Pars.agestruc(3)*Pars.N-Pars.Isym_e0-Pars.Iasym_e0;

% ... and add to symptomatic infected
X0(Pars.varNames=="Isym_c") = Pars.Isym_c0;
X0(Pars.varNames=="Isym_a") = Pars.Isym_a0;
X0(Pars.varNames=="Isym_rc") = Pars.Isym_rc0;
X0(Pars.varNames=="Isym_fc") = Pars.Isym_fc0;
X0(Pars.varNames=="Isym_e") = Pars.Isym_e0;

% ... or add to aymptomatci infected
X0(Pars.varNames=="Iasym_c") = Pars.Iasym_c0;
X0(Pars.varNames=="Iasym_a") = Pars.Iasym_a0;
X0(Pars.varNames=="Iasym_rc") = Pars.Iasym_rc0;
X0(Pars.varNames=="Iasym_fc") = Pars.Iasym_fc0;
X0(Pars.varNames=="Iasym_e") = Pars.Iasym_e0;

end

