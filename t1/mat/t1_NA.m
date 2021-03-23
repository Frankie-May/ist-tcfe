close all
clear all

%% SYMBOLIC COMPUTATIONS OF t1
%% Node Analysis

pkg load symbolic

syms Vb Vc Vd Ve Vf Vg Ik

Va = 5.02770960543;
G1 = 1/(1.02055434268*10^3);
G2 = 1/(2.00415325659*10^3);
G3 = 1/(3.09219210964*10^3);
G4 = 1/(4.13741259708*10^3);
G5 = 1/(3.11995097026*10^3);
G6 = 1/(2.00264223494*10^3);
G7 = 1/(1.02137871871*10^3);
Id = 1.03462284298*10^-3;
Kb = 7.26294962318*10^-3;
Kc = 8.23798173787*10^3;

%eqn1 = Vb*(G1+G2+G3)-Vc*G2-Vd*G3 == Va*G1;
%eqn2 = Vc*G2-Vb*(G2+Kb)+Vd*Kb == 0;
%eqn3 = Vd*(G3+G4+G5)-Vb*G3-Ve*G5 == Ik;
%eqn4 = Ve*G5+Vb*Kb-Vd*(G5+Kb) == Id;
%eqn5 = Vf*(G6+G7)-Vg*G7 == 0;
%eqn6 = Vg*G7-Vf*G7 == -Ik-Id;
%eqn7 = Vd-Vg+Vf*Kc*G6 == 0;

%solve([eqn1, eqn2, eqn3, eqn4,e qn5, eqn6, eqn7], [Vb, Vc, Vd, Ve, Vf, Vg, Ik])

A = [ G1+G2+G3   -G2              -G3         0	            0      0       0
     -G2-Kb       G2               Kb         0                0      0       0
       -G3        0             G3+G4+G5     -G5               0      0      -1
        Kb        0             -G5-Kb        G5               0      0       0
        0         0                0          0              G6+G7   -G7      0
        0         0                0          0               -G7     G7      1
        0         0                1          0              Kc*G6   -1       0]

B = [Va*G1
	 0
	 0
	 Id
	 0
	 -Id
	 -0]


A^-1*B