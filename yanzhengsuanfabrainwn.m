clear; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');

load('brain_phantom_64');
ytu=brain_phantom_64;
I = ytu/max(max(ytu));
% I=flipud(imrotate(ytu,90));

load('SystemMatrix');
G1 = systemmatrix;

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

YI=reshape(I,4096,1);

% YY=G * YI;
YY = sino_brain;
% figure;im(YY);
YY = reshape(YY,4096,1);
nrmI = norm(I,'fro');

%nrmI = norm(I/max(max(I)),'fro');
figure('Name','TVAL3','Position',...
    [fullscreen(1) fullscreen(2) fullscreen(3) fullscreen(4)]);

subplot(221); 
imshow(I,[]);
colormap('jet');
title('truth','fontsize',18); 

t = cputime;
x=my_mlem128_1(YY,10);
t = cputime - t;

% x=flipud(imrotate(x,90));
x = x / max(max(x)); 

subplot(222); 
imshow(x,[]);
colormap('jet');



title('Recovered by EM','fontsize',18); drawnow;
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x/max(max(x))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
% xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(x-I,'fro')/nrmI*100,t),'fontsize',16);

xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',abs(mean((mean(x-I))/mean(mean(I))))*100,t),'fontsize',16);
%% Run TVAL3
clear opts
opts.mu = 2^1;
opts.beta = 2^-6;
opts.tol = 1E-3;
opts.maxit = 300;
opts.TVnorm = 2;
opts.nonneg = true;

% f=YY;
f=sino_brain;
f=reshape(f,4096,1);
t = cputime;
[U, out] = TVAL3(G1,f,p,q,opts);
t = cputime - t;
U = U / max(max(U));
% U=flipud(imrotate(U,90));



profI=I(32,:);
profx=x(32,:);
profU=U(32,:);
prof=1:64;
subplot(223);
hold on ; 

plot(prof,profI,'R'); 
plot(prof,profx,'B');
plot(prof,profU,'G');
legend('Groundtruth','Rec by EM','Rec by CS')
hold off;
title('Profile','fontsize',18);


subplot(224); 
imshow(U,[]);
colormap('jet');

title('Recovered by CS','fontsize',18);
%xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U/max(max(U))-I/max(max(I)),'fro')/nrmI*100,t),'fontsize',16);
% xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',norm(U-I,'fro')/nrmI*100,t),'fontsize',16);

xlabel(sprintf(' Rel-Err: %4.2f%%, CPU: %4.2fs ',abs(mean((mean(U-I))/mean(mean(I))))*100,t),'fontsize',16);


