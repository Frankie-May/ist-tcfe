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
sym G1
sym G2
sym G3
sym G4
sym G5
sym G6
sym G7


%%Voltage Variables
sym Va
sym Vb
sym Vc

%%Current Variables
sym Ib
sym Ic
sym Id

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

%%Permitances
G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
G5 = 1/R5;
G6 = 1/R6;
G7 = 1/R7;

C = [(G1 + G2 + G3) , -G2 , -G3 , 0 , 0 , 0;
	   -(G2+Kb)     , G2  , Kb  , 0 , 0 , 0;
	      Kb        ,  0  , -(G5 + Kb) , G5 , 0 , 0;
	0 , 0 , 1 , 0 , -Kc , -1;
	0 , 0 , 0 , 0 , (G6+G7) , -G7;
	-G3 , 0 , (G3 + G4 + G5) , -G5 , -Kc*G6 , 0]

D = [Va*G1;0;Id;0;0;0]

A = C\D

printf("| NODE ANALYSIS |\n");
printf("|Vb|%e| \n" , A(1));
printf("|Vc|%e|\n" , A(2));
printf("|Vd|%e|\n" , A(3));
printf("|Ve|%e| \n" , A(4));
printf("|Vf|%e| \n" , A(5));
printf("|Vg|%e| \n" , A(6));

