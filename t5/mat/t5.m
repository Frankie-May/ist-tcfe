%Gain Stage

Vcc=5.0;
Vee=-5.0;
%Vin in 0 0 ac 1.0 sin(0 10m 1k);
R1=1e3;
R2=100e3;

%Low Frequency Cut

Rlcut=1e3;
Clcut=1e-6;

%High Frequency Cut

Rhcut=1e3;
Chcut=1e-6;

%The Gain of the Gain Stage
printf("The Gain of the Gain Stage = %f\n", (1+(R2)/(R1)));
omega_L = (1)/(Rlcut*Clcut);
printf("omega_L = %f\n", omega_L);
omega_H = (1)/(Rhcut*Chcut);
printf("omega_H = %f\n", omega_H);
printf("omega_0 = %f\n", sqrt(omega_L*omega_H));

function transf (s)
  ((Rlcut*Clcut*s)/(1+Rlcut*Clcut*s))*(1+(R2)/(R1))*((1)/(1+Rhcut*Chcut))
endfunction

w = [];
f = [];
Af = [];
i = 1;

for w=logspace(1, 8, 100)
	Af(i) = 20*w(i);
	i++;
endfor;

w=logspace(1, 8, 100);

printf("%g", w);





%gain stage

VT=25e-3;
BFN=178.7;
VAFN=69.7;
RE1=300;
RC1=1000;
RB1=80000;
RB2=25000;
VBEON=0.7;
VCC=12;
RS=30;
Ci = 0.01e-3;
Cb = 0.01e-3;
Co = 1e-6;
RL = 8;
Vin = 10e-3;

RB=1/(1/RB1+1/RB2);
VEQ=RB2/(RB1+RB2)*VCC;
IB1=(VEQ-VBEON)/(RB+(1+BFN)*RE1);
IC1=BFN*IB1;
IE1=(1+BFN)*IB1;
VE1=RE1*IE1;
VO1=VCC-RC1*IC1;
VCE=VO1-VE1;


gm1=IC1/VT;
rpi1=BFN/gm1;
ro1=VAFN/IC1;

RSB=RB*RS/(RB+RS);

AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);
AVI_DB = 20*log10(abs(AV1));
AV1simple = RB/(RB+RS) * gm1*RC1/(1+gm1*RE1);
AVIsimple_DB = 20*log10(abs(AV1simple));

RE1=0;
AV1 = RSB/RS * RC1*(RE1-gm1*rpi1*ro1)/((ro1+RC1+RE1)*(RSB+rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2);
AV1_DB = 20*log10(abs(AV1));
AV1simple =  - RSB/RS * gm1*RC1/(1+gm1*RE1);
AVIsimple_DB = 20*log10(abs(AV1simple));

RE1=300;
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)));
ZX = ro1*(   1/RE1+1/(rpi1+RSB)+1/ro1+gm1*rpi1/(rpi1+RSB)  )/(   1/RE1+1/(rpi1+RSB) );
ZO1 = 1/(1/ZX+1/RC1);

RE1=0;
ZI1 = 1/(1/RB+1/(((ro1+RC1+RE1)*(rpi1+RE1)+gm1*RE1*ro1*rpi1 - RE1^2)/(ro1+RC1+RE1)));
ZO1 = 1/(1/ro1+1/RC1);

filegain = fopen ("gainstg.tex" , "w");

fprintf(filegain , "Gain Stage Gain [dB] & %f \\\\ \\hline \n" , AV1_DB);
fprintf(filegain , "Gain Stage Gain & %f \\\\ \\hline \n" , AV1);
fprintf(filegain , "Gain Stage Input Impedance [Ohm] & %f \\\\ \\hline \n" , ZI1);
fprintf(filegain , "Gain Stage Output Impedance [Ohm] & %f \\\\ \\hline \n" , ZO1);

fclose (filegain);

%ouput stage
BFP = 227.3;
VAFP = 37.2;
RE2 = 100;
VEBON = 0.7;
VI2 = VO1;
IE2 = (VCC-VEBON-VI2)/RE2;
IC2 = BFP/(BFP+1)*IE2;
VO2 = VCC - RE2*IE2;

gm2 = IC2/VT;
go2 = IC2/VAFP;
gpi2 = gm2/BFP;
ge2 = 1/RE2;

AV2 = gm2/(gm2+gpi2+go2+ge2);
AV2_DB = 20*log10(AV2);
ZI2 = (gm2+gpi2+go2+ge2)/gpi2/(gpi2+go2+ge2);
ZO2 = 1/(gm2+gpi2+go2+ge2);

fileoutp = fopen("outputstg.tex" , "w");

fprintf(fileoutp , "Output Stage Gain [dB] & %f \\\\ \\hline \n" , AV2_DB);
fprintf(fileoutp , "Output Stage Gain & %f \\\\ \\hline \n" , AV2);
fprintf(fileoutp , "Output Stage Input Impedance [Ohm] & %f \\\\ \\hline \n" , ZI2);
fprintf(fileoutp , "Output Stage Output Impedance [Ohm] & %f \\\\ \\hline \n" , ZO2);

fclose (fileoutp);

%total
gB = 1/(1/gpi2+ZO1);
AV = abs((gB+gm2/gpi2*gB)/(gB+ge2+go2+gm2/gpi2*gB)*AV1);
AV_DB = 20*log10(abs(AV));
ZI=ZI1;
ZO=1/(go2+gm2/gpi2*gB+ge2+gB);

filetotal = fopen("total.tex" , "w");

fprintf(filetotal , "Total Circuit Gain [dB] & %f \\\\ \\hline \n" , AV_DB);
fprintf(filetotal , "Total Circuit Gain & %f \\\\ \\hline \n" , AV);
fprintf(filetotal , "Total Circuit Input Impedance [Ohm] & %f \\\\ \\hline \n" , ZI);
fprintf(filetotal , "Total Circuit Output Impedance [Ohm] & %f \\\\ \\hline \n" , ZO);

fclose (filetotal);


%frequency response
RE1=300;
rpi2 = 1/gpi2;
ro2 = 1/go2;
Af = [];
Af_db = [];
i=1;

for f=1:0.1:8
	w = 2*pi*power(10,f);
	Z_Ci = (1/(j*w*Ci));
	Z_Cb = (1/(j*w*Cb));
	Z_Co = (1/(j*w*Co));
	ZA = RS+Z_Ci;
	ZB = 1/(1/RE1 + 1/Z_Cb);
	ZC = (1/((1/RE2) + (1/(Z_Co + RL))));

	T = [-(RB + ZA) , RB , 0 , 0 , 0 , 0 , 0; 
		RB , -(ZB + rpi1 + RB) , 0 , ZB , 0 , 0 , 0; 
		0 , gm1*rpi1 , 1 , 0 , 0 , 0 , 0; 
		0 , ZB , ro1 , -(ZB + ro1 + RC1) , RC1 , 0 , 0; 
		0 , 0 , 0 , RC1 , -(ZC + rpi2 +RC1) , 0 , ZC; 
		0 , 0 , 0 , 0 , gm2*rpi2 , 1 , 0; 
		0 , 0 , 0 , 0 , ZC , ro2 , -(ZC + ro2)]; 
	U = [Vin;
		0;
		0;
		0;
		0;
		0;
		0];
	H = T\U;

	vo = (ZC * (H(7) - H(5)));
	Af(i) = ((RL/(RL + Z_Co))* vo)/Vin;
	Af_db(i) = 20*(log10(abs(Af(i))));
	i++;
endfor;

f=1:0.1:8;

gain = figure();
plot(f , Af_db , "r");
title("Gain in decibels");
legend("Gain");
xlabel ("log_{10} (f) [Hz]");
ylabel ("Gain [dB]");
print (gain, "gain.eps", "-depsc");