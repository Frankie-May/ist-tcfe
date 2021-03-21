close all
clear all

%% SYMBOLIC COMPUTATIONS OF t1
%% Node Analysis

pkg load symbolic

%% Resistances
sym R1
sym R2
sym R3
sym R4
sym R5
sym R6
sym R7
sym Kb
sym Kc

%%Voltage Variables
sym Va
sym Vb
sym Vc

%%Current Variables
sym Ib
sym Ic
sym Id

%%Mesh Currents
sym Ima
sym Imb
sym Imc
sym Imd


%% Values Attribution
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

%%Equations
eq1 = Imb == - Ib;
eq2 = Imd == - Id;
eq3 = Va - R1 * Ima - R3 * (Ima-Imb) + R4 * (Imc - Ima) == 0;
eq4 = R6 * Imc - R4 * (Imc-Ima) - Vc + R7 * Imc == 0;

%%Extra Equations
Ib = Kb * Vb;
Vc = kc* Ic;
Vb = R3 * (Ima-Imb);
Ic = Imc;

%%Solution
%solve (eq1 , eq2 , eq3 , eq4 , Ima , Imb , Imc , Imd)