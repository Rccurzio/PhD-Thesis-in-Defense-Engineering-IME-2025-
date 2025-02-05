% --------------------------Disclaimer-------------------------------------
% Script: ANALYSIS OF STAGE 2, CALCULATING THE INDICATORS OF THE RESILIENCE EQUATION
% Author: Rodrigo Carneiro Curzio (rodrigo.curzio@ime.eb.br) | Date: Out 20th 2024
% Based on: ANDRADE, Edson R. et al. Evaluating urban resilience in a disruptive radioactive event. Progress in Nuclear Energy, v. 147, p. 104218, 2022.
% -------------------------------------------------------------------------
clear all, clc, close all

%% --- Step 1: Global parameters -------------------------------------------
% Distance from the source term (km)
Location = [0.1; 0.5; 1.0; 2.0; 4.0; 6.0; 8.0; 10.0];

% Selecting the desired indexes: 1 (0.1), 4 (2), 5 (4), 6 (6), 7 (8), 8 (10)
selectedIndices = [1, 4, 5, 6, 7, 8];
location = Location(selectedIndices);

%% --- Step 2: Clark population gradient model
% Discrete input data
r_discrete = [0, 2, 4, 6, 8, 10];                   % Distance to urban center (km)
D_discrete = [16000, 8500, 4700, 2600, 1450, 780];  % Population density (individuals/km²)

% Function for exponential adjustment
exp_model = @(b, x) b(1) * exp(b(2) * x);

% Initial parameter estimate
b0 = [15000, -0.05]; 

% Parameter adjustment
f = nlinfit(r_discrete, D_discrete, exp_model, b0);

% Calculation of the total number of individuals affected using Clark's model
D0 = f(1);    % Population density in the center (people/km²), from Clark's model
beta = 0.2;   % Density decline rate, from Clark's model
N = (2 * D0 * pi / beta^2) .* (1 - exp(-beta * r_discrete) .* (1 + beta * r_discrete));  % Number of individuals exposed

%% --- Step 3: Calculation of Indicator I1
% ResRad Data
Infraestrutura = linspace(0, 100, 20); % Damage to critical infrastructure (%)
I1_Infra = linspace(2.5, 0, 20);       % I1 Normalized (from 2.5 to 0)

% Finding the value closest to 50% damage
[~, index_50] = min(abs(Infraestrutura - 50)); % Find the index of the value closest to 50%
I1_50 = I1_Infra(index_50);                    % Corresponding value of I1 for 50%
 
%% --- Step 4: Calculation of Indicator I2
% Clark gradient for each Location element
phi = f(1)*exp(f(2)*location);
PHI = f(1)*exp(f(2)*Location);

% TEDE (Sv) values for the different PG classes 
A_T = [8.10E+00; 3.50E-01; 9.00E-02; 2.30E-02; 6.20E-03; 2.90E-03; 1.70E-03; 1.20E-03];
B_T = [1.60E+01; 7.90E-01; 2.00E-01; 5.20E-02; 1.40E-02; 6.50E-03; 3.90E-03; 2.60E-03];
C_T = [2.70E+01; 1.80E+00; 4.70E-01; 1.30E-01; 3.90E-02; 2.00E-02; 1.30E-02; 9.20E-03];
D_T = [3.30E+01; 3.90E+00; 1.20E+00; 3.80E-01; 1.30E-01; 7.00E-02; 4.60E-02; 3.30E-02];
E_T = [9.60E+00; 8.40E+00; 2.60E+00; 7.90E-01; 2.60E-01; 1.50E-01; 9.80E-02; 7.40E-02];
F_T = [1.80E+01; 1.60E+01; 6.50E+00; 2.00E+00; 6.30E-01; 3.20E-01; 2.00E-01; 1.50E-01];
TEDE = [A_T(selectedIndices), B_T(selectedIndices), C_T(selectedIndices), D_T(selectedIndices), E_T(selectedIndices), F_T(selectedIndices)];

% I2 Indicator for each PG Class (# Specific indices)
I2_A = 1./(phi.*A_T(selectedIndices));
I2_B = 1./(phi.*B_T(selectedIndices));
I2_C = 1./(phi.*C_T(selectedIndices));
I2_D = 1./(phi.*D_T(selectedIndices));
I2_E = 1./(phi.*E_T(selectedIndices));
I2_F = 1./(phi.*F_T(selectedIndices));

% Normalization of I2 - 0 to 2.5 by class (# Specific indices)
I2_A_norm = (I2_A / max(I2_A)) * 2.5;
I2_B_norm = (I2_B / max(I2_B)) * 2.5;
I2_C_norm = (I2_C / max(I2_C)) * 2.5;
I2_D_norm = (I2_D / max(I2_D)) * 2.5;
I2_E_norm = (I2_E / max(I2_E)) * 2.5;
I2_F_norm = (I2_F / max(I2_F)) * 2.5;

% I2 Indicator for each PG Class (# All indices)
I2_A_R = 1./(PHI.*A_T);
I2_B_R = 1./(PHI.*B_T);
I2_C_R = 1./(PHI.*C_T);
I2_D_R = 1./(PHI.*D_T);
I2_E_R = 1./(PHI.*E_T);
I2_F_R = 1./(PHI.*F_T);
 
% Normalization of I2 - 0 to 2.5 by class (# All indices)
I2_A_norm_R = (I2_A_R / max(I2_A_R)) * 2.5;
I2_B_norm_R = (I2_B_R / max(I2_B_R)) * 2.5;
I2_C_norm_R = (I2_C_R / max(I2_C_R)) * 2.5;
I2_D_norm_R = (I2_D_R / max(I2_D_R)) * 2.5;
I2_E_norm_R = (I2_E_R / max(I2_E_R)) * 2.5;
I2_F_norm_R = (I2_F_R / max(I2_F_R)) * 2.5;

% Grouping the I2 of each class into a matrix
I2_norm = (1 ./ (phi .* TEDE)) ./ max(1 ./ (phi .* TEDE)) * 2.5;

%% --- Step 5: Calculation of Indicator I3
% Vector of PG Classes
classe = {'A', 'B', 'C', 'D', 'E', 'F'};

% Population potentially affected (sigma x plume area) - HotSpot input data
area_700mSv = [3.40E-02, 5.50E-02, 8.70E-02, 1.70E-01, 3.00E-01, 5.90E-01];
area_100mSv = [2.40E-01, 3.90E-01, 6.70E-01, 1.80E+00, 3.30E+00, 5.40E+00];
area_50mSv =  [4.80E-01, 7.80E-01, 1.40E+00, 4.20E+00, 8.30E+00, 1.10E+01];

% Standard density of large urban centers (people/km²)
sigma = 10000;

% Population potentially affected in exclusion zones
msv700 = sigma*area_700mSv;
msv100 = sigma*area_100mSv;
msv50 =  sigma*area_50mSv;

% Adding up the values for 700 mSv and 100 mSv for each class
soma_700_100 = abs(msv700 + msv100);

% Indicator I3
I3 = 1./soma_700_100;

% Normalizing I3 (0 to 2.5)
I3_norm = (I3 - min(I3))/ (max(I3) - min(I3)) * 2.5;

%% --- Step 6: Calculation of Indicator I4
% ERR data - Male Gender
MA = [1.17E+03, 1.25E+01, 6.21E-01, 1.50E-01, 3.99E-02, 1.86E-02, 1.09E-02, 7.68E-03];
MB = [4.34E+03, 2.69E+01, 9.07E+00, 3.48E-01, 9.06E-02, 4.18E-02, 2.50E-02, 1.67E-02];
MC = [1.21E+04, 8.34E+01, 1.59E+01, 9.25E-01, 2.58E-01, 1.30E-01, 8.41E-02, 5.93E-02];
MD = [1.79E+04, 3.06E+02, 4.59E+01, 1.33E+01, 7.69E+00, 4.75E-01, 3.06E-01, 2.17E-01];
ME = [1.62E+03, 1.26E+03, 1.51E+02, 2.69E+01, 1.04E+01, 8.07E+00, 6.80E-01, 5.04E-01];
MF = [5.46E+03, 4.34E+03, 7.77E+02, 9.85E+01, 2.10E+01, 1.18E+01, 9.07E+00, 8.07E+00];

% ERR data - Female Gender
FA = [8.36E+02; 8.93E+00; 4.82E-01; 1.16E-01; 3.10E-02; 1.44E-02; 8.45E-03; 5.97E-03];
FB = [3.09E+03; 1.92E+01; 6.45E+00; 2.70E-01; 7.04E-02; 3.25E-02; 1.94E-02; 1.29E-02];
FC = [8.60E+03; 5.94E+01; 1.13E+01; 5.47E+00; 2.00E-01; 1.01E-01; 6.53E-02; 4.61E-02];
FD = [1.28E+04; 2.18E+02; 3.27E+01; 9.49E+00; 5.47E+00; 3.69E-01; 2.38E-01; 1.69E-01];
FE = [1.15E+03; 8.96E+02; 1.08E+02; 1.92E+01; 7.38E+00; 5.74E+00; 5.28E-01; 3.91E-01];
FF = [3.89E+03; 3.09E+03; 5.53E+02; 7.01E+01; 1.49E+01; 8.39E+00; 6.45E+00; 5.74E+00];

% Indicator I4 (Male) for each PG Class
I4_A = 1./(MA);
I4_B = 1./(MB);
I4_C = 1./(MC);
I4_D = 1./(MD);
I4_E = 1./(ME);
I4_F = 1./(MF);

% Indicator I4 (Female) for each PG Class
FI4_A = 1./(FA);
FI4_B = 1./(FB);
FI4_C = 1./(FC);
FI4_D = 1./(FD);
FI4_E = 1./(FE);
FI4_F = 1./(FF);

% Normalizing I4 (Male) (0 to 2.5)
I4_A_norm = (I4_A / max(I4_A)) * 2.5;
I4_B_norm = (I4_B / max(I4_B)) * 2.5;
I4_C_norm = (I4_C / max(I4_C)) * 2.5;
I4_D_norm = (I4_D / max(I4_D)) * 2.5;
I4_E_norm = (I4_E / max(I4_E)) * 2.5;
I4_F_norm = (I4_F / max(I4_F)) * 2.5;

% Normalization of I4 (Female) (0 to 2.5)
FI4_A_norm = (FI4_A / max(FI4_A)) * 2.5;
FI4_B_norm = (FI4_B / max(FI4_B)) * 2.5;
FI4_C_norm = (FI4_C / max(FI4_C)) * 2.5;
FI4_D_norm = (FI4_D / max(FI4_D)) * 2.5;
FI4_E_norm = (FI4_E / max(FI4_E)) * 2.5;
FI4_F_norm = (FI4_F / max(FI4_F)) * 2.5;

% Selection (Male) of points of interest (0,1; 2; 4; 6; 8; 10)
I4_A_norms = I4_A_norm(selectedIndices);
I4_B_norms = I4_B_norm(selectedIndices);
I4_C_norms = I4_C_norm(selectedIndices);
I4_D_norms = I4_D_norm(selectedIndices);
I4_E_norms = I4_E_norm(selectedIndices);
I4_F_norms = I4_F_norm(selectedIndices);

% Selection (Female) of points of interest (0,1; 2; 4; 6; 8; 10)
FI4_A_norms = FI4_A_norm(selectedIndices);
FI4_B_norms = FI4_B_norm(selectedIndices);
FI4_C_norms = FI4_C_norm(selectedIndices);
FI4_D_norms = FI4_D_norm(selectedIndices);
FI4_E_norms = FI4_E_norm(selectedIndices);
FI4_F_norms = FI4_F_norm(selectedIndices);

%% --- Step 7: Resilience Calculation (Res)
% Indicator I1 considering 50% damage to critical infrastructure
I1_norm = I1_Infra(1,10)*ones(1,length(I2_A_norm_R));

% Res calculation by PG class
Res_A = I1_norm + I2_A_norm_R' + I3_norm(1)*ones(1,length(I2_A_norm_R)) + I4_A_norm;
Res_B = I1_norm + I2_B_norm_R' + I3_norm(2)*ones(1,length(I2_A_norm_R)) + I4_B_norm;
Res_C = I1_norm + I2_C_norm_R' + I3_norm(3)*ones(1,length(I2_A_norm_R)) + I4_C_norm;
Res_D = I1_norm + I2_D_norm_R' + I3_norm(4)*ones(1,length(I2_A_norm_R)) + I4_D_norm;
Res_E = I1_norm + I2_E_norm_R' + I3_norm(5)*ones(1,length(I2_A_norm_R)) + I4_E_norm;
Res_F = I1_norm + I2_F_norm_R' + I3_norm(6)*ones(1,length(I2_A_norm_R)) + I4_F_norm;

% Extracting the values corresponding to the selected key figures
Res_A = Res_A(selectedIndices);
Res_B = Res_B(selectedIndices);
Res_C = Res_C(selectedIndices);
Res_D = Res_D(selectedIndices);
Res_E = Res_E(selectedIndices);
Res_F = Res_F(selectedIndices);

% Normalizing I4 (0 to 2.5)
Res_A_norm = (Res_A - min(Res_A))/(max(Res_A)- min(Res_A)) * 2.5;
Res_B_norm = (Res_B - min(Res_B))/(max(Res_B)- min(Res_B)) * 2.5;
Res_C_norm = (Res_C - min(Res_C))/(max(Res_C)- min(Res_C)) * 2.5;
Res_D_norm = (Res_D - min(Res_D))/(max(Res_D)- min(Res_D)) * 2.5;
Res_E_norm = (Res_E - min(Res_E))/(max(Res_E)- min(Res_E)) * 2.5;
Res_F_norm = (Res_F - min(Res_F))/(max(Res_F)- min(Res_F)) * 2.5;

%% --- Step 8: Command to save output files
% 1) Resilience data
% Unique file name for all classes
filename = 'Values_Resilience_Without_Optimization.txt';

% Opening the file for writing
fileID = fopen(filename, 'w');

% Class data
Res_values = [Res_A_norm; Res_B_norm; Res_C_norm; Res_D_norm; Res_E_norm; Res_F_norm]';

% Writing the data to the file
for i = 1:length(location)
    fprintf(fileID, '%.6f\t', Res_values(i, :)); % Escreve as resiliências para todas as classes
    fprintf(fileID, '\n');
end

% Closing the file
fclose(fileID);

% Confirmation message in the Command Window
disp(['All resiliences have been saved in the file: ', filename]);

% 2) Indicators
% # Saving Normalized I1 values (All PG Class) in a txt file
filename = 'I1_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I1_norm);
fclose(fileID);

% # Saving Normalized I2 values (A PG Class) in a txt file
filename = 'I2_A_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I2_A_norm);
fclose(fileID);

% Saving Normalized I2 values (B PG Class) in a txt file
filename = 'I2_B_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I2_B_norm);
fclose(fileID);

% Saving Normalized I2 values (C PG Class) in a txt file
filename = 'I2_C_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I2_C_norm);
fclose(fileID);

% Saving Normalized I2 values (D PG Class) in a txt file
filename = 'I2_D_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I2_D_norm);
fclose(fileID);

% Saving Normalized I2 values (E PG Class) in a txt file
filename = 'I2_E_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I2_E_norm);
fclose(fileID);

% Saving Normalized I2 values (F PG Class) in a txt file
filename = 'I2_F_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I2_F_norm);
fclose(fileID);

% # Saving Normalized I3 values (All PG Class) in a txt file
filename = 'I3_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I3_norm);
fclose(fileID);

% # Saving Normalized I4 values (A PG Class) in a txt file
filename = 'I4_A_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I4_A_norm);
fclose(fileID);

% Saving Normalized I4 values (B PG Class) in a txt file
filename = 'I4_B_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I4_B_norm);
fclose(fileID);

% Saving Normalized I4 values (C PG Class) in a txt file
filename = 'I4_C_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I4_C_norm);
fclose(fileID);

% Saving Normalized I4 values (D PG Class) in a txt file
filename = 'I4_D_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I4_D_norm);
fclose(fileID);

% Saving Normalized I4 values (E PG Class) in a txt file
filename = 'I4_E_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I4_E_norm);
fclose(fileID);

% Saving Normalized I4 values (F PG Class) in a txt file
filename = 'I4_F_norm.txt';
fileID = fopen(filename, 'w');
fprintf(fileID, '%.6f\n', I4_F_norm);
fclose(fileID);

%% --- Step 8: Results
% # Clark model graph
figure;
hold on;
    plot(r_discrete, D_discrete, 'k--^', 'MarkerSize', 8, 'DisplayName', '\Theta(x) (Pontos discretos)','MarkerFaceColor','k')
    equation_text = sprintf('\\Theta(x) = %.2f e^{%.2f x}', f(1), f(2));
    text(3, 10000, equation_text, 'FontSize', 12, 'BackgroundColor', 'none', 'EdgeColor', 'none'); % Display the fitting equation on the graph without a frame
    legend('Location', 'best', 'Box', 'off'); 
    box on
    grid on
    xlabel('Distance (km) from the source term');
    ylabel('Population density (individuals/km²)');
    set(gca, 'XTick', 0:2:10); % Sets the x-axis ticks from 0 to 10 with an interval of 
hold off;

% # Graph of the number of individuals affected
figure;
    plot(r_discrete, N, 'k-d', 'LineWidth', 1,'MarkerFaceColor','k','MarkerEdgeColor','k');
    xlabel('Distance (km) from the source term');
    ylabel('Individuals');
    title('Number of individuals affected by the plume');
    grid on;
    set(gca, 'XTick', 0:2:10);

% # Graph of Indicator I1
figure;
plot(Infraestrutura, I1_Infra, 'k^', 'MarkerFaceColor', 'k'); % Black marker style
hold on;

% Marking the point corresponding to 50% damage to the infrastructure
plot(Infraestrutura(index_50), I1_50, 'ro', 'MarkerSize', 10, 'LineWidth', 2); % Red marker for the point at 50%

% Adding text to the graphico
text(Infraestrutura(index_50), I1_50, sprintf(' (%d%%, %.2f)', 50, I1_50), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');

xlabel('Damage to critical infrastructure (%)');
ylabel('Indicator I_1');
grid on;

% Adjusting the axis limits
xlim([0 100]);
ylim([0 2.5]);

% # Graph of Indicator I2
figure
classes = {'A', 'B', 'C', 'D', 'E', 'F'};
markers = {'^', 'o', 's', 'd', 'p', 'h'}; % Different types of markers

% Non-normalized I2
for i = 1:length(classes)
    marker = markers{i};         
    semilogy(location, 1 ./ (phi .* TEDE(:, i)), '--k', 'Marker', marker, 'LineStyle', 'none', 'Color', 'k', 'MarkerFaceColor', 'k', 'DisplayName', ['Classe ', classes{i}]); hold on;
end

xlabel('Distance (km) from the source term');
ylabel('(\Theta (x) x TEDE)^-1');
grid on;
xlim([0 10]);
xticks(0:2:10);
legend('Location', 'best', 'Box', 'off');

% Normalized I2
figure;
for i = 1:length(classes)
    marker = markers{i}; 
    scatter(location, I2_norm(:, i), ' k', 'Marker', marker, 'MarkerFaceColor', 'k', 'DisplayName', ['Classe ', classes{i}]); hold on
    box on;
    grid on
end

xlabel('Distance (km) from the source term');
ylabel('Indicador I_2');
grid on;
xlim([0 10]);
xticks(0:2:10);
legend('A Class', 'B Class', 'C Class', 'D Class', 'E Class', 'F Class');;
legend('Location', 'northeast', 'Box', 'off'); 

% # Graph of Indicator I3
figure;
plot(1:6, I3, 'k^', 'LineWidth', 1.0, 'MarkerFaceColor','K');
xticks(1:6);            % Defines the positions on the x-axis
xticklabels(classe);    % Places the class labels on the x-axis
xlabel('PG Class');
ylabel('(\sigma x plume area)^-1 x 10^-4');
grid on;

figure;
plot(1:6, I3_norm, 'k^', 'LineWidth', 1.0, 'MarkerFaceColor', 'K');
xticks(1:6);         % Defines the positions on the x-axis
xticklabels(classe); % Places the class labels on the x-axis
xlabel('Classe de PG');
ylabel('Indicador I_3');
grid on;

% # Graph of Indicator I4 (Non-Normalized) (Male Gender)
figure;
semilogy(location, I4_A(selectedIndices), 'k^', 'LineWidth', 1.0, 'MarkerFaceColor','k'); hold on
semilogy(location, I4_B(selectedIndices), 'kd', 'LineWidth', 1.0, 'MarkerFaceColor','k');
semilogy(location, I4_C(selectedIndices), 'k*', 'LineWidth', 1.0, 'MarkerFaceColor','k');
semilogy(location, I4_D(selectedIndices), 'ko', 'LineWidth', 1.0, 'MarkerFaceColor','k');
semilogy(location, I4_E(selectedIndices), 'ks', 'LineWidth', 1.0, 'MarkerFaceColor','k');
semilogy(location, I4_F(selectedIndices), 'kh', 'LineWidth', 1.0, 'MarkerFaceColor','k');
xlabel('Distance (km) from the source term');
ylabel('(ERR)^-1');
grid on;
legend('A Class', 'B Class', 'C Class', 'D Class', 'E Class', 'F Class');
legend('Location', 'northwest', 'Box', 'off');

% # Graph of Indicator I4 (Normalized) (Male Gender)
figure;
plot(location, I4_A_norms, 'k^', 'LineWidth', 1.0, 'MarkerFaceColor','k'); hold on
plot(location, I4_B_norms, 'kd', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, I4_C_norms, 'k*', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, I4_D_norms, 'ko', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, I4_E_norms, 'ks', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, I4_F_norms, 'kh', 'LineWidth', 1.0, 'MarkerFaceColor','k');
xlabel('Distance (km) from the source term');
ylabel('Indicator I_4 (Male Gender)');
grid on;
xlim([0 10]);
xticks(0:2:10); 
legend('A Class', 'B Class', 'C Class', 'D Class', 'E Class', 'F Class');
legend('Location', 'bestoutside', 'Box', 'off');

% # Graph of Indicator I4 (Normalized) (Female Gender)
figure;
plot(location, FI4_A_norms, 'k^', 'LineWidth', 1.0, 'MarkerFaceColor','k'); hold on
plot(location, FI4_B_norms, 'kd', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, FI4_C_norms, 'k*', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, FI4_D_norms, 'ko', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, FI4_E_norms, 'ks', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, FI4_F_norms, 'kh', 'LineWidth', 1.0, 'MarkerFaceColor','k');
xlabel('Distance (km) from the source term');
ylabel('Indicator I_4 (Female Gender)');
grid on;
xlim([0 10]);
xticks(0:2:10); 
legend('A Class', 'B Class', 'C Class', 'D Class', 'E Class', 'F Class');
legend('Location', 'bestoutside', 'Box', 'off');

% # Graph of Non-normalized Resilience
figure;
plot(location, Res_A, 'k^', 'LineWidth', 1.0, 'MarkerFaceColor','k'); hold on
plot(location, Res_B, 'kd', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, Res_C, 'k*', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, Res_D, 'ko', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, Res_E, 'ks', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, Res_F, 'kh', 'LineWidth', 1.0, 'MarkerFaceColor','k');
xlabel('Distance (km) from the source term');
ylabel(sprintf('R_{es} (Male e Femlae)\n all PG Classes'));
grid on;
xlim([0 10]);
xticks(0:2:10);
legend('A Class', 'B Class', 'C Class', 'D Class', 'E Class', 'F Class');
legend('Location', 'northwest', 'Box', 'off'); 

% # Graph of Normalized Resilience
figure;
plot(location, Res_A_norm, 'k^', 'LineWidth', 1.0, 'MarkerFaceColor','k'); hold on
plot(location, Res_B_norm, 'kd', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, Res_C_norm, 'k*', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, Res_D_norm, 'ko', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, Res_E_norm, 'ks', 'LineWidth', 1.0, 'MarkerFaceColor','k');
plot(location, Res_F_norm, 'kh', 'LineWidth', 1.0, 'MarkerFaceColor','k');
xlabel('Distance (km) from the source term');
ylabel(sprintf('R_{es} (Male e Femlae)\n all PG Classes'));
grid on;
xlim([0 10]);   % Setting the X axis from 0 to 10 with intervals of 2
xticks(0:2:10); % Sets the intervals every 2
legend('A Class', 'B Class', 'C Class', 'D Class', 'E Class', 'F Class');
legend('Location', 'northwest', 'Box', 'off'); 
