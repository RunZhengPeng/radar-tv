
load('CTomog1.mat');
s=zeros(192,192,192);
for i=1:1:96
s(:,i,:)=CTomog(:,i,:);
end
load('CTomog2.mat');
for i=1:1:96
s(:,i+96,:)=CTomog(:,i,:);
end

% [dim1,dim2,dim3]=size(s);
% for ii=1:1:192
% aa=squeeze(s(:,:,ii));
% 
% Alpha=ones(dim1,dim2);
% for i=1:dim1
%     for j=1:dim2
%         if (aa(i,j)<0.02)
%             Alpha(i,j) = 0;
%         end
%     end
% end
% imshow(aa);
% imwrite(aa,'output2.png','Alpha',Alpha);
S=s(70:100,70:100,110:140);
X=1:1:31;
Y=1:1:31;
Z=1:1:31;
Sx=1:1:31;
Sy=1:1:31;
Sz=1:1:31;
V=S;
SLICE(X,Y,Z,V,Sx,Sy,Sz)
shading interp
