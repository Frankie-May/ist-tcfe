close all
clear all

%% SYMBOLIC COMPUTATIONS OF t1
%% Node Analysis

pkg load symbolic

syms V0 Vb Vc Vd Ve Vf Vg

Va = 5.02770960543;
R1 = 1.02055434268*10^3;
R2 = 2.00415325659*10^3;
R3 = 3.09219210964*10^3;
R4 = 4.13741259708*10^3;
R5 = 3.11995097026*10^3;
R6 = 2.00264223494*10^3;
R7 = 1.02137871871*10^3;
Id = 1.03462284298*10^-3;
Kb = 7.26294962318*10^-3;
Kc = 8.23798173787*10^3;

%eqn1 = (Va-Vb)/(R1) + (Vc-Vb)/(R2) + (Vb-Vd)/(R3) == 0;
%eqn2 = (Kb*(Vb-Vd)) + (Vc-Vb)/(R2) == 0;
%eqn3 = Id + (Vd-Ve)/(R5) - Kb*(Vb-Vd) == 0;
%eqn4 = (V0-Vf)/(R6) + (Vf-Vg)/(R7) == 0;
%eqn5 = V0 == 0;
%eqn6 = Vg == Vd - Kc*(V0-Vf)/(R6);

%solve([eqn1, eqn2, eqn3, eqn4,e qn5, eqn6], [Vb, Vc, Vd, Ve, V0, Vf, Vg])

A = [   1         0             0          0      0	               0      0       0
       -1/R1  1/R1+1/R2+1/R3  -1/R2        0    -1/R3              0      0       0
        0       -1/R2-Kb       1/R2        0      0                0      0       0
        0         0             0          0      0                0      0       0
        0       -1/R3           0        -1/R4  1/R4+1/R3+1/R5+1 -1/R5  -Kc/R6   -1
        0         0             0        -1/R5   1/R5              0      0       0
        0         0             0        -1/R6    0                0  1/R6+1/R7  -1/R7
        0         0             0          0      0                0    -1/R7     1/R7-1]

B = [Va; 0; 0; 0; 0; Id; 0; -Id]

A^-1*B