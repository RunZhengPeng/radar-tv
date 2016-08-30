function A = pdft_operator(picks,perm)

% Define A*x and A'*y for a partial DFT matrix A
% Input:
%            n = interger > 0
%        picks = sub-vector(всоРа©) of a permutation of 1:n
% Output:
%        A = struct of 2 fields
%            1) A.times: A*x
%            2) A.trans: A'*y
A.times = @(x) pdft_n2m(x,picks,perm);
A.trans = @(y) pdft_m2n(y,picks,perm);