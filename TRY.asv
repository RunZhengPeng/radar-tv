syms t a1 a2;   %定义函数变量，t为积分变量
 fun=exp(-t^2/2)/sqrt(2*pi);         %标准正态分布原函数
 C=zeros(1,36);
 i=0;
 k=1;
 sum_sample=0;
for a=-3:0.6:2.4
     a1=a;%%上下积分边界
     a2=a+0.6;
 Y=round(double(36*int(fun,t,a1,a2)));%%10组36个 每组分别该随机取多少数据
  if Y>=1
  S=randperm(36);
  
  for s=1:1:Y
      sum_sample=sum_sample+1;
      C(1,k)=S(1,s)+36*i;
  k=k+1;
  end
%  d=sort(C);
  
% for s=1:1:Y
%     b(k,1)=B(d(s)+i*32,1);
%     %%Wave(k,1)=(d(s)+i*32)*0.0674+849.72-1180*0.0674; 需做变化
%     Z(k,d(s)+i*32)=1;
%     k=k+1;
% end
  end
  i=i+1;
%   
end
C=sort(C);