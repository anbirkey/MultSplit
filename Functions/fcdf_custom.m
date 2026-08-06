
function p = fcdf_custom(x, df1, df2)
% FCDF_CUSTOM F cumulative distribution function (CDF)
%   P = FCDF_CUSTOM(X, DF1, DF2) returns the CDF of the F-distribution
%   with DF1 and DF2 degrees of freedom, evaluated at the values in X.
%
%   Inputs:
%       X   - Values at which to evaluate the CDF
%       DF1 - Numerator degrees of freedom
%       DF2 - Denominator degrees of freedom
%
%   Output:
%       P   - Probability values (CDF)

    % Input validation
    if df1 <= 0 || df2 <= 0
        error('Degrees of freedom must be positive');
    end
    
    % Initialize output
    p = zeros(size(x));
    
    % Handle different cases
    for i = 1:numel(x)
        if x(i) <= 0
            p(i) = 0;
        elseif isinf(x(i))
            p(i) = 1;
        else
            % F-distribution CDF using incomplete beta function
            % F(x; df1, df2) = betainc((df1*x)/(df1*x + df2), df1/2, df2/2)
            z = (df1 * x(i)) / (df1 * x(i) + df2);
            p(i) = betainc(z, df1/2, df2/2);
        end
    end
end