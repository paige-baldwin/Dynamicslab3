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
kdtest = 1.5;
Wn = sqrt((kptest.*kg*km)/(j*rm));
b= (kg^2 * km^2 + kdtest.*kg*km)/(j*rm);

filename ="Group11_20_1_5";
         
[time, angle] = LCSDATA(filename);

timenew = (time - 9382468) / 1000;
anglenew = angle - .02;

num = (Wn).^2;
den = [1 b Wn.^2];
systf = tf(num, den);

t = 0:0.05:15;
tnew = t+2.5;
freq=1/(2*pi*2.5);
offset=0;
amp=.5;
duty=50;
sq_wav=offset+amp*square(2*pi*freq.*t,duty);

figure;
lsim(systf,sq_wav,tnew);
hold on;
plot(timenew, anglenew, "m")
grid on;
yline(.6, 'r');
yline(.525, 'g');
yline(.475, 'g');
yline(-.525, 'g');
yline(-.475, 'g')
xline(1);
xline(11);
legend("sim data", "expdata")

function [time, angle] = LCSDATA(filename)
    % Create a data extraction function

    test_data = readmatrix(filename); 
   
    time = test_data(:, 1);               % Proportional gain applied to the hub angle measurement (Kptheta)
    angle = test_data(:, 2);               % Proportional gain applied to the tip sensor measurement (Kpd)

end
