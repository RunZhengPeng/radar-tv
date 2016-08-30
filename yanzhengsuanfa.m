clear; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');

load('cardiac_sequence_64');
ytu=cardiac_phantom_64(:,:,6);
I=flipud(imrotate(ytu,90));
load('SystemMatrix');

load('sino_cardiac_dynamic');
YYY=sino_cardiac_dynamic(:,:,6);

G1 = systemmatrix/max(max(systemmatrix));

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

YI=reshape(I,4096,1);

YY=G1 * YI;


nrmI = norm(I,'fro');
%nrmI = norm(I/max(max(I)),'fro');
figure('Name','TVAL3','Position',...
    [fullscreen(1) fullscreen(2) fullscreen(3) fullscreen(4)]);

subplot(131); 
imshow(I,[]);
colormap('jet');
title('truth','fontsize',18); 

t = cputime;
x=my_mlem128(YY,10);
t = cputime - t;
subplot(132); 
imshow(x,[]);
colormap('jet');
title('Recovered by EM','fontsize',18); drawnow;
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x/max(max(x))-I/max(max(I))/nrmI*100,t),'fontsize',16);
xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x-I,'fro')/nrmI*100,t),'fontsize',16);
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x/max(max(x))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
%% Run TVAL3
clear opts
opts.mu = 2^4;
opts.beta = 2^3;
opts.tol = 1E-3;
opts.maxit = 300;
opts.TVnorm = 2;
opts.nonneg = true;

% f=YY;
f=sino_cardiac_dynamic(:,:,6);
f=reshape(f,4096,1);
t = cputime;
[U, out] = TVAL3(G1,f,p,q,opts);
t = cputime - t;


subplot(133); 
imshow(U,[]);
colormap('jet');
title('Recovered by CS','fontsize',18);
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U-I,'fro')/nrmI*100,t),'fontsize',16);
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);