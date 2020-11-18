function Mat_X = Vec_to_Mat(X, subgroups, compartments)
%VEC_TO_MAT Summary of this function goes here
%   Detailed explanation goes here
Mat_X = reshape(X, [subgroups, compartments]);
end

