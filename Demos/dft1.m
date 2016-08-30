% x: sparse vector (complex, one-dimentional)
% A: permuted discrete Fourier transform (complex)
% f: observation with/without noise (complex)
%
%
% Written by: Chengbo Li
% Advisor: Prof. Yin Zhang and Wotao Yin
% CAAM department, Rice University
% 05/21/2009

clear all; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');

% problem size
n = 2^14;
m = floor(.25*n); k = floor(.01*m);%朝负无穷方向舍
fprintf('\nSize [n,m,k] = [%i,%i,%i]\n',n,m,k);

% generate random xs
% xs = zeros(n,1);
% p = randperm(n); p = sort(p(1:k-1)); p = [1 p n];
% xs(p(1:k)) = randn(k,1) + randn(k,1)*1i;
    
% generate staircase xs
z = zeros(n-1,1);
p = randperm(n-1);
z(p(1:k)) = randn(k,1) + 1i*randn(k,1);
xs = cumsum([randn; z]);



% generate partial DFT data
p = randperm(n);
picks = sort(p(1:m)); picks(1) = 1;%B=sort(A) 对一维或二维数组进行升序排序,并返回排序后的数组,当A为二维时,对数组每一列进行排序
perm = randperm(n); % column permutations allowable [RANDPERM(n) is a random permutation of the integers from 1 to n.]
A = @(x,mode) dfA(x,picks,perm,mode);
b = A(xs,1); 
bavg = mean(abs(b)); 

% add noise
sigma = 0.05;  % noise std
noise = randn(m,1) + 1i*randn(m,1);
b = b + sigma*bavg*noise;

% set solver options
opts.maxit = 600;
opts.mu = 2^4;
opts.beta = 2^6;
opts.tol = 1E-4;
opts.TVnorm = 1;
opts.TVL2 = true;

t = cputime;
[x,out] = TVAL3(A, b, n, 1, opts);
t = cputime - t;

rerr = norm(x-xs)/norm(xs);


figure('Name','TVAL3','Position',...
    [fullscreen(1) fullscreen(2) fullscreen(3) fullscreen(4)]);
subplot(211); set(gca,'fontsize',16)
plot(1:n,real(xs),'r.-',1:n,real(x),'b-');
title(sprintf('Real Part         Noise: %2.1f%%,   Rel-Err: %4.2f%%,   CPU: %4.2fs',sigma*100,rerr*100,t))
subplot(212); set(gca,'fontsize',16)
plot(1:n,imag(xs),'r.-',1:n,imag(x),'b-');
title('Image Part                                                                             ')
