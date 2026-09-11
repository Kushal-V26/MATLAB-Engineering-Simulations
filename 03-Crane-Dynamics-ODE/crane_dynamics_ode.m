%% Dynamic Crane Simulation & ODE Integration (Experiment LTD)
% Numerical investigation of crane dynamics with a suspended pendulum mass.
% Solves coupled nonlinear equations of motion using MATLAB ODE solvers (ode45 vs ode23),
% computes dynamic rod constraint forces Z(t), and evaluates beam bending stresses.

clc;
clear;
close all;

%% 1. System Parameters
m = 1000;           % Point mass [kg]
l = 10;             % Pendulum length [m]
g = 9.81;           % Gravitational acceleration [m/s^2]
L_beam = 18;        % Cantilever girder length [m]
b_pos = 18;         % Suspension location along girder [m]
a_thick = 0.25;     % Half-height of beam cross-section [m]
b_width = 0.5;      % Beam width [m]
rho = 7850;         % Density [kg/m^3]
A_beam = 2 * a_thick * b_width;
I_z = (b_width * (2 * a_thick)^3) / 12;

tspan = [0 20];     % Simulation interval [s]

%% 2. Scenario D: Free Undamped Oscillations
d_D = 0;                        % Undamped
y0_D = [0.05; 0.5];             % Initial condition [phi0; dphi0]

[t_D, y_D] = ode45(@(t, y) craneODE(t, y, m, l, g, d_D, 'd'), tspan, y0_D);
[x_D, y_pos_D, Z_D] = computeKinematicsAndForces(t_D, y_D, m, l, g, d_D, 'd');

%% 3. Scenario E: Damped Forced Motion
d_E = 1.0;                      % Viscous damping
y0_E = [0; 0];                  % Initial condition from rest

[t_E, y_E] = ode45(@(t, y) craneODE(t, y, m, l, g, d_E, 'e'), tspan, y0_E);
[x_E, y_pos_E, Z_E] = computeKinematicsAndForces(t_E, y_E, m, l, g, d_E, 'e');

%% 4. Multi-Panel Dynamics Visualization
figure('Name', 'Crane Dynamics - Kinematics and Phase Space', 'Position', [100, 100, 1000, 700]);

% Angular Displacements
subplot(2, 2, 1);
plot(t_D, y_D(:, 1), 'b-', 'LineWidth', 1.2); hold on;
plot(t_E, y_E(:, 1), 'r--', 'LineWidth', 1.2);
grid on; xlabel('Time [s]'); ylabel('\phi [rad]');
title('Angular Displacement \phi(t)');
legend('Scenario D (Undamped)', 'Scenario E (Damped/Forced)', 'Location', 'best');

% Phase Space Portrait
subplot(2, 2, 2);
plot(y_D(:, 1), y_D(:, 2), 'b-', 'LineWidth', 1.2); hold on;
plot(y_E(:, 1), y_E(:, 2), 'r--', 'LineWidth', 1.2);
grid on; xlabel('\phi [rad]'); ylabel('d\phi/dt [rad/s]');
title('Phase Space Portrait');
legend('Scenario D (Closed Orbit)', 'Scenario E (Spiral)', 'Location', 'best');

% Cartesian Trajectories
subplot(2, 2, 3);
plot(x_D, y_pos_D, 'b-', 'LineWidth', 1.2); hold on;
plot(x_E, y_pos_E, 'r--', 'LineWidth', 1.2);
grid on; xlabel('x [m]'); ylabel('y [m]');
title('Point Mass Cartesian Trajectory');
legend('Scenario D', 'Scenario E', 'Location', 'best');

% Dynamic Rod Tension Force
subplot(2, 2, 4);
plot(t_D, Z_D, 'b-', 'LineWidth', 1.2); hold on;
plot(t_E, Z_E, 'r--', 'LineWidth', 1.2);
grid on; xlabel('Time [s]'); ylabel('Tensile Force Z [N]');
title('Dynamic Rod Force Z(t)');
legend('Scenario D', 'Scenario E', 'Location', 'best');

%% 5. Numerical Solver Benchmark: ode45 vs ode23
tolerances = [1e-2, 1e-4, 1e-6, 1e-8];
figure('Name', 'Solver Comparison: Energy Dissipation');
hold on;

[t_ref, y_ref] = ode45(@(t, y) craneODE(t, y, m, l, g, d_E, 'e'), tspan, [0.05; 0.5]);
E_total_ref = 0.5 * m * (l * y_ref(:, 2)).^2 + m * g * l * (1 - cos(y_ref(:, 1)));
plot(t_ref, E_total_ref, 'k-', 'LineWidth', 2, 'DisplayName', 'ode45 (Reference)');

for tol = tolerances
    opts = odeset('RelTol', tol, 'AbsTol', tol);
    [t_tol, y_tol] = ode23(@(t, y) craneODE(t, y, m, l, g, d_E, 'e'), tspan, [0.05; 0.5], opts);
    E_total_tol = 0.5 * m * (l * y_tol(:, 2)).^2 + m * g * l * (1 - cos(y_tol(:, 1)));
    plot(t_tol, E_total_tol, '--', 'DisplayName', sprintf('ode23 (Tol = 10^{%d})', log10(tol)));
end

grid on; xlabel('Time [s]'); ylabel('Total Mechanical Energy E [J]');
title('Energy Dissipation Benchmark: ode45 vs ode23');
legend('show', 'Location', 'best');
hold off;

%% --- Helper Functions ---
function dydt = craneODE(t, y, m, l, g, d, scenario)
    phi = y(1);
    omega = y(2);
    
    if strcmp(scenario, 'e')
        F_ext = 50 * sin(0.5 * t); % External excitation
    else
        F_ext = 0;
    end
    
    dphi = omega;
    domega = (1 / (m * l^2)) * (-m * g * l * sin(phi) - d * l^2 * omega + F_ext * l);
    dydt = [dphi; domega];
end

function [x, y, Z] = computeKinematicsAndForces(t, sol, m, l, g, d, scenario)
    phi = sol(:, 1);
    omega = sol(:, 2);
    x = l * sin(phi);
    y = -l * cos(phi);
    
    if strcmp(scenario, 'e')
        F_ext = 50 * sin(0.5 * t);
    else
        F_ext = zeros(size(t));
    end
    
    % Dynamic radial bar constraint force Z
    Z = m * (g * cos(phi) + l * omega.^2) + d * l * omega .* sin(phi) - F_ext .* sin(phi);
end
