clear
clc
close all

kg = 33.3;
km = .0401;
rm = 19.2;
j1 = .0005;
j2 = .2*.2794^2;
j3 = .0015;
j = j1+j2+j3;
kptest = 20;
kdtest = 2;
Wn = sqrt((kptest.*kg*km)/(j*rm));
b= (kg^2 * km^2 + kdtest.*kg*km)/(j*rm);

num = (Wn).^2;
den = [1 b Wn.^2];
systf = tf(num, den);

t = 0:0.05:20;

freq=1/20;
offset=0;
amp=.5;
duty=50;
sq_wav=offset+amp*square(2*pi*freq.*t,duty);

lsim(systf,sq_wav,t);
grid on;
yline(.6, 'r');
yline(.525, 'g');
yline(.475, 'g');
yline(-.525, 'g');
yline(-.475, 'g')
xline(1);
xline(11);