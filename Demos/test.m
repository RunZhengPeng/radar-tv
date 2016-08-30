% problem size
n = 2^14;
m = floor(.25*n); k = floor(.01*m);%�����������
fprintf('\nSize [n,m,k] = [%i,%i,%i]\n',n,m,k);


% generate staircase xs
z = zeros(n-1,1);
p = randperm(n-1);
z(p(1:k)) = randn(k,1) + 1i*randn(k,1);
xs = cumsum([randn; z]);

p = randperm(n);
picks = sort(p(1:m)); picks(1) = 1;%B=sort(A) ��һά���ά���������������,����������������,��AΪ��άʱ,������ÿһ�н�������
perm = randperm(n);
xs = xs(:);%��ʾ��һ�еķ�ʽ��ʾx������Ԫ��
n = length(xs);
tx = fft(xs(perm))/sqrt(n);
y = tx(picks);