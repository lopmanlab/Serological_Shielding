function res = logpoispdf(X, Lambda)
res = X.*log(Lambda) - gammaln(X) - Lambda;
end
