close all
clear all

%%Loads symbolic package for symbolic calculations
pkg load symbolic

output_precision (12);
source = fopen ("data.log" , "r");

destiny = fopen("data.net" , "w");

C = textscan(source , "\n\nPlease enter the lowest student number in your group:\n\n\nUnits for the values: V, mA, kOhm, mS and uF\n\n\nValues:  R1 = %f64 \nR2 = %f \nR3 = %f \nR4 = %f \nR5 = %f \nR6 = %f \nR7 = %f \nVs = %f \nC = %f \nKb = %f \nKd = %f \n");

fprintf(destiny , "*Imported data from t2_datagen.py\n");
for i=1:11
	if (0<i && i<8)
		fprintf(destiny , ".param RR%d = %.12fk\n" , i , C{1 , i});
	endif
	if(i == 8)
		fprintf(destiny , ".param Vss = %.12f\n" , C{1 , i});
	endif
	if(i==9)
		fprintf(destiny , ".param Cc = %.12fu\n" ,C{1 , i});
	endif
	if (i == 10)
		fprintf(destiny , ".param Kb = %.12fk\n" ,C{1 , i});
	endif
	if(i == 11)
		fprintf(destiny , ".param Kd = %.12fk\n" ,C{1 , i});
	endif
endfor

fclose(source);
fclose(destiny);

%%Resistance Variables
sym R1;
sym R2;
sym R3;
sym R4;
sym R5;
sym R6;
sym R7;
sym G1;
sym G2;
sym G3;
sym G4;
sym G5;
sym G6;
sym G7;
sym Kb;
sym Kd;

%%Voltage Variables
sym Vs;
sym Vb;
sym Vd;

%%Current Variables
sym Ib;
sym Ic;
sym Id;

%%Capacity Variables
sym Cf;

%%Values attribution
Vs = C{1,8};
R1 = C{1,1}*10^3;
R2 = C{1,2}*10^3;
R3 = C{1,3}*10^3;
R4 = C{1,4}*10^3;
R5 = C{1,5}*10^3;
R6 = C{1,6}*10^3;
R7 = C{1,7}*10^3;
Kb = C{1,10}*10^3;
Kd = C{1,11}*10^3;
Cf = C{1,9}*10^(-6);
G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
G5 = 1/R5;
G6 = 1/R6;
G7 = 1/R7;

%%Nodal analysis for t<0
A =[1 , 0 , 0 , 0 , 0 , 0 , 0;
	G1 , -(G1 + G2 + G5) , G2 , G5 , 0 , 0 , 0;
	0 , -(G2 + Kb) , G2 , Kb , 0 , 0 , 0;
	0 , -Kb , 0 , (G5 + Kb) , -G5 , 0 , 0;
	0 , 0 , 0 , 0 , 0 , (G6 + G7) , -G7;
	0 , 0 , 0 , 1 , 0 , (Kd * G6) , -1;
	0 , G3 , 0 , (G4 - G3 - G5) , G5 , G7 , -G7;]

D = [Vs;
	0;
	0;
	0;
	0;
	0;
	0;]

X = A\D;

%%Prints Potential Values obtained through nodal analysis for t<0
printf("| t<0 Analysis |\n");
printf("|Nodal Analysis|\n");
printf("|V1| %.12fV |\n" , X(1));
printf("|V2| %.12fV |\n" , X(2));
printf("|V3| %.12fV |\n" , X(3));
printf("|V4| 0.000000000000V |\n");
printf("|V5| %.12fV |\n" , X(4));
printf("|V6| %.12fV |\n" , X(5));
printf("|V7| %.12fV |\n" , X(6));
printf("|V8| %.12fV |\n" , X(7));

%%Calculates and prints Current Values obtained through nodal analysis for t<0
printf("NA_TAB\n");
printf("|i1 | %.12eA|\n" , ((X(2)-X(1))*G1));
printf("|i2 | %.12eA|\n" , ((X(3)-X(2))*G2));
printf("|i3 | %.12eA|\n" , ((X(2)-X(5))*G3));
printf("|i4 | %.12eA|\n" , (X(4)*G4));
printf("|i5 | %.12eA|\n" , ((X(4)-X(5))*G5));
printf("|i6 | %.12eA|\n" , (X(6)*G6));
printf("|i7 | %.12eA|\n" , ((X(6)-X(7))*G7));
printf("|iVs| %.12eA|\n" , ((X(2)-X(1))*G1));
printf("|iVd| %.12eA|\n" , ((X(7)-X(6))*G7));
printf("|ib | %.12eA|\n" , Kb * (X(2)-X(5)));
printf("NA_END\n");




%%Equivalent Resistor determination
%%Additional Variables
sym Vx;
sym Vss;

Vx = X(5) - X(7);
Vss = 0;

I = [1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0;
	G1 , -(G1 + G2 + G5) , G2 , G5 , 0 , 0 , 0 , 0 , 0;
	0 , -(G2+Kb) , G2 , Kb , 0 , 0 , 0 , 0 , 0;
	0 , 0 , 0 , 0 , 0 , (G6 + G7) , -G7 , 0 , 0;
	0 , 0 , 0 , 0 , 1 , 0 , -1 , 0 , 0;
	0 , 0 , 0 , 1 , 0 , (Kd * G6) , -1 , 0 , 0;
	0 , Kb , 0 , (G5 - Kb) , -G5 , 0 , 0 , -1 , 0;
	0 , G3 , 0 , (G4-G3-G5) , G6 , 0 , 0 , 0 , -1;
	0 , 0 , 0 , 0 , 0 , -G7 , G7 , -1 , -1]

J = [Vss;
	0;
	0;
	0;
	Vx;
	0;
	0;
	0;
	0]

K = I\J;

%%K = [V1;
%	V2;
%	V3
%	V5;
%	V6;
%	V7;
%	V8;
%	Ix;
%	Iy]

printf("Ix = %.12f \n", K(8));
%%Equivalent Resistance and Time Constant determined
sym Req;
sym tau;

Req = Vx / abs(K(8));
tau = Req * Cf;
V06 = K(5);

%%Natural Solution v6_n(t)
t = 0:(20*10^-3)/1000:20*10^-3;

v6_nt = V06*e.^(-(t/tau));

graf_nat = figure();

plot(t*1e3 , v6_nt);
hold on;
xlabel("t, ms");
ylabel("V6, V");
title("V6(t) natural solution plot");
legend("Natural solution plot for node 6 with t belonging to [0, 20]ms" , "location" , "north");
%%prints natural solution graphic prepared to be converted to pdf
print (graf_nat, "graf_nat.pdf", "-dpdflatexstandalone");

%%creates pdf of graphic and deletes unused files
system("pdflatex graf_nat");
system("rm graf_nat.aux && rm graf_nat-inc.pdf && rm graf_nat.log && rm graf_nat.tex");

%%Complex amplitude determination. Nodal analysis for complete circuit when e^(t/tau) = 1:

%%Additional Variables and new values assignment
sym w;
w = 2*pi*1;

sym Zc;

Zc = 1/(j*w*Cf);

Vss = 1;
E = [-G1 , (G1+G2+G3) , -G2 , -G3 , 0 , 0 , 0 , 0 , 0;
	0 , -(G2+Kb) , G2 , Kb , 0 , 0 , 0 , 0 , 0;
	0 , -Kb , 0 , (G5+Kb) , -(G5 + (1/Zc)) , 0 , (1/Zc) , 0 , 0;
	0 , 0 , 0 , 0 , 0 , -(G6+G7) , G7 , 0 , 0;
	0 , -G3 , 0 , (G3 + G4 + G5) , -G5 , 0 , 0 , 1 , 0;
	0 , 0 , 0 , -1 , 0 , -Kd*G6 , 1 , 0 , 0;
	-G1 , G1 , 0 , 0 , 0 , 0 , 0 , 0 , -1;
	1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0;
	0 , 0 , 0 , 0 , 1/Zc , G7 , -(G7+(1/Zc)) , 1 , 0]

F =[0;
	0;
	0;
	0;
	0;
	0;
	0;
	Vss;
	0]

G = E\F;

printf("new_Complex_Amplitude_Tabel\n");
printf("V1 = %.12f\n" , arg(C(1)));
printf("V2 = %.12f\n" , arg(C(2)));
printf("V3 = %.12f\n" , arg(C(3)));
printf("V4 = 0.000000000000V\n");
printf("V5 = %.12f\n" , arg(C(4)));
printf("V6 = %.12f\n" , arg(C(5)));
printf("V7 = %.12f\n" , arg(C(6)));
printf("V8 = %.12f\n" , arg(C(7)));
printf("end_Complex_Amplitude_Tabel\n");

%%Forced solution
V_ft = e.^(j*(w*tempo-(pi/2)));
V6_ft = abs(G(5))*V_ft;




