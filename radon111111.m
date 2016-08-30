P = phantom(128);
theta=0:1:179;
R = radon(P,1:2:179);        
I1 = iradon(R,1:2:179);
I2 = iradon(R,1:2:179,'linear','none');
subplot(1,2,1), imshow(P), title('Original')
subplot(1,2,2), imshow(I1), title('Filtered backprojection')
% subplot(1,3,3), imshow(I2,[]), title('Unfiltered backprojection')
n_theta=length(theta);