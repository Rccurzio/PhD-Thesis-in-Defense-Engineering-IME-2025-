% --------------------------Disclaimer-------------------------------------
% SCRIPT: IMPLEMENTATION OF THE OPTIMIZATION MODEL FOR CALCULATING RESILIENCE
% Author: Rodrigo Carneiro Curzio (rodrigo.curzio@ime.eb.br) | Date: Nov 25th 2024
% Based on: ANOCEDAL, Jorge; WRIGHT, Stephen J. (Ed.). Numerical optimization. New York, NY: Springer New York, 1999.
% # Conditions:
% ----FOB: k1*I1 + k1*I1 + k2*I2 + k3*I3 + k4*I4 (Maximize)
% ----s.a: k1+k2+k3+k4 <= 1; k1 > 0; k2 > 0; k3 > 0; k4 > 0
% # Solution of the System of Equations:
% ----Singular value decomposition (SVD) method if rcond < 1.0e-04
% ----Gauss Elimination Method if rcond >= 1.0e-04
% -------------------------------------------------------------------------
clear all, clc, close all

%% --- Step 1: Global parameters -------------------------------------------

% Distance from the source term (km)
Location = [0.1; 0.5; 1.0; 2.0; 4.0; 6.0; 8.0; 10.0];

% Selecting the desired indexes: 1 (0.1), 4 (2), 5 (4), 6 (6), 7 (8), 8 (10)
selectedIndices = [1, 4, 5, 6, 7, 8];
location = Location(selectedIndices);

% Preparing the table to store the k values for each class to be displayed in the Command Window
classe_names_full = {'A Class', 'B Class', 'C Class', 'D Class', 'E Class', 'F Class'};
k_values_table = table('Size', [length(classe_names_full), 4], ...
                       'VariableTypes', {'double', 'double', 'double', 'double'}, ...
                       'VariableNames', {'k1', 'k2', 'k3', 'k4'}, ...
                       'RowNames', classe_names_full);

% PG Class indicators
indicators = {'A', 'B', 'C', 'D', 'E', 'F'};
I1 = load("I1_norm.txt")';
I3 = load('I3_norm.txt')';
I2 = cell(length(indicators), 1);
I4 = cell(length(indicators), 1);

for i = 1:length(indicators)
    I2{i} = load(['I2_' indicators{i} '_norm.txt'])';
    I4{i} = load(['I4_' indicators{i} '_norm.txt'])';
end

% Algorithm convergence criteria
tol = 1e-6;                     % Tolerance for convergence
max_iter = 100;                 % Maximum number of iterations
beta = 0.8;                     % Step decrease factor
max_step_reductions = 10;       % Limit of step reductions for backtracking
mu_initial = 10;                % Initial value of mu
mu_reduction_factor = 0.0001;   % Mu reduction factor at each iteration

%% --- Step 2: Application of the algorithm and plotting for each PG class
% Plot initialization
figure;
hold on;

% Markers on the graph for each PG class
markers = {'^', 'o', 's', 'd', 'p', 'h'}; 

% Application of the Optimization Algorithm (Interior Point Method)
for i = 1:length(classe_names_full)
    classeS = classe_names_full{i}(end);   % Selects the class letter
    marker = markers{i};

    % I's values based on selected indices 
    I1_selected = I1(selectedIndices);
    I2_selected = I2{i};
    I3_selected = I3(i) * ones(1, length(I2_selected));  
    I4_selected = I4{i}(selectedIndices);

    % Initialization of the k terms and the mu parameter for the algorithm
    k  = [0.25; 0.25; 0.25; 0.24];  % Initialized with a sum <= 1 to guarantee results within the feasible region
    mu = mu_initial;                % Initial value of mu

    for iter = 1:max_iter
        % Gradient and Hessian of the Lagrange Function
        grad = gradient_f(k, I1_selected, I2_selected, I3_selected, I4_selected, mu);
        hess = hessian_f(k, mu);

        % Hessian matrix conditioning analysis (H*delta_k = grad)
        if cond(hess,2) > 1.0e+03
            % System solution using SVD decomposition
            [U, S, V] = svd(hess);
            S_inv = diag(1 ./ diag(S));  % Inversão dos valores singulares
            delta_k = -V * S_inv * U' * grad;
        else
            % Solution of the system using Gauss elimination
            delta_k = gauss_elimination(hess, -grad);
        end

        % Stop condition
        if norm(grad) < tol || norm(delta_k) < tol
            break;
        end
        
        % Backtracking line to ensure steering within the feasible region
        step_size = 1;
        step_reductions = 0;
        while step_reductions < max_step_reductions
            new_k = k + step_size * delta_k;
            if all(new_k > 0) && (sum(new_k) < 1)
                break; % Viability condition met
            end
            step_size = beta * step_size; % Slows down the pace to ensure that the constraints are being met
            step_reductions = step_reductions + 1;
        end

        % If the step is not found after the limit, end the iteration
        if step_reductions == max_step_reductions
            break;
        end

        % Update of the value of k
        k = new_k;

        % Reduction in the value of mu
        mu = mu * mu_reduction_factor;
    end

    % Storing k values in a table
    k_values_table{classe_names_full{i}, :} = k'; 

    % Calculation of the Res optimization value for each PG class
    Res_opt = k(1) * I1_selected + k(2) * I2_selected + k(3) * I3_selected + k(4) * I4_selected;

    % Normalization of Res (0 and 2.5)
    Res_norm = (Res_opt - min(Res_opt)) / (max(Res_opt) - min(Res_opt)) * 2.5;

    % Unique file name for all classes
    filename = 'Values_Resilience_With_Optimization.txt';

    % Opening the file to write the calculated values for the k terms
    fileID = fopen(filename, 'w');
    
    % Concatenating the normalized resilience values (Res_norm) for each class into a matrix
    classes = {'A', 'B', 'C', 'D', 'E', 'F'};
    Res_values_optimized = []; % Initializes the matrix to store the resiliences
    
    % Storing the optimized resilience of each class
    for i = 1:length(classes)
        Res_values_optimized = [Res_values_optimized, Res_norm']; % Add Res_norm of each class as a column vector
    end
    
    % Writing the Res_norm values to the file
    for i = 1:size(Res_values_optimized, 1)
        fprintf(fileID, '%.6f\t', Res_values_optimized(i, :)); % Writes the optimized Res_norm values of all classes
        fprintf(fileID, '\n');                                 % New line for better visualization in the command window
    end
    
    % Closing the file containing the optimized Res_norm values
    fclose(fileID);
    
    % Plotting the results (optimized and normalized Res values)
    plot(location, Res_norm, 'Marker', marker, 'LineStyle', 'none', 'Color', 'k', 'MarkerFaceColor', 'k');
end

% Displaying the table in the Command Window
fprintf('Convergence achieved in iteration %d\n', iter);
disp(k_values_table);

% Confirmation message in the Command Window
disp(['All the optimized resiliences have been saved in the file: ', filename]);

% Configuring the resilience graph
xlabel('Distance (km) from the source term', 'FontSize', 10);
ylabel(sprintf('R_{es} (Male e Female)\n All PG Classes'),'FontSize', 10);
grid on;
legend(classe_names_full, 'Location', 'northwest', 'Box', 'off');
box on;
set(gca, 'XTick', 0:2:10); % Sets the x-axis ticks from 0 to 10 with an interval of 2

% Saving the table with the optimized values of the k terms in an .xls file
writetable(k_values_table, 'Data_k_values.xlsx', 'WriteRowNames', true);

%% --- Step 3: Function definitions
% Function for calculating the Objective Function (Fob)
function f = fun_obj(k, I1, I2, I3, I4, mu)
    f = - sum(k(1) * I1 + k(2) * I2 + k(3) * I3 + k(4) * I4) ...
        - mu * (log(k(1)) + log(k(2)) + log(k(3)) + log(k(4))) - mu*log(1-sum(k));
end

% Function to calculate the gradient of the Fob
function g = gradient_f(k, I1, I2, I3, I4, mu)
    n = length(k);
    g = zeros(n, 1); % Initializes the gradient vector
    sum_k = sum(k);

    % Gradient calculation
    for i = 1:n
         g(i) = -sum(eval(['I' num2str(i)])) - (mu / k(i)) + (mu / (1 - sum_k)); 
    end
end

% Function to calculate the Hessian Matrix of the Fob
function H = hessian_f(k, mu)
    n = length(k);
    H = zeros(n, n);
    sum_k = sum(k);
    % Calculation of the Hessian Matrix
    for i = 1:n
        H(i, i) = mu*( 1/ k(i)^2 + 1 / (1 - sum_k)^2) ; % Main diagonal
        for j = 1:n
            if i ~= j
                H(i, j) = mu / (1 - sum_k)^2; % Off-diagonal terms
            end
        end
    end
end

% Function for the Gauss Elimination method
function x = gauss_elimination(A, b)
    n = length(b);
    % Phasing out
    for i = 1:n-1
        for j = i+1:n
            factor = A(j,i) / A(i,i);
            A(j,:) = A(j,:) - factor * A(i,:);
            b(j) = b(j) - factor * b(i);
        end
    end
    % Regressive substitution
    x = zeros(n,1);
    x(n) = b(n) / A(n,n);
    for i = n-1:-1:1
        x(i) = (b(i) - A(i,i+1:n) * x(i+1:n)) / A(i,i);
    end
end