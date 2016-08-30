% Discrete Radon Transform
f=phantom(128);
[N M] = size(f);
% Center of the image
x_min = -((M) / 2);
y_min = -((N) / 2);

for theta = 1 : 180
    angle = theta * pi / 180;
    if sin(angle) > sin(pi / 4)
        ds = 1 / (sin(angle));
    elseif sin(angle) <= sin(pi / 4)
        ds = 1 / abs(cos(angle));
    end
    P_theta = round(M * ds) - mod(round(M * ds), 2);
    rho_min = -(P_theta - 1)/2;
    for i = 0 : P_theta - 1
        rho = rho_min + i;
        rho_const = round((M - 1) / 2 * abs(abs(cos(angle)) - sin(angle)));
        alpha = (P_theta - 1) / 2 - rho_const + 1;
        beta = M ^2 / 2 - M * rho_const;
        d = 2 * (alpha * M - beta) / (alpha * (alpha - 1));
        if abs(rho) <= rho_const
            Spt = M;
        else
            Spt = M - round((abs(rho) - rho_const) * d);
        end
        s_min = -ds / 2 * (Spt - 1);
        R(rho - rho_min + 1, theta) = 0;
        Rs(rho - rho_min + 1, theta) = 0;
        for j = 0 : Spt - 1
            s = s_min + j * ds;
            xk = round((rho) * cos(angle) - (s) * sin(angle) - x_min);
            yk = round((rho) * sin(angle) + (s) * cos(angle) - y_min);
            R(rho - rho_min + 1, theta) = R(rho - rho_min + 1, theta) + ds * f(yk + 1, xk + 1);
            Rs(rho - rho_min + 1, theta) = Rs(rho - rho_min + 1, theta) + f(yk + 1, xk + 1);
        end
        Rs(rho - rho_min + 1, theta) = ds * Rs(rho - rho_min + 1, theta) / Spt;
    end
end