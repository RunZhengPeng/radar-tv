% This simple demo examines if TVAL3 works normally. Please try more demos
% in the "Demos" directory, which would show users what TVAL3 is capable of.
% 
% I: 64x64 phantom (real, two-dimentional)
% A: random matrix without normality and orthogonality (real)
% f: observation with/without noise (real)
%
% Written by: Chengbo Li
% Advisor: Prof. Yin Zhang and Wotao Yin
% CAAM department, Rice University
% 05/21/2009

clear; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');
%radon I


% load('CTomog1.mat');
% s=zeros(192,192,192);
% for i=1:1:96
% s(:,i,:)=CTomog(:,i,:);
% end
% load('CTomog2.mat');
% for i=1:1:96
% s(:,i+96,:)=CTomog(:,i,:);
% end
I=phantom(128);
% I=squeeze(s(:,:,100));

n = 128;
ratio = .3;
p = n; q = n; % p x q is the size of image
m = round(ratio*n^2);



% %% 采样
syms t a1 a2;   %定义函数变量，t为积分变量
 fun=exp(-t^2/2)/sqrt(2*pi);         %标准正态分布原函数
 C=zeros(1,72);
 i=0;
 k=1;
 sum_sample=0;
for a=-3:0.6:2.4
     a1=a;%%上下积分边界
     a2=a+0.6;
 Y=round(double(36*int(fun,t,a1,a2)));%%10组36个 每组分别该随机取多少数据
  if Y>=1
  S=randperm(36);
  
  for s=1:1:Y
      sum_sample=sum_sample+1;
      C(1,k)=S(1,s)+36*i;
  k=k+1;
  end
%  d=sort(C);
  
% for s=1:1:Y
%     b(k,1)=B(d(s)+i*32,1);
%     %%Wave(k,1)=(d(s)+i*32)*0.0674+849.72-1180*0.0674; 需做变化
%     Z(k,d(s)+i*32)=1;
%     k=k+1;
% end
  end
  i=i+1;
% 
end
C=sort(C);
% sensing matrix
theta=1:5:176;
[ A R ] = radon_tomo(I, C);
n_theta=length(C); 
% original image

nrmI = norm(I,'fro');
figure('Name','TVAL3','Position',...
    [fullscreen(1) fullscreen(2) fullscreen(3) fullscreen(4)]);
subplot(131); imshow(I,[]);
title('Original phantom','fontsize',18); drawnow;

% observation
f = A*I(:);
% f=R1(:);
favg = mean(abs(f));

% add noise
%  f = f + .00*favg*randn(32399,1);


%% Run TVAL3
clear opts
opts.mu = 2^8;
opts.beta = 2^5;
opts.tol = 1E-3;
opts.maxit = 300;
opts.TVnorm = 2;
opts.nonneg = true;


R1 = radon(I,theta); 
t = cputime;
I1 = iradon(R1,theta);
t = cputime - t;
subplot(132);
imshow(I1,[]);
% P=phantom(130);
% nrmI1 = norm(P,'fro');
title('Recovered by Iradon','fontsize',18);


t = cputime;
[U, out] = TVAL3(A,f,p,q,opts);
t = cputime - t;


subplot(133); 
imshow(U,[]);
title('Recovered by CS','fontsize',18);
xlabel(sprintf(' number of angles=%2d  \n Rel-Err: %4.2f%%, CPU: %4.2fs ',n_theta,norm(U-I,'fro')/nrmI*100,t),'fontsize',16);
