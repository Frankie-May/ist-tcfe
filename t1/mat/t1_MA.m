close all
clear all

%% SYMBOLIC COMPUTATIONS OF t1
%% Mesh Analysis

pkg load symbolic

syms Ij;
syms Ik;
syms Il;
syms Im;

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

A = [R1+R3+R4    -R3          -R4          0
       Kb*R3    1-Kb*R3         0          0
       -R4        0           R4+R6+R7-Kc  0
        0         0             0          1]

B = [Ij
	 Ik
	 Il
	 Im]

C = [Va
	 0
	 0
	-Id]

D=A^-1*C

R1 * (A^-1*C)(1,1)
R2 * (A^-1*C)(2,1)
R3 * ((A^-1*C)(1,1)-(A^-1*C)(2,1))

printf(  "MA_TAB\n");
printf("i1 = %e\n" , D(1));
printf("i2 = %e\n" , D(2));
printf("i3 = %e\n" , D(1)-D(2));
printf("i4 = %e\n" , D(1)-D(3));
printf("i5 = %e\n" , D(2)-D(4));
printf("i6 = %e\n" , D(3));
printf("i7 = %e\n" , D(3));
printf("Va = %e\n" , Va);
printf("Vb = %e\n" , Va-R1*D(1));
printf("Vc = %e\n" , Va-R1*D(1)-R2*D(2));
printf("Vd = %e\n" , Va-R1*D(1)-R3*(D(1)-D(2)));
printf("Ve = %e\n" , Va-R1*D(1)-R3*(D(1)-D(2))+R5*(D(2)-D(4)));
printf("Vf = %e\n" , R6*D(3));
printf("Vg = %e\n" , R6*D(3)+R7*D(3));
printf("MA_END");