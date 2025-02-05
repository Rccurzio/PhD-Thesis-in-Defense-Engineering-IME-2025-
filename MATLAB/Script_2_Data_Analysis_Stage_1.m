% --------------------------Disclaimer-------------------------------------
% ANALYSIS OF PHASE 2, STAGE 1, OFF-SITE RELEASE
% Author: Rodrigo Carneiro Curzio (rodrigo.curzio@ime.eb.br) | Date: Set 15th 2024
% Based on: HOMANN, Steven G. HotSpot health physics codes. Lawrence Livermore National Laboratory (LLNL), Livermore, CA (United States), 2010.
% -------------------------------------------------------------------------
clear all, clc, close all

%% --- Step 1: Global parameters ------------------------------------------
% Distance from the source term (km)
Location = [0.1; 0.5; 1.0; 2.0; 4.0; 6.0; 8.0; 10.0];

% Selecionando os índices desejados: 1 (0.1), 4 (2), 5 (4), 6 (6), 7 (8), 8 (10)
selectedIndices = [1, 4, 5, 6, 7, 8];
location = Location(selectedIndices);

%% --- Step 2: Sample -----------------------------------------------------
% TEDE (Sv) values for the different PG classes 
A_T = [8.10E+00; 3.50E-01; 9.00E-02; 2.30E-02; 6.20E-03; 2.90E-03; 1.70E-03; 1.20E-03];
B_T = [1.60E+01; 7.90E-01; 2.00E-01; 5.20E-02; 1.40E-02; 6.50E-03; 3.90E-03; 2.60E-03];
C_T = [2.70E+01; 1.80E+00; 4.70E-01; 1.30E-01; 3.90E-02; 2.00E-02; 1.30E-02; 9.20E-03];
D_T = [3.30E+01; 3.90E+00; 1.20E+00; 3.80E-01; 1.30E-01; 7.00E-02; 4.60E-02; 3.30E-02];
E_T = [9.60E+00; 8.40E+00; 2.60E+00; 7.90E-01; 2.60E-01; 1.50E-01; 9.80E-02; 7.40E-02];
F_T = [1.80E+01; 1.60E+01; 6.50E+00; 2.00E+00; 6.30E-01; 3.20E-01; 2.00E-01; 1.50E-01];

% Ground Shine (Sv/h) values for the different PG classes 
A_G = [1.40E-02; 6.00E-04; 1.50E-04; 4.00E-05; 1.10E-05; 5.00E-06; 3.00E-06; 2.00E-06];
B_G = [2.80E-02; 1.40E-03; 3.40E-04; 8.90E-05; 2.40E-05; 1.10E-05; 6.60E-06; 4.40E-06];
C_G = [4.60E-02; 3.10E-03; 8.10E-04; 2.20E-04; 6.70E-05; 3.40E-05; 2.20E-05; 1.60E-05];
D_G = [5.50E-02; 6.80E-03; 2.10E-03; 6.60E-04; 2.20E-04; 1.20E-04; 7.80E-05; 5.70E-05];
E_G = [9.40E-03; 1.40E-02; 4.40E-03; 1.40E-03; 4.50E-04; 2.50E-04; 1.70E-04; 1.30E-04];
F_G = [2.93E-02; 2.60E-02; 1.10E-02; 3.50E-03; 1.10E-03; 5.50E-04; 3.50E-04; 2.50E-04];

% Ground Surface (kBq/m²) values for the different PG classes 
A_S = [7.00E+06; 3.00E+05; 7.70E+04; 2.00E+04; 5.30E+03; 2.50E+03; 1.50E+03; 1.00E+03];
B_S = [1.40E+07; 6.80E+05; 1.70E+05; 4.40E+04; 1.20E+04; 5.60E+03; 3.30E+03; 2.20E+03];
C_S = [2.30E+07; 1.50E+06; 4.10E+05; 1.10E+05; 3.30E+04; 1.70E+04; 1.10E+04; 7.90E+03];
D_S = [2.70E+07; 3.40E+06; 1.00E+06; 3.30E+05; 1.10E+05; 6.00E+04; 3.90E+04; 2.90E+04];
E_S = [4.70E+06; 7.20E+06; 2.20E+06; 6.80E+05; 2.30E+05; 1.20E+05; 8.40E+04; 6.30E+04];
F_S = [1.46E+07; 1.30E+07; 5.60E+06; 1.70E+06; 5.40E+05; 2.70E+05; 1.80E+05; 1.30E+05];

% Arrival Time da Pluma (min) values for the different PG classes 
A_AT = [1.00; 8.00; 16.00; 33.00; 67.00; 101.00; 135.00; 169.00]; % A Class
B_AT = [1.00; 8.00; 16.00; 33.00; 67.00; 101.00; 135.00; 169.00]; % B Class
C_AT = [1.00; 8.00; 17.00; 34.00; 68.00; 102.00; 136.00; 170.00]; % C Class
D_AT = [1.00; 8.00; 17.00; 34.00; 68.00; 103.00; 137.00; 172.00]; % D Class
E_AT = [1.00; 9.00; 18.00; 36.00; 72.00; 108.00; 144.00; 180.00]; % E Class
F_AT = [1.00; 9.00; 18.00; 37.00; 75.00; 113.00; 150.00; 188.00]; % F Class

% Area (km²) of the radioactive plumes for the different PG classes
classes_Pasquill = {'A', 'B', 'C', 'D', 'E', 'F'};
x = 1:length(classes_Pasquill); % Numeric x-axis corresponding to the classes
area_700mSv = [3.40E-02, 5.50E-02, 8.70E-02, 1.70E-01, 3.00E-01, 5.90E-01];
area_100mSv = [2.40E-01, 3.90E-01, 6.70E-01, 1.80E+00, 3.30E+00, 5.40E+00];
area_50mSv  = [4.80E-01, 7.80E-01, 1.40E+00, 4.20E+00, 8.30E+00, 1.10E+01];

% Distances at which TEDE is maximum
max_dist = [0.027; 0.045; 0.068; 0.094; 0.19; 0.35];

% Maximum TEDE values
max_TEDE = [4.20E+01; 3.50E+01;3.40E+01; 3.30E+01; 2.30E+01; 1.80E+01];

% Plume velocity for different PG classes
vel_pluma = [2.4;2.25;2.12;1.9;1.6;1.2];

% Isodoses Curves for different PG classes
inner  =  [0.35, 0.53, 0.81, 1.4, 2.2, 3.7];
middle =  [0.94, 1.4, 2.3, 4.7, 7.9, 12];
outer  =  [1.3, 2, 3.4, 7.5, 13, 17];

% Excess Relative Risk (ERR) for different PG classes - Male Gender
MA = [1.17E+03, 1.25E+01, 6.21E-01, 1.50E-01, 3.99E-02, 1.86E-02, 1.09E-02, 7.68E-03];
MB = [4.34E+03, 2.69E+01, 9.07E+00, 3.48E-01, 9.06E-02, 4.18E-02, 2.50E-02, 1.67E-02];
MC = [1.21E+04, 8.34E+01, 1.59E+01, 9.25E-01, 2.58E-01, 1.30E-01, 8.41E-02, 5.93E-02];
MD = [1.79E+04, 3.06E+02, 4.59E+01, 1.33E+01, 7.69E+00, 4.75E-01, 3.06E-01, 2.17E-01];
ME = [1.62E+03, 1.26E+03, 1.51E+02, 2.69E+01, 1.04E+01, 8.07E+00, 6.80E-01, 5.04E-01];
MF = [5.46E+03, 4.34E+03, 7.77E+02, 9.85E+01, 2.10E+01, 1.18E+01, 9.07E+00, 8.07E+00];

% Excess Relative Risk (ERR) for different PG classes - Female Gender
FA = [8.36E+02, 8.93E+00, 4.82E-01, 1.16E-01, 3.10E-02, 1.44E-02, 8.45E-03, 5.97E-03];
FB = [3.09E+03, 1.92E+01, 6.45E+00, 2.70E-01, 7.04E-02, 3.25E-02, 1.94E-02, 1.29E-02];
FC = [8.60E+03, 5.94E+01, 1.13E+01, 5.47E+00, 2.00E-01, 1.01E-01, 6.53E-02, 4.61E-02];
FD = [1.28E+04, 2.18E+02, 3.27E+01, 9.49E+00, 5.47E+00, 3.69E-01, 2.38E-01, 1.69E-01];
FE = [1.15E+03, 8.96E+02, 1.08E+02, 1.92E+01, 7.38E+00, 5.74E+00, 5.28E-01, 3.91E-01];
FF = [3.89E+03, 3.09E+03, 5.53E+02, 7.01E+01, 1.49E+01, 8.39E+00, 6.45E+00, 5.74E+00];

%% --- Step 3: Results -----------------------------------------------------

% 1) TEDE (Sv)
% semilogy graph
figure;
semilogy(location, A_T(selectedIndices), '-ko', 'DisplayName', 'A Class');
hold on;
semilogy(location, B_T(selectedIndices), '-ks', 'DisplayName', 'B Class');
semilogy(location, C_T(selectedIndices), '-k^', 'DisplayName', 'C Class');
semilogy(location, D_T(selectedIndices), '-kd', 'DisplayName', 'D Class');
semilogy(location, E_T(selectedIndices), '-kp', 'DisplayName', 'E Class');
semilogy(location, F_T(selectedIndices), '-kh', 'DisplayName', 'F Class');
hold off;

% chart settings 
xlabel('Distance (km) from the source term');
ylabel('TEDE (Sv)');
legend("show",'Box','off');
grid on;
xlim([0 10]);
xticks(0:2:10); 

% 2) Ground Shine (Sv/h)
% Semilogy graph 
figure
semilogy(location, A_G(selectedIndices), '-ko', 'DisplayName', 'A Class');
hold on;
semilogy(location, B_G(selectedIndices), '-ks', 'DisplayName', 'B Class');
semilogy(location, C_G(selectedIndices), '-k^', 'DisplayName', 'C Class');
semilogy(location, D_G(selectedIndices), '-kd', 'DisplayName', 'D Class');
semilogy(location, E_G(selectedIndices), '-kp', 'DisplayName', 'E Class');
semilogy(location, F_G(selectedIndices), '-kh', 'DisplayName', 'F Class');
hold off;

% Chart settings
xlabel('Distance (km) from the source term');
ylabel('Ground Shine (Sv/h)');
legend("show",'Box','off')
grid on;
xlim([0 10]);
xticks(0:2:10);

% 3) Ground Surface (kBq/m²)
% Semilogy graph 
figure
semilogy(location, A_S(selectedIndices), '-ko', 'DisplayName', 'A Class');
hold on;
semilogy(location, B_S(selectedIndices), '-ks', 'DisplayName', 'B Class');
semilogy(location, C_S(selectedIndices), '-k^', 'DisplayName', 'C Class');
semilogy(location, D_S(selectedIndices), '-kd', 'DisplayName', 'D Class');
semilogy(location, E_S(selectedIndices), '-kp', 'DisplayName', 'E Class');
semilogy(location, F_S(selectedIndices), '-kh', 'DisplayName', 'F Class');
hold off;

% Chart settings
xlabel('Distance (km) from the source term');
ylabel('Fallout (kBq/m²)');
legend("show",'Box','off')
grid on;
xlim([0 10]);
xticks(0:2:10);

% 4) Plume Arrival Time (min)
% Graph
figure;
plot(location, A_AT(selectedIndices), 'ko', 'DisplayName', 'A Class');
hold on;
plot(location, B_AT(selectedIndices), 'ks', 'DisplayName', 'B Class');
plot(location, C_AT(selectedIndices), 'k^', 'DisplayName', 'C Class');
plot(location, D_AT(selectedIndices), 'kd', 'DisplayName', 'D Class');
plot(location, E_AT(selectedIndices), 'kp', 'DisplayName', 'E Class');
plot(location, F_AT(selectedIndices), 'kh', 'DisplayName', 'F Class');
hold off;

% Chart settings
xlabel('Distance (km) from the source term');
ylabel('Plume arrival time (min)');
legend("show",'Box','off','Location','best') 
grid on;
xlim([0 10]);
xticks(0:2:10);

% 5) Plume Area  (km²)
% Graph
figure;
plot(x, area_700mSv, 'ko', 'DisplayName', '700 mSv','LineWidth',1.5,'MarkerFaceColor','k');
hold on;
plot(x, area_100mSv, 'ks', 'DisplayName', '100 mSv','LineWidth',1.5,'MarkerFaceColor','k');
hold on;
plot(x, area_50mSv, 'k^', 'DisplayName', '50 mSv','LineWidth',1.5,'MarkerFaceColor','k');
hold on;
hold off;

% Adjusting the x-axis to show the Pasquill-Gifford classes
set(gca, 'XTick', x, 'XTickLabel', classes_Pasquill);

% Chart settings
xlabel('Pasquill-Gifford Classes');
ylabel('Plume area (km²)');
legend('Location', 'best', 'Box', 'off'); 
grid on;

% 6) Maximum TEDE (Sv) 
% Graph 
figure;
plot(x, max_TEDE, 'k^','LineWidth',1.5,'MarkerFaceColor','k');

% Adjusting the x-axis to show Pasquill-Gifford classes
set(gca, 'XTick', x, 'XTickLabel', classes_Pasquill);

% Chart settings
xlabel('Pasquill-Gifford Classes');
ylabel('Maximum TEDE');
grid on;

% 7) Plume Velocity (m/s)
% Graph
figure;
plot(x, vel_pluma, 'kd','LineWidth',1.5','MarkerFaceColor','k');

% Adjusting the x-axis to show Pasquill-Gifford classes
set(gca, 'XTick', x, 'XTickLabel', classes_Pasquill);

% Chart settings
xlabel('Pasquill-Gifford Classes');
ylabel('Velocity (m/s)');
grid on;

% 8) Distance where TEDE is maximum (km)
% Graph
figure;
plot(x, max_dist*1000, 'k^','LineWidth',1.5','MarkerFaceColor','k');

% Adjusting the x-axis to show Pasquill-Gifford classes
set(gca, 'XTick', x, 'XTickLabel', classes_Pasquill);

% Chart settings
xlabel('Pasquill-Gifford Classes');
ylabel('Distance (m) from the source term');
grid on;

% 9) Contours of isodoses (TEDE-Sv)
% Graph
figure;
hold on;
plot(x, inner, 'k^', 'DisplayName', '700 mSv', 'LineWidth', 2,'MarkerFaceColor','k');
plot(x, middle, 'ks', 'DisplayName', '100 mSv', 'LineWidth', 2,'MarkerFaceColor','k');
plot(x, outer, 'kd', 'DisplayName', '50 mSv', 'LineWidth', 2,'MarkerFaceColor','k');
xlabel('Pasquill-Gifford Classes');
ylabel('Distance (km)');

% Add labels to classes on the x-axis
set(gca, 'XTick', x, 'XTickLabel', classes_Pasquill);

% Add a caption
legend('Location', 'best', 'Box', 'off'); 

% Add a grid
grid on;

% Adjusting the y-axis limits
ylim([0 20]);
box on

hold off;

% 10) ERR Male 
% Graph
figure;
semilogy(location, MA(selectedIndices), 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'A Class'); hold on;
semilogy(location, MB(selectedIndices), '^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'B Class');
semilogy(location, MC(selectedIndices), 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'C Class');
semilogy(location, MD(selectedIndices), '*', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'D Class');
semilogy(location, ME(selectedIndices), 'd', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'E Class');
semilogy(location, MF(selectedIndices), '+', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'F Class');

% Add title and labels to axes
xlabel('Distance (km) from the source term');
ylabel('ERR (Leucemia - Male)');
legend('Location', 'bestoutside', 'Box', 'off'); 
grid on;
xlim([0 10]);
xticks(0:2:10); 

% 11) ERR Female
% Graph
figure;
semilogy(location, FA(selectedIndices), 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'A Class'); hold on;
semilogy(location, FB(selectedIndices), '^', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'B Class');
semilogy(location, FC(selectedIndices), 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'C Class');
semilogy(location, FD(selectedIndices), '*', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'D Class');
semilogy(location, FE(selectedIndices), 'd', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'E Class');
semilogy(location, FF(selectedIndices), '+', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k', 'DisplayName', 'F Class');

% Add title and labels to axes
xlabel('Distance (km) from the source term');
ylabel('ERR (Leucemia - Female)');
legend('Location', 'bestoutside', 'Box', 'off'); 
grid on

