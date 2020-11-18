function CM_5x5 = Expand_5x5(contactMatrix, p_Home, p_Reduced, p_Full)
%EXPAND_5X5 Expands
% This function expands the 3x3 contact matrices into 5x5 ones by separating
% adult contacts based on home, reduced, or full contact probabilities.
temp_rowexpand = contactMatrix([1,2,2,2,3],:);
temp_expand = temp_rowexpand(:,[1,2,2,2,3]);
temp_expand(:,[2,3,4]) = temp_expand(:,[2,3,4]).*[p_Home, p_Reduced, p_Full]; % element-wise oddly.

CM_5x5 = temp_expand;
end

