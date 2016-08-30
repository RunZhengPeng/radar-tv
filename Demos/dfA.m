 function y = dfA(x,picks,perm,mode)

A = pdft_operator(picks,perm);
switch mode
    case 1
        % y = A_fw(z, OMEGA, idx, permx);
        y = A.times(x);
    case 2
        % y = At_fw(z, OMEGA, idx, permx);
        y = A.trans(x);
    otherwise
        error('Unknown mode passed to f_handleA in ftv_cs.m');
end   