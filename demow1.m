clear; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');

load('brain_phantom_64');
ytu=brain_phantom_64;
subplot(131); 
imshow(flipud(imrotate(ytu,90)),[]);
title('truth','fontsize',18); 

load('sino_brain');
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


%nrmI = norm(I,'fro');
% figure('Name','TVAL3','Position',...
%     [fullscreen(1) fullscreen(2) fullscreen(3) fullscreen(4)]);

x=my_mlem128(sino_brain,10);

subplot(132); imshow(x,[]);
title('Recovered by EM','fontsize',18); drawnow;


%% Run TVAL3
clear opts
opts.mu = 2^8;
opts.beta = 2^5;
opts.tol = 1E-3;
opts.maxit = 300;
opts.TVnorm = 2;
opts.nonneg = true;

f=sino_brain;
f=reshape(f,4096,1);
t = cputime;
[U, out] = TVAL3(G,f,p,q,opts);
t = cputime - t;


subplot(133); 
imshow(U,[]);
title('Recovered by CS','fontsize',18);
xlabel(sprintf(' number of angles=%2d  \n Rel-Err: %4.2f%%, CPU: %4.2fs ',n_theta,norm(U-I,'fro')/nrmI*100,t),'fontsize',16);
