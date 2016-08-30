clear; close all;
path(path,genpath(pwd));
fullscreen = get(0,'ScreenSize');

load('cardiac_sequence_64');
ytu = cardiac_phantom_64(:,:,6);
I = reshape(ytu,4096,1);



load('SystemMatrix');
G1 = systemmatrix;


f = G1 * I;
f =  reshape(f,64,64);



imshow(f,[]);
colormap('jet');
title('by CHENZHI','fontsize',18); 