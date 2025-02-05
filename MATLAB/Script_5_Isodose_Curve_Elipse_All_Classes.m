% --------------------------Disclaimer-------------------------------------
% SCRIPT: CALCULTATION OF ISODOSE CURVES FOR ALL PG CLASSES
% Author: Rodrigo Carneiro Curzio (rodrigo.curzio@ime.eb.br) | Date: Jan 10th 2025
% Based on: STOCKIE, John M. The mathematics of atmospheric dispersion modeling. Siam Review, v. 53, n. 2, p. 349-372, 2011.
% -------------------------------------------------------------------------
clear all, clc, close all

%% --- Step 1: Global parameters ------------------------------------------
% Defining the classes and their parameters according to the Gaussian dispersion model

% PG class markers
tipos = {'A', 'B', 'C', 'D', 'E', 'F'};

% Sample
parametros = [
    0.25, 0.080, 0.45, 0.19, 0.65, 0.25;    % A Class
    0.35, 0.100, 0.70, 0.20, 1.01, 0.30;    % B Class
    0.45, 0.102, 1.20, 0.25, 1.70, 0.30;    % C Class
    0.65, 0.100, 2.30, 0.25, 3.70, 0.30;    % D Class
    1.1,  0.100, 3.88, 0.20, 6.40, 0.30;    % E Class
    1.8,  0.100, 6.05, 0.20, 8.60, 0.30     % F Class
];

%% --- Step 2: Initializing the figure for subplots with isodoses (all PG classes)
figure;
for i = 1:length(tipos)
    % Defining the parameters of the current class
    a_inner  = parametros(i, 1);
    b_inner  = parametros(i, 2);
    a_middle = parametros(i, 3);
    b_middle = parametros(i, 4);
    a_outer  = parametros(i, 5);
    b_outer  = parametros(i, 6);

    % Generating parametric angles for constructing ellipses
    theta = linspace(0, 2*pi, 100);

    % Calculation of the ellipses representing the exclusion zones
    x_inner  = a_inner * cos(theta);
    y_inner  = b_inner * sin(theta);
    x_middle = a_middle * cos(theta);
    y_middle = b_middle * sin(theta);
    x_outer  = a_outer * cos(theta);
    y_outer  = b_outer * sin(theta);

    % Displacement of the ellipses in relation to the Cartesian axes
    x_inner  =  x_inner   + a_inner;
    x_middle =  x_middle  + a_middle;
    x_outer  =  x_outer   + a_outer;

    % Creation of a new window, within the sub-plot, for each PG class
    figure;
    plot(x_inner, y_inner, 'r', 'LineWidth', 2); hold on;
    plot(x_middle, y_middle, 'g', 'LineWidth', 2);
    plot(x_outer, y_outer, 'b', 'LineWidth', 2);

    % Chart settings
    xlabel('km', 'FontSize', 10, 'FontWeight', 'bold');
    ylabel('km', 'FontSize', 10, 'FontWeight', 'bold');
    axis equal;
    grid on;
    
    % Defining the limits of the graph
    if strcmp(tipos{i}, 'A')
        xlim([0 2]); ylim([-0.4 0.4]);
    elseif strcmp(tipos{i}, 'B') || strcmp(tipos{i}, 'C')
        xlim([0 5]); ylim([-1 1]);
    elseif strcmp(tipos{i}, 'D')
        xlim([0 10]); ylim([-2 2]);
    else
        xlim([0 20]); ylim([-2 2]);
    end

    % Adding titles and legends to graphs (main plot and subplot)
    title(['Isodose Curve (TEDE (Sv)) - Class ', tipos{i}], 'FontSize', 12, 'FontWeight', 'bold');
    legend({'Inner: 700 mSv', 'Intermediate: 100 mSv', 'Outer: 50 mSv'}, 'Location', 'northeast','box','off', 'FontSize', 10);

    % Adding the graph to the subplot
    figure(1);
    subplot(3, 2, i);
    plot(x_inner,  y_inner,  'r', 'LineWidth', 2); hold on;
    plot(x_middle, y_middle, 'g', 'LineWidth', 2);
    plot(x_outer,  y_outer,  'b', 'LineWidth', 2);

    % Subplot chart settings
    xlabel('km', 'FontSize', 8, 'FontWeight', 'bold');
    ylabel('km', 'FontSize', 8, 'FontWeight', 'bold');
    axis equal;
    grid on;
    title(['Class ', tipos{i}], 'FontSize', 10, 'FontWeight', 'bold');
end

% Subplot spacing adjustment
figure(1);
subtitle('Isodose Curves - TEDE (Sv) for all differente PG Class');


% Adding a single subtitle to the subplots
legend_handle = legend({'Interna: 700 mSv', 'Intermediária: 100 mSv', 'Externa: 50 mSv'}, 'FontSize', 12, 'Location', 'southoutside', 'Orientation', 'horizontal','box','off');
legend_handle.Position = [0.35, 0.02, 0.3, 0.03]; % Adjusts the position of the subtitle

% Adjusting the spacing of subplots
sgtitle('Isodose Curves - TEDE (Sv) for all differente PG Class');