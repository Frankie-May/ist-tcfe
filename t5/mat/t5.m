%Variables

%Ci = 0.3u;
%Ri = 1000;
%R4 = 1k;
%R3 = 10k;
%Ro = 100;
%Co = 8E-7;

%Gain Stage

Vcc=5.0;
Vee=-5.0;
%Vin = 10e-3*sin(2*pi*1e3*t);
R1=1e3;
R2=100e3;

%Low Frequency Cut

Rlcut=100e3;
Clcut=1e-6;

%High Frequency Cut

Rhcut=1e3;
Chcut=1e-6;


retval = 0;

function retval = transf (s)
	Rlcut=100e3;
	Clcut=1e-6;
	Rhcut=1e3;
	Chcut=1e-6;
	R1=1e3;
	R2=100e3;
  retval = ((Rlcut*Clcut*s)/(1+Rlcut*Clcut*s))*(1+(R2)/(R1))*((1)/(1+Rhcut*Chcut*s));
  return;
endfunction

w = [];
f = [];
Af = zeros(100);
PHf = zeros(100);
i = 1;
w=logspace(0, 8, 100);
j=sqrt(-1);

gain = fopen("gain.tex" , "w");

%The Gain of the Gain Stage
fprintf(gain , "Gain from Gain Stage && %f\\\\\n", (1+(R2)/(R1)));
omega_L = (1)/(Rlcut*Clcut);
fprintf(gain , "$\\omega_L$ && %f [rad/s]\\\\\n", omega_L);
omega_H = (1)/(Rhcut*Chcut);
fprintf(gain , "$\\omega_H$ && %f [rad/s]\\\\\n", omega_H);
omega_0 = sqrt(omega_L*omega_H);
fprintf(gain , "$\\omega_0$ && %f [rad/s]\\\\\n", omega_0);
fprintf(gain , "Gain ($\\omega_0$) && %f [dB]\\\\\n", 20*log10 (abs(transf (omega_0*j))));

fclose (gain);

%Imput Inpeadence for omega = omega_0
theoZin = fopen("theoZin.tex" , "w");
fprintf(theoZin , "$Z_in$ && %f [Ohm]\\\\\n", (1)/(j*omega_0*Clcut)+Rlcut);
fclose(theoZin);

%Output Inpeadence for omega = omega_0

printf("Zout = %f [Ohm]\n", (1)/(j*omega_0*Chcut+(1)/(Rhcut)));

fileoutp = fopen("outputstg.tex" , "w");

fprintf(fileoutp , "The Gain of the Gain Stage & %f \\\\ \\hline \n" , (1+(R2)/(R1)));
fprintf(fileoutp , "$\omega_L$ [rad/s] & %f \\\\ \\hline \n" , omega_L);
fprintf(fileoutp , "$\omega_H$ [rad/s] & %f \\\\ \\hline \n" , omega_H);
fprintf(fileoutp , "$\omega_0$ [rad/s] & %f \\\\ \\hline \n" , omega_0);
fprintf(fileoutp , "Gain ($\omega_0$) [dB] & %f \\\\ \\hline \n" , 20*log10 (abs(transf (omega_0*j))));
fprintf(fileoutp , "Imput Inpeadence Zi [Ohm] & %f \\\\ \\hline \n" , (1)/(j*omega_0*Clcut)+Rlcut);
fprintf(fileoutp , "Output Inpeadence Zout [Ohm] & %f \\\\ \\hline \n" , (1)/(j*omega_0*Chcut+(1)/(Rhcut)));

fclose (fileoutp);

while (i <= 100)
	Af(i) = 20*log10 (abs(transf (w(i)*j)));
	PHf(i) = arg (transf (w(i)*j))*(180)/(pi);
	%printf("w(%d) = %f\n", i, w(i));
	%printf("Af(%d) = %f\n", i, Af(i));
	%printf("\n");
	i++;
endwhile;

%printf("%g\n", Af);


gain = figure();
semilogx(w , Af , "y");
title("Gain in decibels");
legend("Gain");
grid on;
xlabel ("log_{10} (w) [rad/s]");
ylabel ("Gain [dB]");
print (gain, "gain.eps", "-depsc");

phase = figure();
semilogx(w , PHf , "c");
title("Phase in degrees");
legend("Phase");
grid on;
xlabel ("log_{10} (w) [rad/s]");
ylabel ("Phase [degrees]");
print (phase, "phase.eps", "-depsc");

t=0:0.05:10;
vin = zeros(length(t));
vout = zeros(length(t));
Gain_0 = abs(transf (omega_0*j));
i=1;

while (i < length(t))
	%printf("i= %f\n", i);
	vin(i) = 10e-3*sin(2*pi*1e3*t(i)*10^-3);
	vout(i) = Gain_0*vin(i);
	i++;
endwhile;

inoutput = figure();
p1 = plot(t , vin , "b");
hold;
p2 = plot(t , vout , "g");
title("Input and Output");
h = [p1(1); p2(1)];
legend(h , "Input voltage" , "Output voltage");
grid on;
xlabel ("time [ms]");
ylabel ("Volt [V]");
print (inoutput, "inoutput.eps", "-depsc");
