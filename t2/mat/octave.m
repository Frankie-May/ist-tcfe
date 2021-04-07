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
	G1 , -(G1 + G2 + G3) , G2 , G3 , 0 , 0 , 0;
	0 , -(G2 + Kb) , G2 , Kb , 0 , 0 , 0;
	0 , -Kb , 0 , (G5 + Kb) , -G5 , 0 , 0;
	0 , 0 , 0 , 0 , 0 , (G6 + G7) , -G7;
	0 , 0 , 0 , 1 , 0 , (Kd * G6) , -1;
	0 , G3 , 0 , (-G4 - G3 - G5) , G5 , G7 , -G7;]

D = [Vs;
	0;
	0;
	0;
	0;
	0;
	0]

X = A\D;

%%Creates file to print table with Potential Values obtained through nodal analysis for t<0
tmen0 = fopen("tableinferior0.tex" , "w");

%%Prints Potential Values obtained through nodal analysis for t<0
fprintf(tmen0 , "V1 & %.12f\\\\ \\hline\n" , X(1));
fprintf(tmen0 , "V2 & %.12f\\\\ \\hline\n" , X(2));
fprintf(tmen0 , "V3 & %.12f\\\\ \\hline\n" , X(3));
fprintf(tmen0 , "V4 & 0.000000000000\\\\ \\hline\n");
fprintf(tmen0 , "V5 & %.12f\\\\ \\hline\n" , X(4));
fprintf(tmen0 , "V6 & %.12f\\\\ \\hline\n" , X(5));
fprintf(tmen0 , "V7 & %.12f\\\\ \\hline\n" , X(6));
fprintf(tmen0 , "V8 & %.12f\\\\ \\hline\n" , X(7));

%%Calculates and prints Current Values obtained through nodal analysis for t<0
fprintf(tmen0 , "i1  & %.12e\\\\ \\hline\n" , ((X(2)-X(1))*G1));
fprintf(tmen0 , "i2  & %.12e\\\\ \\hline\n" , ((X(3)-X(2))*G2));
fprintf(tmen0 , "i3  & %.12e\\\\ \\hline\n" , ((X(2)-X(4))*G3));
fprintf(tmen0 , "i4  & %.12e\\\\ \\hline\n" , (X(4)*G4));
fprintf(tmen0 , "i5  & %.12e\\\\ \\hline\n" , ((X(4)-X(5))*G5));
fprintf(tmen0 , "i6  & %.12e\\\\ \\hline\n" , (X(6)*G6));
fprintf(tmen0 , "i7  & %.12e\\\\ \\hline\n" , ((X(6)-X(7))*G7));
fprintf(tmen0 , "iVs & %.12e\\\\ \\hline\n" , ((X(2)-X(1))*G1));
fprintf(tmen0 , "iVd & %.12e\\\\ \\hline\n" , ((X(7)-X(6))*G7));
fprintf(tmen0 , "ib  & %.12e\\\\ \\hline\n" , Kb * (X(2)-X(4)));


%%Closes file
fclose(tmen0);
system("cp tableinferior0.tex ../doc && rm tableinferior0.tex");

%%
%%
%%Equivalent Resistor determination
%%Additional Variables
sym Vx;
sym Vss;

Vx = X(5) - X(7);
Vss = 0;

I = [1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0;
	G1 , -(G1 + G2 + G3) , G2 , G3 , 0 , 0 , 0 , 0 , 0;
	0 , -(G2+Kb) , G2 , Kb , 0 , 0 , 0 , 0 , 0;
	0 , 0 , 0 , 0 , 0 , (G6 + G7) , -G7 , 0 , 0;
	0 , 0 , 0 , 0 , 1 , 0 , -1 , 0 , 0;
	0 , 0 , 0 , 1 , 0 , (Kd * G6) , -1 , 0 , 0;
	0 , Kb , 0 , -(G5 + Kb) , G5 , 0 , 0 , 1 , 0;
	0 , G3 , 0 , (-G4-G3-G5) , G6 , 0 , 0 , 0 , -1;
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

%%Printing results to file with content of table
tnat = fopen("tnat.tex" , "w");
fprintf(tnat , "V1 & %.12f\\\\ \\hline\n" , K(1));
fprintf(tnat , "V2 & %.12f\\\\ \\hline\n" , K(2));
fprintf(tnat , "V3 & %.12f\\\\ \\hline\n" , K(3));
fprintf(tnat , "V4 & 0.000000000000\\\\ \\hline\n");
fprintf(tnat , "V5 & %.12f\\\\ \\hline\n" , K(4));
fprintf(tnat , "V6 & %.12f\\\\ \\hline\n" , K(5));
fprintf(tnat , "V7 & %.12f\\\\ \\hline\n" , K(6));
fprintf(tnat , "V8 & %.12f\\\\ \\hline\n" , K(7));
fprintf(tnat , "i1 & %.12f\\\\ \\hline\n" , G1*(K(2)-K(1)));
fprintf(tnat , "i2 & %.12f\\\\ \\hline\n" , G2*(K(3)-K(2)));
fprintf(tnat , "i3 & %.12f\\\\ \\hline\n" , G3*(K(2)-K(4)));
fprintf(tnat , "i4 & %.12f\\\\ \\hline\n" , G4*(-K(4)));
fprintf(tnat , "i5 & %.12f\\\\ \\hline\n" , G5*(K(4)-K(5)));
fprintf(tnat , "i6 & %.12f\\\\ \\hline\n" , G6*(K(6)));
fprintf(tnat , "i7 & %.12f\\\\ \\hline\n" , G7*(K(7)-K(6)));
fprintf(tnat , "iVx & %.12f\\\\ \\hline\n" , K(8));
fprintf(tnat , "iVd & %.12f\\\\ \\hline\n" , K(9));

%%export to file finished
fclose(tnat);
system("cp tnat.tex ../doc && rm tnat.tex");

%%K = [V1;
%	V2;
%	V3
%	V5;
%	V6;
%	V7;
%	V8;
%	Ix;
%	Iy]

%%Equivalent Resistance and Time Constant determined
sym Req;
sym tau;
sym V06;

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
system("cp graf_nat.pdf ../doc");
system("rm graf_nat.pdf && rm graf_nat.aux && rm graf_nat-inc.pdf && rm graf_nat.log && rm graf_nat.tex");



%%Complex amplitude determination. Nodal analysis for complete circuit when e^(t/tau) = 1: (DIOGO, PRINTS VOLTAGES)


%%Nodal analysis for forced solution (FRANCISCO, PRINTS CURRENTS)
sym Vsf;
sym Z1; 
sym Z2;
sym Z3;
sym Z4;
sym Z5;
sym Z6;
sym Z7;

Vsf = 1;

Z1 = R1;
Z2 = R2;
Z3 = R3;
Z4 = R4;
Z5 = R5;
Z6 = R6;
Z7 = R7;

Zc = (1/(Cf*2*pi*10e+3))*e.^(-j*pi/2);


L =[1 , 0 , 0 , 0 , 0 , 0 , 0;
	1/Z1 , -(1/Z1 + 1/Z2 + 1/Z3) , 1/Z2 , 1/Z3 , 0 , 0 , 0;
	0 , -(1/Z2 + Kb) , 1/Z2 , Kb , 0 , 0 , 0;
	0 , -Kb , 0 , (1/Z5 + Kb) , -(1/Z5+1/Zc) , 0 , 1/Zc;
	0 , 0 , 0 , 0 , 0 , (1/Z6 + 1/Z7) , -1/Z7;
	0 , 0 , 0 , 1 , 0 , (Kd * 1/Z6) , -1;
	0 , 1/Z3 , 0 , -(1/Z4 + 1/Z3 + 1/Z5) , 1/Z5+1/Zc , 1/Z7 , -(1/Z7+1/Zc);]

M = [Vsf;
	0;
	0;
	0;
	0;
	0;
	0]

N = L\M;

%%Prints Complex Amplitude Table to a latex file to include in the report
tcamp = fopen("tcamp.tex" , "w");

fprintf(tcamp , "V1 & %.12f\\\\ \\hline\n" , abs(N(1)));
fprintf(tcamp , "V2 & %.12f\\\\ \\hline\n" , abs(N(2)));
fprintf(tcamp , "V3 & %.12f\\\\ \\hline\n" , abs(N(3)));
fprintf(tcamp , "V4 & 0.000000000000\\\\ \\hline\n");
fprintf(tcamp , "V5 & %.12f\\\\ \\hline\n" , abs(N(4)));
fprintf(tcamp , "V6 & %.12f\\\\ \\hline\n" , abs(N(5)));
fprintf(tcamp , "V7 & %.12f\\\\ \\hline\n" , abs(N(6)));
fprintf(tcamp , "V8 & %.12f\\\\ \\hline\n" , abs(N(7)));

%%export to file finished
fclose(tcamp);
system("cp tcamp.tex ../doc && rm tcamp.tex");


%%Total Solution v6(t)
t1 = -5*10^-3:(25*10^-3+5*10^-3)/1000:20*10^-3;
t2 = -5*10^-3:(25*10^-3+5*10^-3)/1000:0;
t3 = 0:(25*10^-3+5*10^-3)/1000:20*10^-3;

v6_t = [Vs+(0*t2) , V06*e.^(-(t3/tau)+N(6)*e.^(-j*(2*pi*1e3*t3-pi/2)))];


graf_V6_t = figure();

plot(t1*1e3 , v6_t);
hold on;
xlabel("t, ms");
ylabel("V6, V");
title("V6(t) total solution plot");
legend("Total solution plot for node 6, (the effect of the natural solution and the forced solution) with t belonging to [-5, 20]ms" , "location" , "north");
%%prints natural solution graphic prepared to be converted to pdf
print (graf_V6_t, "graf_V6_t.pdf", "-dpdflatexstandalone");

%%creates pdf of graphic and deletes unused files
system("pdflatex graf_V6_t");
system("cp graf_V6_t.pdf ../doc");
system("rm graf_V6_t.pdf && rm graf_V6_t.aux && rm graf_V6_t-inc.pdf && rm graf_V6_t.log && rm graf_V6_t.tex");

freq = 0.1:(-0.1+1*10^6)/1000:1*10^6;

for in1 = 1:1:1001

	Zc1 = (1/(Cf*2*pi*freq(in1)))*e.^(-j*pi/2);

	O =[1 , 0 , 0 , 0 , 0 , 0 , 0;
	1/Z1 , -(1/Z1 + 1/Z2 + 1/Z3) , 1/Z2 , 1/Z3 , 0 , 0 , 0;
	0 , -(1/Z2 + Kb) , 1/Z2 , Kb , 0 , 0 , 0;
	0 , -Kb , 0 , (1/Z5 + Kb) , -(1/Z5+1/Zc1) , 0 , 1/Zc1;
	0 , 0 , 0 , 0 , 0 , (1/Z6 + 1/Z7) , -1/Z7;
	0 , 0 , 0 , 1 , 0 , (Kd * 1/Z6) , -1;
	0 , 1/Z3 , 0 , -(1/Z4 + 1/Z3 + 1/Z5) , 1/Z5+1/Zc1 , 1/Z7 , -(1/Z7+1/Zc1);]

	P = [Vsf;
		0;
		0;
		0;
		0;
		0;
		0]

	Q = O\P;

	V6_freq(in1) = Q(5)
	V8_freq(in1) = Q(7)
	Vs_freq(in1) = Q(1)
	Vc_freq(in1) = Q(5)-Q(7)

end

graf_mag = figure();

plot(log10(freq), 20*log10(abs(V6_freq)));
hold on;
plot(log10(freq), 20*log10(abs(Vs_freq)), "r");
plot(log10(freq), 20*log10(abs(Vc_freq)), "g");
xlabel("f, Hz");
ylabel("$|V|$ , db");
title("Frequency responce in magnitude");
legend("Magnitude of the frequency responce in voltages V6, Vs and Vc in db." , "location" , "north");
%%prints natural solution graphic prepared to be converted to pdf
print (graf_mag, "graf_mag.pdf", "-dpdflatexstandalone");

%%creates pdf of graphic and deletes unused files
system("pdflatex graf_mag");
system("cp graf_mag.pdf ../doc");
system("rm graf_mag.aux && rm graf_mag-inc.pdf && rm graf_mag.log && rm graf_mag.tex");

graf_phase = figure();

plot(log10(freq), arg(V6_freq)*180/pi);
hold on;
plot(log10(freq), arg(Vs_freq)*180/pi, "r");
plot(log10(freq), arg(Vc_freq)*180/pi, "g");
xlabel("f, Hz");
ylabel("arg(V) , º");
title("Frequency response in phase");
legend("Phase of the frequency responce in voltages V6, Vs and Vc in degrees." , "location" , "north");
%%prints natural solution graphic prepared to be converted to pdf
print (graf_phase, "graf_phase.pdf", "-dpdflatexstandalone");

%%creates pdf of graphic and deletes unused files
system("pdflatex graf_phase");
system("cp graf_phase.pdf ../doc");
system("rm graf_phase.aux && rm graf_phase-inc.pdf && rm graf_phase.log && rm graf_phase.tex");