function dYdt = SEIR_model_shields_full(t, X, Pars)
% Core transmission model
%   - Subscripts are defined as follows: c=children, a=non-essential adults, 
%     rc=reduced contact adults, fc=full contact adults, e=elderly
%   - For infection equations: The I compartments correspond to infectious 
%     periods, not periods in which people are symptomatic
%   - Is are cases that are severe enough to be documented eventually and Ia are undocumented cases
%   - Since we are not fitting to data we do not need to model specifically when the cases are documented 
%   - _pos indicates people who have tested positive for COVID-19 by antibody test

    %test.switch1<-sw1fxn(t)
    %test.switch2<-sw2fxn(t)

%% (0) Setup ---------------------------------------------------------------

dYdt=zeros(length(X),1);

% Update Pars
Pars.socialDistancing_other_c = 1-(0.75*Pars.c);
Pars.p_reduced_c = 1-(0.9*Pars.c);

% Load in Matrix Form
mat_X = Vec_to_Mat(X, Pars.nSubgroups, Pars.nCompartments);

% Number of infections at time t for each subgroup
infec = (Pars.asymp_red*mat_X(Pars.Iasym_ids) + mat_X(Pars.Isym_ids))';

% Population sizes/testing status at time t    
tot = sum(mat_X,2) - mat_X(Pars.D_ids)';

%Fraction of population in each group who has tested positive by time
frac_released = [0,0,0,0,0];
frac_distanced = [1,1,1,1,1];
frac_comb = [0,1,0,1,0,1,0,1,0,1]; % interleaved

%% (1) Derive Contact Matrices ---------------------------------------------

% Broad distancing matrix
%   - Children have no work contacts
%   - Non-essential workers don't work
%   - Reduced contact workers reduce contacts by p_reduced and those contacts are 
%     proportional to prevalence in the population
WorkContacts_5x5_Distancing = zeros(5,5);
WorkContacts_5x5_Distancing(3,:) = Pars.WorkContacts_5x5(3,:)*Pars.p_reduced;
WorkContacts_5x5_Distancing(4,:) = Pars.WorkContacts_5x5(4,:)*Pars.p_full;

% Targeted distancing work
%   - DISTANCING CONDITIONAL ON TESTING: People working from home regain their 
%     workplace contacts if they test positive 
%   - People in reduced and full contact occupations have the distribution of 
%     their workplace contacts changed by alpha
%   - We use fixed shielding (except we multiply by alpha and not alpha +1), 
%     so we correct for the situation where alpha times prevalence is greater than 1
Scale = frac_released*Pars.alpha;
Scale(Scale>1)=1;

WorkContacts_5x5_TargetedDistancing = zeros(5,5);
DistancedWork_RedContact = Pars.WorkContacts_5x5(3,:)*Pars.p_reduced_c;
WorkContacts_5x5_TargetedDistancing(3,:) = DistancedWork_RedContact;
WorkContacts_5x5_TargetedDistancing(4,:) = DistancedWork_RedContact/Pars.p_reduced_c;

% Other contacts
%   - BASELINE OTHER CONTACTS MATRIX: People mix freely, contacts are based 
%     on proportion in the population
%OtherContacts_5x5_TargetedDistancing_c
OtherContacts_5x5_TargetedDistancing_c=Pars.OtherContacts_Distancing_5x5;


%Change matrices used over timemat_X
if (t<Pars.tStart_distancing) || (t>=Pars.tStart_reopen) %Use baseline matrices until social distancing starts
    CM = Pars.HomeContacts_5x5 + Pars.SchoolContacts_5x5 + Pars.WorkContacts_5x5 + Pars.OtherContacts_5x5;
elseif (t>=Pars.tStart_distancing) && (t<Pars.tStart_reopen) %Use these matrices under general social distancing without testing
    CM = Pars.HomeContacts_5x5 + Pars.WorkContacts_Distancing_5x5 + Pars.OtherContacts_Distancing_5x5;
elseif (t>=Pars.tStart_target) && (t<Pars.tStart_school)
    CM = Pars.HomeContacts_5x5 + ...
        WorkContacts_5x5_TargetedDistancing + ...
        OtherContacts_5x5_TargetedDistancing_c;
elseif (t>=Pars.tStart_school)
    CM = Pars.HomeContacts_5x5 + ...
        WorkContacts_5x5_TargetedDistancing + ...
        OtherContacts_5x5_TargetedDistancing_c + ...
        Pars.SchoolContacts_5x5;
end


%% (3) Calculate v_fois ------------------------------------------------------

% Force of infection by group 
temp_I = CM.*(infec./tot)'*Pars.q;
v_fois = sum(temp_I,2); %ORDER: ["foi_c_gen","foi_a_gen", "foi_rc_gen", "foi_fc_gen", "foi_e_gen"]


%% (4) Sero Testing --------------------------------------------------------

% NONE for reduced version


%% (5) Model Equations -----------------------------------------------------
dYdt(Pars.S_ids) = -v_fois.*mat_X(Pars.S_ids)';

dYdt(Pars.E_ids)  = v_fois.*mat_X(Pars.S_ids)' - ...
Pars.gamma_e*mat_X(Pars.E_ids)';

dYdt(Pars.Isym_ids)  = Pars.p_symptomatic*Pars.gamma_e*mat_X(Pars.E_ids)' - ...
Pars.gamma_s*mat_X(Pars.Isym_ids)';

dYdt(Pars.Iasym_ids)  = (1-Pars.p_symptomatic)*Pars.gamma_e*mat_X(Pars.E_ids)' - ...
Pars.gamma_a*mat_X(Pars.Iasym_ids)';

dYdt(Pars.Hsub_ids)  = Pars.gamma_s*(Pars.hosp_frac_5-Pars.hosp_crit_5)'.*mat_X(Pars.Isym_ids)' - ...
Pars.gamma_hs*mat_X(Pars.Hsub_ids)';

dYdt(Pars.Hcri_ids)  = Pars.gamma_s*Pars.hosp_crit_5'.*mat_X(Pars.Isym_ids)' - ...
Pars.gamma_hc*mat_X(Pars.Hcri_ids)';

dYdt(Pars.D_ids)  = Pars.gamma_hc*Pars.crit_die_5'.*mat_X(Pars.Hcri_ids)';

dYdt(Pars.R_ids)  = Pars.gamma_s*(1-Pars.hosp_frac_5)'.*mat_X(Pars.Isym_ids)' + ...
Pars.gamma_a*mat_X(Pars.Iasym_ids)' + ...
Pars.gamma_hc*(1-Pars.crit_die_5)'.*mat_X(Pars.Hcri_ids)' + ...
Pars.gamma_hs*mat_X(Pars.Hsub_ids)';


end

