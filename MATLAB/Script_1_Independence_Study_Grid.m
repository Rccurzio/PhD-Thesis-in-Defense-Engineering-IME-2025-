% --------------------------Disclaimer-------------------------------------
% Script: STUDY OF MESH INDEPENDENCE IN NUMERICAL SIMULATIONS
% Author: Rodrigo Carneiro Curzio (rodrigo.curzio@ime.eb.br) | Date: Mar 10th 2024
% Based on: PATANKAR, Suhas. Numerical heat transfer and fluid flow. CRC press, 2018.
% -------------------------------------------------------------------------
clear all, close all, clc

%% --- Step 1: Global parameters ------------------------------------------

% Vector of distances
distance = linspace(0.4,1.5,12)* 1000;

% Concentration vectors in the different meshes

% Mesh with 1.0 m edges
concentration_malha_1 =  [4.749E+12, 4.399E+12, 4.208E+12, 3.588E+12, 2.910E+12, 2.266E+12, ...
                         1.867E+12, 1.611E+12, 1.458E+12, 1.359E+12, 1.263E+12, 1.149E+12];

% Mesh with 0.9 m edges
concentration_malha_09 =  [5.124E+12, 4.842E+12, 4.171E+12, 3.295E+12, 2.526E+12, 1.984E+12, ...
                          1.693E+12, 1.511E+12, 1.387E+12, 1.272E+12, 1.127E+12, 9.919E+11];

% Mesh with 0.8 m edges
concentration_malha_08 =  [5.492E+12, 5.135E+12, 4.234E+12, 3.159E+12, 2.366E+12, 1.875E+12, ...
                          1.628E+12, 1.475E+12, 1.361E+12, 1.240E+12, 1.088E+12, 9.562E+11];

% Mesh with 0.7 m edges
concentration_malha_07 =  [5.903E+12, 5.428E+12, 4.466E+12, 3.263E+12, 2.386E+12, 1.879E+12, ...
                          1.625E+12, 1.474E+12, 1.370E+12, 1.265E+12, 1.128E+12, 9.906E+11];

%% --- Step 2: Sample -----------------------------------------------------

% Creating new distance points for interpolation (in meters)
distance_interp = linspace(400, 1500, 100); % creation of 100 points in the 400 to 1,500 meter range

% Interpolating concentrations to smooth curves
concentration_interp_1 =  interp1(distance, concentration_malha_1,  distance_interp, 'spline');
concentration_interp_09 = interp1(distance, concentration_malha_09, distance_interp, 'spline');
concentration_interp_08 = interp1(distance, concentration_malha_08, distance_interp, 'spline');
concentration_interp_07 = interp1(distance, concentration_malha_07, distance_interp, 'spline');

%% --- Step 3: Results ----------------------------------------------------
hold on
    plot(distance_interp, concentration_interp_1,  '-','LineWidth', 1.3, 'Color', 'k','DisplayName','Mesh 1 (1.0 m)')
    plot(distance_interp, concentration_interp_09, '-','LineWidth', 1.3, 'Color', 'r','DisplayName','Mesh 2 (0.9 m)')
    plot(distance_interp, concentration_interp_08, '-','LineWidth', 1.3, 'Color', 'b','DisplayName','Mesh 3 (0.8 m)')
    plot(distance_interp, concentration_interp_07, '-','LineWidth', 1.3, 'Color', 'g','DisplayName','Mesh 4 (0.7 m)')
    xlabel('Distance (m) from the source term')
    ylabel('Concentration (kg/m³)')
    ylim([0.5e12, 6.0e12]) % Limits of the x-axis in meters
    xlim([400, 1500])      % Limits of the x-axis in meters
    xticks(400:100:1500)   % Setting markers every 100 meters
    grid on
    box on
    legend ('show','box','off');
hold off
