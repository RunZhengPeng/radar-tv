% problem size
n = 2^14;
m = floor(.25*n); k = floor(.01*m);%朝负无穷方向舍
fprintf('\nSize [n,m,k] = [%i,%i,%i]\n',n,m,k);


% generate staircase xs
z = zeros(n-1,1);
p = randperm(n-1);
z(p(1:k)) = randn(k,1) + 1i*randn(k,1);
xs = cumsum([randn; z]);

p = randperm(n);
picks = sort(p(1:m)); picks(1) = 1;%B=sort(A) 对一维或二维数组进行升序排序,并返回排序后的数组,当A为二维时,对数组每一列进行排序
perm = randperm(n);
xs = xs(:);%表示以一列的方式显示x中所有元素
n = length(xs);
tx = fft(xs(perm))/sqrt(n);
y = tx(picks);