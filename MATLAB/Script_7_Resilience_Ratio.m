% --------------------------Disclaimer-------------------------------------
% Script: CALCULATING THE RATIO BETWEEN RESILIENCES (WITH AND WITHOUT OPTIMIZATION)
% Author: Rodrigo Carneiro Curzio (rodrigo.curzio@ime.eb.br) | Date: Jan 17th 2025
% Based on: ANDRADE, Edson R. et al. Evaluating urban resilience in a disruptive radioactive event. Progress in Nuclear Energy, v. 147, p. 104218, 2022.ANDRADE, Edson R. et al. Evaluating urban resilience in a disruptive radioactive event. Progress in Nuclear Energy, v. 147, p. 104218, 2022.
% -------------------------------------------------------------------------
clear all, clc, close all

%% --- Step 1: Global parameters ------------------------------------------

% Location data
location = [0.1; 2; 4; 6; 8; 10];

% # Loading the files with the Res values

%% --- Step 2: Sample -----------------------------------------------------

% Without optimization
Res_S_Otim = load('Values_Resilience_Without_Optimization.txt');

% With optimization
Res_C_Otim = load('Values_Resilience_With_Optimization.txt');

% Calculation of the resilience ratio (with and without optimization)
ratio = Res_S_Otim ./ Res_C_Otim; % Element by element division

%% --- Step 3: Results ----------------------------------------------------
% Plotting the ratios between resiliences
figure;
hold on;

% Defining the markers for each class
classes = {'A', 'B', 'C', 'D', 'E', 'F'};
markers = {'^', 's', 'd', 'o', 'p', '*'};

for i = 1:size(ratio, 2)
    plot(location, ratio(:, i), ['k', markers{i}], 'MarkerSize', 6, ...
        'MarkerFaceColor', 'k', 'DisplayName', ['Class ', classes{i}]);
end

% Personalização do gráfico
xlabel('Distance (km) from the source term', 'FontSize', 10);
ylabel(sprintf('Ratio between Resilience\n (with and without the optimization model)'),'FontSize',10);
legend('Location', 'best', 'FontSize', 8);
grid on;
box on;
legend('Location', 'best', 'Box', 'off'); 
xlim([2 10]);
xticks(0:2:10);
hold off;
