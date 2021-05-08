%%AC/DC Converter

IS=1e-9;
VT=25e-3;
eta=1;

%%solve circuit with accurate model

function f = f(vD,vS,R)
Is = 1e-9;
VT=25e-3;
eta=1;
f = 17*vD+R*Is * (exp(vD/VT/eta)-1) - vS;
endfunction

function fd = fd(vD,R)
Is = 1e-9;
VT=25e-3;
eta=1;
fd = 17 + R*Is/eta/VT * (exp(vD/VT/eta)-1);
endfunction

n=0.01;
f=50;
w=2*pi*f;
t=0:1e-6: 100e-3;
A=sqrt(2)*230/n;
vS=A*sin(w*t);
vO = zeros(1,length(t));

%{
for i=1:length(t)
  vD = solve_vD  (vO(i));
  vO(i) = vS(i)-vD;
endfor

%solve circuit with ideal diode + vON + RON model
vO_ivr = zeros(1,length(t));
vON = 0.6;
RON = 80;

for i=1:length(t)
  if(vS(i) - vON >=0)
    iD = (vS(i) - vON)/(RON+R);
    vO_ivr(i) = R*iD;
  else
    iD = (vS(i) - vON)/(RON+R);
    vO_ivr(i) = -R*iD;
  endif 
endfor

figure
plot(t*1000, vO)
hold
plot(t*1000, vO_ivr)
title("Output voltage with ideal and accurate diode model")
xlabel ("t[ms]")
ylabel ("vO[V]")
legend("Accurate", "Ideal");
print ("vo_i.eps", "-depsc");

%envelope detector
vOhr = zeros(1, length(t));
vO1 = zeros(1, length(t));

tOFF = 1/w * atan(1/w/R/C);

vOnexp = A*sin(w*tOFF)*exp(-(t-tOFF)/R/C);

figure
for i=1:length(t)
  if (vS(i) > 0)
    vOhr(i) = vS(i);
  else
    vOhr(i) = 0;
  endif
endfor

plot(t*1000, vOhr)
hold

for i=1:length(t)
  if t(i) < tOFF
    vO1(i) = vS(i);
  elseif vOnexp(i) > vOhr(i)
    vO1(i) = vOnexp(i);
  else 
    vO1(i) = vS(i);
  endif
endfor

%printf("%g\n", vO1);
%printf("Separação\n");
%printf("%g\n", vOnexp);


plot(t*1000, vO1)
title("Output voltage v_o(t)")
xlabel ("t[ms]")
legend("rectified","envelope")
print ("venvlope.eps", "-depsc");

%}

%envelope detector
ne=6;
A=sqrt(2)*230/ne;
R=14e3;
C=14e-6;
t=linspace(0, 225e-3, 100e2);
f=50;
w=2*pi*f;
vS = A * cos(w*t);
vOhr = zeros(1, length(t));
vO = zeros(1, length(t));
vOexp = zeros(1, length(t));

tOFF = 1/w * atan(1/(w*R*C));

vOnexp = A*cos(w*tOFF)*exp(-(t-tOFF)/R/C);

j=1;
n=1;
for i=1:length(t)
  if  (t(i) <= n*(1/(2*f)))
    vOexp(i) = vOnexp(j);
  j=j+1;
  else
    vOexp(i) = vOnexp(1);
    j=2;
    n=n+1;
  endif
endfor

figure
for i=1:length(t)
  if (vS(i) > 0)
    vOhr(i) = vS(i);
  else
    vOhr(i) = -vS(i);
  endif
endfor

tON = 0;
i = 1;
while i < length(t)
  if (vOnexp(i) > vOhr(i) && t(i) > tOFF)
    i=i+1;
  elseif (t(i) <= tOFF)
    i=i+1;
  else
    tON = t(i);
    i=length(t);
  endif
endwhile

%printf("tOFF = %f\n", tOFF);
%printf("tON = %f\n", tON);

plot(t*1000, vOhr)
hold

j = 1;
n = 0;
for i=1:length(t)
  if t(i) < tOFF
    vO(i) = vOhr(i);
  elseif t(i) >= (j-1)*(1/(2*f))+tON && t(i) < j*(1/(2*f))+tOFF
    vO(i) = vOhr(i);
    if n == 0
      n=1;
    %printf("%f\n", j);
    endif
  elseif vOexp(i) >= vOhr(i)
    vO(i) = vOexp(i);
    if n == 1
      j=j+1;
      n=0;
    endif
  else 
    vO(i) = vOhr(i);
  endif
endfor

%%Voltage Regulator

function fvr = fvr(vD, vO)
Is = 1e-9;
VT=25e-3;
eta=1;
R=1e3;
n=17;
%fvr = n*vD-(n*Is*exp(vD/(VT*eta)))/(n*Is*exp(vD/(VT*eta))+R)*vO;
fvr = -n*vD+((n*(VT*eta)/(Is*exp(vD/(VT*eta))))/(n*(VT*eta)/(Is*exp(vD/(VT*eta)))+R))*vO;
endfunction

function fvrd = fvrd(vD, vO)
Is = 1e-9;
VT=25e-3;
eta=1;
R=1e3;
n=17;
%fvrd = n - (((n^2*Is^2*exp(2*vD/VT))/(VT)+(n*Is*R*exp(vD/VT))/(VT)-n^2*Is^2*exp((2*vD/VT)/VT))/(n*Is*exp(vD/VT)+R)^2)*vO;
fvrd = -n+(-n*(1)/(Is*exp(vD/(eta*VT)))*(n*(eta*VT)/(Is*exp(vD/(eta*VT)))+R)+n*(eta*VT)/(Is*exp(vD/(eta*VT)))*(1)/(Is*exp(vD/(eta*VT))))/((n*(eta*VT)/(Is*exp(vD/(eta*VT)))+R)^(2));
endfunction


%%Newton Raphsons iterative method

function vD_root = solve_vD (vS)
  delta = 1e-6;
  x_next = 20;


  do 
    x=x_next;
    printf("-->%f\n", x_next);
    printf("(;.;)%f\n", x);
    x_next = x  - fvr(x, vS)/fvrd(x, vS);
    printf("%f\n", x_next);
    printf("(-.-)%f\n", x);
  until (abs(x_next-x) < delta)

  vD_root = x_next;
endfunction


%%Newton Raphson Start
for i=1:length(vO)
  vD(i) = solve_vD  (vO(i));
endfor
%%Newton Raphson End

vD = 17*vD;

plot(t*1000, vD, "g");
plot(t*1000, vO);
plot(t*1000, vOnexp);
%plot(t*1000, vOexp)

title("Output voltage v_o(t)");
xlabel ("t[ms]");
ylabel ("Voltage [V]");
legend("rectified","envelope");
print ("envldetc.eps", "-depsc");
