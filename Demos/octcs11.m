% x: sparse vector (complex, one-dimentional)
% A: permuted discrete Fourier transform (complex)
% f: observation with/without noise (complex)
%
%
% Written by: Chengbo Li
% Advisor: Prof. Yin Zhang and Wotao Yin
% CAAM department, Rice University



clear all; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');

%% problem size
n = 2048;
m = floor(.25*n); k = floor(.01*m);%朝负无穷方向舍
fprintf('\nSize [n,m,k] = [%i,%i,%i]\n',n,m,k);

%% input signal and sensing matrix
res_l = 0.0674;           % nm 光谱仪的分辨率
cwavelength = 837.83;      % nm 中心波长
pwavelength = 849.72;  
idx = 1181;     
iCount = 2048;
res  = res_l/(cwavelength^2);  % 1/nm
wavelength = pwavelength-(idx-1)*res_l:res_l:pwavelength+(iCount-idx)*res_l;     % 已知点的坐标
wavenumber = 1./wavelength;
x_wavenumber = wavenumber(1):-res:wavenumber(1)-2047*res;      
xno= 150;  
result=ones(2048,1);
[FileName,PathName] = uigetfile('*.spe','select the single A-scan spectral signal');%读取文件数据
fid=fopen(strcat(PathName,FileName));
head=fread(fid,[160,1],'char');
rawdata = fread(fid,[2048,xno],'int16');
rawdata = rawdata - mean(rawdata,2)*ones(1,xno); 
data = interp1(wavenumber,rawdata,x_wavenumber,'linear','extrap'); 

y=data(:,60);



%% generate partial DFT data
p = randperm(n);
picks = sort(p(1:m)); picks(1) = 1;%B=sort(A) 对一维或二维数组进行升序排序,并返回排序后的数组,当A为二维时,对数组每一列进行排序
perm = randperm(n); % column permutations allowable [RANDPERM(n) is a random permutation of the integers from 1 to n.]
A = @(x,mode) dfA(x,picks,perm,mode);
b=y(picks);


%% set solver options
opts.maxit = 600;
opts.mu = 2^4;
opts.beta = 2^6;
opts.tol = 1E-4;
opts.TVnorm = 1;
opts.TVL2 = true;


[x,out] = TVAL3(A, b, n, 1, opts);




