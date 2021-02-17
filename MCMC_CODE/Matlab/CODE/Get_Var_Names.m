function VarNames = Get_Var_Names(v_Compartments,v_Subgroups)
%GET_VAR_NAMES Creates variable names
%   Gets all combinations for variable names.
[A,B] = meshgrid(v_Compartments,v_Subgroups);
VarNames = A+'_'+B;
VarNames = reshape(VarNames, 1, []);
end

