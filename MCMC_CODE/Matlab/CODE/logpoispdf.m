function res = logpoispdf(X, Lambda)
res = X.*log(Lambda) - gammaln(X+1) - Lambda;
end
