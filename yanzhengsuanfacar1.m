clear; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');
load('SystemMatrix');
load('cardiac_sequence_64');
ytu=cardiac_phantom_64(:,:,4);
I=flipud(imrotate(ytu,90));

load('cardiac_1_64');
ytu=cardiac_1_64;
I1=flipud(imrotate(ytu,90));

subplot(223); 
imshow(I1,[]);
colormap('jet');
title('truth','fontsize',18);

load('ytest');
load('y');

% n = 128;
% ratio = .3;
p = 64; q = 64; % p x q is the size of image
%m = round(ratio*n^2);
% 
% N=64;
% x_dim=N;
% y_dim=N;
% b_size=x_dim;
% a_size=y_dim;
% fov_size=N;
% ig=image_geom('nx',x_dim,'ny',y_dim,'fov',fov_size);
% sg = sino_geom('par', 'nb', b_size, 'na', a_size);
% G = Glinear(ig.nx,ig.ny,sg.nb,sg.na);

G = systemmatrix;
YY=reshape(ytest/max(max(ytest)),4096,1);
YYy=reshape(y,4096,1);
% 
% YY=G * YI;

nrmI = norm(I,'fro');

%nrmI = norm(I/max(max(I)),'fro');
figure('Name','TVAL3','Position',...
    [fullscreen(1) fullscreen(2) fullscreen(3) fullscreen(4)]);

subplot(221); 
imshow(I,[]);
colormap('jet');
title('truth','fontsize',18); 

t = cputime;
x=my_mlem128(YY,6);
t = cputime - t;


subplot(222); 
imshow(x,[]);
colormap('jet');



title('Recovered by EM','fontsize',18); drawnow;
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x/max(max(x))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x-I,'fro')/nrmI*100,t),'fontsize',16);


t = cputime;
x=my_mlem128(YYy,6);
t = cputime - t;


subplot(224); 
imshow(x,[]);
colormap('jet');



title('Recovered by EM','fontsize',18); drawnow;
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x/max(max(x))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x-I,'fro')/nrmI*100,t),'fontsize',16);



% %% Run TVAL3
% clear opts
% opts.mu = 2^8;
% opts.beta = 2^15;
% opts.tol = 1E-3;
% opts.maxit = 300;
% opts.TVnorm = 2;
% opts.nonneg = true;
% 
% % f=YY;
% f=ytest;
% f=reshape(f,4096,1);
% t = cputime;
% [U, out] = TVAL3(G,f,p,q,opts);
% t = cputime - t;
% 
% 
% profI=I(32,:);
% profx=x(32,:);
% profU=U(32,:);
% prof=1:64;
% subplot(223);
% hold on ; 
% 
% plot(prof,profI,'R'); 
% plot(prof,profx,'B');
% plot(prof,profU,'G');
% legend('Groundtruth','Rec by EM','Rec by CS')
% hold off;
% title('Profile','fontsize',18);
% 
% 
% subplot(224); 
% imshow(U,[]);
% colormap('jet');
% 
% title('Recovered by CS','fontsize',18);
% %xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
% xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U-I,'fro')/nrmI*100,t),'fontsize',16);
