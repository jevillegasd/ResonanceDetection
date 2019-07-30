k_q = 8.61733034e-5; %V/K  (k/q) Botlzmann Constant/ electron charge
T = 300; %Kelvin
V_t = k_q*T;
n = 2; %ideality factor

Vmax = max(V); Imax = max(I);

Is = Imax/(exp(Vmax/(n*V_t))-1);

% syms n_ Is_
% eq1 = I == Is_*(exp(Vmax/(n_*V_t))-1);
% eval(vpasolve(eq1,[Is_,n_]));

Vx=[600 610 620 630 640 650 660 670 680 690 700 750 800 850 900 950 1000 1050 1100 1150 1200 1250 1300];
Vx = Vx/1000; %Volateg in V


Ix = interp1(V,I,Vx');
Ix(Vx>1) = I_s*(exp(Vx(Vx>1) /(n*V_t))-1);

Ix(isnan(Ix)) = 0


semilogy(Vx,Ix); hold on;
semilogy(V,I); hold off;



