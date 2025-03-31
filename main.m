clc;
clear;
close all;

%% Call LCSMODEL Function
r = 7.5;
d = 15.5;
l = 26.0;

filenames = ["Test1_5pt5V"; "Test1_6pt5V"; "Test1_7pt5V"; "Test1_8pt5V"; "Test1_9pt5V"; "Test1_10pt5V"];


figure();
for i = 1: length(filenames)
    [theta_exp, w_exp, v_exp, time] = LCSDATA(filenames(i));
    
    w = mean(w_exp) * (pi / 180);

    [v_mod] = LCSMODEL(r, d, l, theta_exp, w);
    subplot(2, 3, i);
    plot(theta_exp, v_mod, 'k-', 'LineWidth', 1);
    yline(0, 'r-', 'LineWidth', 1);
    xlim([0 2160]);
    ylim([-165 216]);
    title("Model Velocity vs. Model Angle for " + filenames(i), 'Interpreter', 'none');
    ylabel("Model Velocity (cm/s)");
    xlabel("Model Angle (deg)");
    grid on;
end

%% Call LCSDATA function

figure();
for i = 1: length(filenames)
    [theta_exp, w_exp, v_exp, time] = LCSDATA(filenames(i));

    w = w_exp .* (pi / 180);

    [v_mod] = LCSMODEL(r, d, l, theta_exp, w);

    subplot(2, 3, i);
    plot(theta_exp, v_exp, 'g-', 'LineWidth', 1);
    hold on;
    plot(theta_exp, v_mod, 'k-', 'LineWidth', 1);
    hold off;
    yline(0, 'r-', 'LineWidth', 1);
    xlim([0 2160]);
    ylim([-165 216]);
    title("Velocity vs. Angle for " + filenames(i), 'Interpreter', 'none');
    ylabel("Velocity (cm/s)");
    xlabel("Angle (deg)");
    legend('Experimental Data', 'Model');
    grid on;
end

%% Residual and Error

figure();
for i = 1: length(filenames)
    [theta_exp, w_exp, v_exp, time] = LCSDATA(filenames(i));

    w = mean(w_exp) * (pi / 180);

    [v_mod] = LCSMODEL(r, d, l, theta_exp, w);

    signed_v_diff = v_exp - v_mod;
    abs_v_diff = abs(signed_v_diff);


    % mean and stardard deviation
    average_signed(i) = mean(signed_v_diff);
    sigma_signed(i) = std(signed_v_diff);

    average_abs(i) = mean(abs_v_diff);
    sigma_abs(i) = std(abs_v_diff);

    % signed residuals plot
    subplot(2, 3, i);
    plot(time, signed_v_diff, 'r-', 'LineWidth', 1);
    yline(average_signed(i), 'k-', 'LineWidth', 1);
    ylim([-50 50]);
    title("Signed Residuals vs. Time for " + filenames(i), 'Interpreter', 'none');
    ylabel("Velocity (cm/s)");
    xlabel("Time (s)");
    legend('Signed Residuals', 'Mean');
    grid on;

end

% absolute residuals plot 
figure();
for i = 1: length(filenames)
    [theta_exp, w_exp, v_exp, time] = LCSDATA(filenames(i));

    w = mean(w_exp) * (pi / 180);

    [v_mod] = LCSMODEL(r, d, l, theta_exp, w);

    signed_v_diff = v_exp - v_mod;
    abs_v_diff = abs(signed_v_diff);

    subplot(2, 3, i);
    plot(time, abs_v_diff, 'b-', 'LineWidth', 1);
    yline(average_abs(i), 'k-', 'LineWidth', 1);
    ylim([-2 50]);
    title("Absolute Residuals vs. Time for " + filenames(i), 'Interpreter', 'none');
    ylabel("Velocity (cm/s)");
    xlabel("Time (s)");
    legend('Absolute Residuals', 'Mean');
    grid on;

end

% both residuals plot for 10.5V
figure();
plot(time, signed_v_diff, 'r-', 'LineWidth', 1);
hold on;
plot(time, abs_v_diff, 'b-', 'LineWidth', 1);
hold off;
yline(average_signed(6), 'k-', 'LineWidth', 1);
yline(average_abs(6), 'k--', 'LineWidth', 1);
ylim([-50 50]);
title("Signed and Absolute Residuals vs. Time for " + filenames(6), 'Interpreter', 'none');
ylabel("Velocity (cm/s)");
xlabel("Time (s)");
legend('Signed Residuals', 'Absolute Residuals', 'Signed Mean', 'Absolute Mean');
grid on;

% all signed residuals vs time
figure();
for i = 1: length(filenames)
    [theta_exp, w_exp, v_exp, time] = LCSDATA(filenames(i));

    w = mean(w_exp) * (pi / 180);

    [v_mod] = LCSMODEL(r, d, l, theta_exp, w);

    signed_v_diff = v_exp - v_mod;
    abs_v_diff = abs(signed_v_diff);

    plot(time, signed_v_diff, 'LineWidth', 1);
    hold on;
    title("Signed Residuals vs. Time for all Voltages");
    ylabel("Velocity (cm/s)");
    xlabel("Time (s)");
    legend(filenames(1), filenames(2), filenames(3), filenames(4), filenames(5), filenames(6), 'Interpreter', 'none');
    grid on;

end
hold off;

% all signed residuals vs theta
figure();
for i = 1: length(filenames)
    [theta_exp, w_exp, v_exp, time] = LCSDATA(filenames(i));

    w = mean(w_exp) * (pi / 180);

    [v_mod] = LCSMODEL(r, d, l, theta_exp, w);

    signed_v_diff = v_exp - v_mod;
    abs_v_diff = abs(signed_v_diff);

    plot(theta_exp, abs_v_diff, 'LineWidth', 1);
    hold on;
    xlim([0 2160]);
    title("Absolute Residuals vs. Theta for all Voltages");
    ylabel("Velocity (cm/s)");
    xlabel("Theta (deg)");
    legend(filenames(1), filenames(2), filenames(3), filenames(4), filenames(5), filenames(6), 'Interpreter', 'none');
    grid on;

end
hold off;

function [theta_exp, w_exp, v_exp, time] = LCSDATA(filename)

%% Go into the folder
addpath("Locomotive_Data_2020/");

%% Create a data extraction function

test_data = readmatrix(filename);

index1 = find(test_data(:, 3) < 1, 1, "first");
subtraction_value = test_data(index1, 2) - 152.5;
test_data(:, 2) = test_data(:, 2) - subtraction_value;

index2 = find(test_data(:, 2) >= 0, 1, "first");

index3 = find(test_data(:, 2) >= 2160, 1, "first");
test_data = test_data(index2:index3, :);

theta_exp = test_data(:, 2);
w_exp = test_data(:, 4);
v_exp = test_data(:, 5) / 10;
time = test_data(:, 1);

end

function [v_mod] = LCSMODEL(r, d, l, theta, w)
    % Derivation of angle beta with respect to distance d and angle theta
    beta = asind((d - r .* sind(theta)) / l);
    
    % Velocity model calculation
    v_mod = (-r .* w) .* (sind(theta) + (tand(beta).*cosd(theta)));
end





