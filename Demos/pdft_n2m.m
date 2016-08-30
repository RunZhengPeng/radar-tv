function y = pdft_n2m(x,picks,perm)

% Calculate y = A*x,
% where A is m x n, and consists of m rows of the 
% n by n discrete-Fourier transform (FFT) matrix.
% The row indices are stored in picks.

x = x(:);%表示以一列的方式显示x中所有元素
n = length(x);
tx = fft(x(perm))
y = tx(picks);
%%
%cwavelength = 0.83783;      % nm central wavelength
%idx = 8192;                % position of  peak wavelength in CCD
%res_l = 0.0000674;                             % micrometer      the resolution of spectremeter
%res =2*pi*res_l/(cwavelength^2);               % 1/um    the resolution of wavenmuber
%wavelength = cwavelength-(idx-1)*res_l:res_l:cwavelength+(16384-idx)*res_l;     % the range of wavelength
%wavenumber =2*pi./wavelength;
%x_wavenumber = wavenumber(1):-res:wavenumber(1)-16383*res;                        % the interplate point


%S=gaussmf(wavelength,[0.054 0.83783]); %光源光谱
%Sk=interp1(wavenumber,S,x_wavenumber);%光源光谱转变为k，并进行插值
%P=Sk.*Sk;%功率谱
%W=P';

%tx = W.*fft(x(perm));
%txx = 2*real(tx);
%y = txx(picks);