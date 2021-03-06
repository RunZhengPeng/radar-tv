clear; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');

load('csgf');
csgf = ones(64,64) ./ csgf;
load('csgc');
csgc = ones(64,64) ./ csgc;

load('cardiac_sequence_64');
ytu=cardiac_phantom_64(:,:,6);
I=flipud(imrotate(ytu,90));

load('sino_brain');


% load('SystemMatrix');
load('SystemMatrix6.2.mat');
load('sinogram_phantom_10');
uniforms = sinogram_phantom_10;

load('sino_cardiac_dynamic');
YYY=sino_cardiac_dynamic(:,:,6);


G1 = systemmatrix;

load('sino_cardiac_dynamic');
% n = 128;
% ratio = .3;
p = 64; q = 64; % p x q is the size of image
%m = round(ratio*n^2);

N=64;
x_dim=N;
y_dim=N;
b_size=x_dim;
a_size=y_dim;
fov_size=N;
ig=image_geom('nx',x_dim,'ny',y_dim,'fov',fov_size);
sg = sino_geom('par', 'nb', b_size, 'na', a_size);
G = Glinear(ig.nx,ig.ny,sg.nb,sg.na);

YYY = YYY/max(max(YYY));
YI=reshape(I,4096,1);

YYF=G * YI;
 YYF=reshape(YYF,64,64)/max(max(YYF));

ytu=reshape(ytu,4096,1);

YYC=G1 * ytu;
YYC=reshape(YYC,64,64)/max(max(YYC));


res1=mean(mean(YYF-YYY))/mean(mean(YYY));
res2=mean(mean(YYC-YYY))/mean(mean(YYY));




nrmI = norm(I,'fro');
%nrmI = norm(I/max(max(I)),'fro');
figure('Name','TVAL3','Position',...
    [fullscreen(1) fullscreen(2) fullscreen(3) fullscreen(4)]);

subplot(231); 
imshow(YYY,[]);
colormap('jet');
title('MC','fontsize',18); 


subplot(232); 
imshow(YYF,[]);
colormap('jet');
title('by FESSLER','fontsize',18); 
xlabel(sprintf(' Mean-Err: %4.4f%%',res1*100),'fontsize',16);

subplot(233); 
imshow(YYC,[]);
colormap('jet');
title('by CHENZHI','fontsize',18); 
xlabel(sprintf('Mean-Err: %4.4f%%',res2*100),'fontsize',16);




subplot(234); 
imshow(I,[]);
colormap('jet');
title('TRUTH','fontsize',18); 





%% Run TVAL3
clear opts
opts.mu = 2^4;
opts.beta = 2^1;
opts.tol = 1E-3;
opts.maxit = 300;
opts.TVnorm = 2;
opts.nonneg = true;

% f=YY;
f=sino_cardiac_dynamic(:,:,6);



f=reshape(f,4096,1);
t = cputime;
[U, out] = TVAL3(G,f,p,q,opts);
t = cputime - t;
U1 = U/max(max(U));
I = I/max(max(I));

res3=mean(mean(U1-I))/mean(mean(I));
% U=flipud(imrotate(U,90));

subplot(235); 
imshow(U1,[]);
colormap('jet');
title('Recovered by CS with GF','fontsize',18);
xlabel(sprintf('Mean-Err: %4.4f%%, CPU: %4.2fs ',res3*100 , t),'fontsize',16);
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
% xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',res3,'fro')/nrmI*100,t),'fontsize',16);
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);


%% Run TVAL3
clear opts
opts.mu = 2^4;
opts.beta = 2^1;
opts.tol = 1E-3;
opts.maxit = 300;
opts.TVnorm = 2;
opts.nonneg = true;

% f=YY;
% f=sino_cardiac_dynamic(:,:,6);
f=sino_brain;
% f = uniforms;

% f=flipud(imrotate(f,90));

f=reshape(f,4096,1);
t = cputime;
[U, out] = TVAL3(G1,f,p,q,opts);
t = cputime - t;

U=flipud(imrotate(U,90));
U2 = U/max(max(U));
U2 = U;

res4=mean(mean(U2-I))/mean(mean(I));
subplot(236); 
imshow(U2,[]);
colormap('jet');
title('Recovered by CS with GC','fontsize',18);
xlabel(sprintf('Mean-Err: %4.4f%%, CPU: %4.2fs ',res4*100, t),'fontsize',16);
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
% xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U-I,'fro')/nrmI*100,t),'fontsize',16);
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);




figure('Name','TVAL3','Position',...
    [fullscreen(1) fullscreen(2) fullscreen(3) fullscreen(4)]);

subplot(231); 
imshow(I,[]);
colormap('jet');
title('truth','fontsize',18);

subplot(232); 
imshow(U1,[]);
colormap('jet');
title('Recovered by CS with GF','fontsize',18);
% xlabel(sprintf('Mean-Err: %4.4f%%',res4*100),'fontsize',16);


U1 = U1 .* csgf;

subplot(235); 
imshow(U1,[]);
colormap('jet');
title('Recovered by CS with GF','fontsize',18);
% xlabel(sprintf('Mean-Err: %4.4f%%',res4*100),'fontsize',16);


subplot(233); 
imshow(U2,[]);
colormap('jet');
title('Recovered by CS with GC','fontsize',18);
% xlabel(sprintf('Mean-Err: %4.4f%%',res4*100),'fontsize',16);

U2 = U2 .* csgc;

subplot(236); 
imshow(U2,[]);
colormap('jet');
title('Recovered by CS with GC','fontsize',18);
% xlabel(sprintf('Mean-Err: %4.4f%%',res4*100),'fontsize',16);

% t = cputime;
% x=my_mlem128(YY,10);
% t = cputime - t;
% subplot(132); 
% imshow(x,[]);
% colormap('jet');
% title('Recovered by EM','fontsize',18); drawnow;
% %xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x/max(max(x))-I/max(max(I))/nrmI*100,t),'fontsize',16);
% xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x-I,'fro')/nrmI*100,t),'fontsize',16);
% %xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x/max(max(x))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
% %% Run TVAL3
% clear opts
% opts.mu = 2^4;
% opts.beta = 2^3;
% opts.tol = 1E-3;
% opts.maxit = 300;
% opts.TVnorm = 2;
% opts.nonneg = true;
% 
% % f=YY;
% f=sino_cardiac_dynamic(:,:,6);
% f=reshape(f,4096,1);
% t = cputime;
% [U, out] = TVAL3(G1,f,p,q,opts);
% t = cputime - t;
% 
% 
% subplot(133); 
% imshow(U,[]);
% colormap('jet');
% title('Recovered by CS','fontsize',18);
% %xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
% xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U-I,'fro')/nrmI*100,t),'fontsize',16);
% %xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);