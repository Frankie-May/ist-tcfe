%Gain Stage

Vcc=5.0;
Vee=-5.0;
%Vin = 10e-3*sin(2*pi*1e3*t);
R1=1e3;
R2=100e3;

%Low Frequency Cut

Rlcut=1e3;
Clcut=220e-9;

%High Frequency Cut

Rhcut=0.5e3;
Chcut=220e-9;


retval = 0;

function retval = transf (s)
	Rlcut=1e3;
	Clcut=220e-9;
	Rhcut=0.5e3;
	Chcut=220e-9;
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
f=logspace(0, 8, 100);
j=sqrt(-1);


%The Gain of the Gain Stage

omega_L = (1)/(Rlcut*Clcut);

omega_H = (1)/(Rhcut*Chcut);

omega_0 = sqrt(omega_L*omega_H);

Zi = (((1)/(j*omega_0*Clcut)+Rlcut)/1000);
Zo = (((1)/(j*omega_0*Chcut+(1)/(Rhcut)))/1000);


%Imput Impedance and Output Impedance for omega = omega_0

fileoutp = fopen("outputstg.tex" , "w");

fprintf(fileoutp , "OPAMP Gain & %f \\\\ \\hline \n" , (1+(R2)/(R1)));
fprintf(fileoutp , "$\\omega_L$ [rad/s] & %f \\\\ \\hline \n" , omega_L);
fprintf(fileoutp , "$\\omega_H$ [rad/s] & %f \\\\ \\hline \n" , omega_H);
fprintf(fileoutp , "$\\omega_0$ [rad/s] & %f \\\\ \\hline \n" , omega_0);
fprintf(fileoutp , "Gain ($\\omega_0$) & %f \\\\ \\hline \n" , (abs(transf (omega_0*j))));
fprintf(fileoutp , "Gain ($\\omega_0$) [dB] & %f \\\\ \\hline \n" , 20*log10 (abs(transf (omega_0*j))));
fprintf(fileoutp , "Gain ($2000\\pi$) & %f \\\\ \\hline \n" ,  (abs(transf (2000*pi()*j))));
fprintf(fileoutp , "Gain ($2000\\pi$) [dB] & %f \\\\ \\hline \n" , 20*log10 (abs(transf (2000*pi()*j))));
fprintf(fileoutp , "Input Impedance $Z_{in}$ [kOhm] & %f%+fj \\\\ \\hline \n" , real(Zi) , imag(Zi));
fprintf(fileoutp , "Input Impedance $Z_{in}$ absolute value [kOhm] & %f \\\\ \\hline \n" , abs(Zi));
fprintf(fileoutp , "Output Impedance $Z_{out}$ [kOhm] & %f%+fj \\\\ \\hline \n" , real(Zo) , imag(Zo));
fprintf(fileoutp , "Output Impedance $Z_{out}$ absolute value [kOhm] & %f \\\\ \\hline \n" , abs(Zo));
fclose (fileoutp);

while (i <= 100)
	Af(i) = 20*log10 (abs(transf (2*pi*f(i)*j)));
	PHf(i) = arg (transf (2*pi*f(i)*j));
	i++;
endwhile;

gain = figure();
semilogx(f , Af , "y");
title("Gain in decibels");
legend("Gain");
grid on;
xlabel ("log_{10} (f) [Hz]");
ylabel ("Gain [dB]");
print (gain, "gain.eps", "-depsc");

phase = figure();
semilogx(f , PHf , "c");
title("Phase in radians");
legend("Phase");
grid on;
xlabel ("log_{10} (f) [Hz]");
ylabel ("Phase [radians]");
print (phase, "phase.eps", "-depsc");

t=0:0.05:10;
vin = zeros(length(t));
vout = zeros(length(t));
Gain_0 = abs(transf (omega_0*j));
i=1;

while (i < length(t))
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
