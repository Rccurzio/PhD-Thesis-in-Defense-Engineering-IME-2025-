% --------------------------Disclaimer-------------------------------------
% SCRIPT: CALCULATING OF ISODOSE CURVES FOR ALL PG CLASSES
% Author: Rodrigo Carneiro Curzio (rodrigo.curzio@ime.eb.br) | Date: Jan 10th 2025
% Based on: BERGMANN, Reinhard; LUDBROOK, John; SPOOREN, Will PJM. Different outcomes of the Wilcoxon—Mann—Whitney test from different statistics packages. The American Statistician, v. 54, n. 1, p. 72-77, 2000.
% -------------------------------------------------------------------------
clear all, clc, close all

%% --- Step 1: Global parameters ------------------------------------------
distances = [0.1, 0.5, 1.0, 2.0, 4.0, 6.0, 8.0, 10.0]; % Distances of interest in km
alpha = 0.05;                                          % Significance level for applying the statistical test

%% --- Step 2: Sample -----------------------------------------------------
% ERR calculation data (Male)
ERR_male = [... 
    1.17E+03, 4.34E+03, 1.21E+04, 1.79E+04, 1.62E+03, 5.46E+03; % 0.1 km
    1.25E+01, 2.69E+01, 8.34E+01, 3.06E+02, 1.26E+03, 4.34E+03; % 0.5 km
    6.21E-01, 9.07E+00, 1.59E+01, 4.59E+01, 1.51E+02, 7.77E+02; % 1.0 km
    1.50E-01, 3.48E-01, 9.25E-01, 1.33E+01, 2.69E+01, 9.85E+01; % 2.0 km
    3.99E-02, 9.06E-02, 2.58E-01, 7.69E+00, 1.04E+01, 2.10E+01; % 4.0 km
    1.86E-02, 4.18E-02, 1.30E-01, 4.75E-01, 8.07E+00, 1.18E+01; % 6.0 km
    1.09E-02, 2.50E-02, 8.41E-02, 3.06E-01, 6.80E-01, 9.07E+00; % 8.0 km
    7.68E-03, 1.67E-02, 5.93E-02, 2.17E-01, 5.04E-01, 8.07E+00  % 10.0 km
];

% ERR calculation data (Female)
ERR_female= [... 
    8.36E+02, 3.09E+03, 8.60E+03, 1.28E+04, 1.15E+03, 3.89E+03; % 0.1 km
    8.93E+00, 1.92E+01, 5.94E+01, 2.18E+02, 8.96E+02, 3.09E+03; % 0.5 km
    4.82E-01, 6.45E+00, 1.13E+01, 3.27E+01, 1.08E+02, 5.53E+02; % 1.0 km
    1.16E-01, 2.70E-01, 5.47E+00, 9.49E+00, 1.92E+01, 7.01E+01; % 2.0 km
    3.10E-02, 7.04E-02, 2.00E-01, 5.47E+00, 7.38E+00, 1.49E+01; % 4.0 km
    1.44E-02, 3.25E-02, 1.01E-01, 3.69E-01, 5.74E+00, 8.39E+00; % 6.0 km
    8.45E-03, 1.94E-02, 6.53E-02, 2.38E-01, 5.28E-01, 6.45E+00; % 8.0 km
    5.97E-03, 1.29E-02, 4.61E-02, 1.69E-01, 3.91E-01, 5.74E+00  % 10.0 km
];

%% --- Step 3: Application of the statistical test ------------------------
% Initialization of results tables
results = [];

% Loop for each distance of interest
for i = 1:size(ERR_male, 1)
    % Male and female data for the current distance
    male = ERR_male(i, :);
    female = ERR_female(i, :);

    % Application of the Wilcoxon test (ranksum)
    [p_mwu, h_mwu] = ranksum(male, female);

    % Analysis of the level of significance reached
    significance = p_mwu < alpha;

    % Concatenation of results in the table
    results = [results; distances(i), p_mwu, significance];
end

%% --- Step 4: Results ----------------------------------------------------
% Creating a table for display in the Command Window
results_table = array2table(results, ...
    'VariableNames', {'Distance (km)', 'p_Wilcoxon', 'Significant'});
disp('Results of Statistical Analysis with Wilcoxon Test:');
disp(results_table);