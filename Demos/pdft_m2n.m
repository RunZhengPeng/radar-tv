function x = pdft_m2n(y,picks,perm)

% Calculate x = A'*y,
% where A is m x n, and consists of m rows of the 
% n by n inverse discrete-Fourier transform (IFFT) 
% matrix. The row indices are stored in picks.

n = length(perm); 
tx = zeros(n,1);
tx(picks) = y;
x = zeros(n,1);
x(perm) = ifft(tx)*sqrt(n);