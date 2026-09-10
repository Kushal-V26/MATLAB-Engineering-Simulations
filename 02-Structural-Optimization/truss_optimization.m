
%% Task 1
clc;
clear;
close all; 

trussStruct = load('V4_Input_TrussStructure.mat');
boundaryCond = trussStruct.boundaryCond;
coord = trussStruct.coord;
force = trussStruct.force;
conn = trussStruct.conn;

E = 3; % Elastic modulus
b = 5; % length and width of bar
A_uniform = b*b; % Uniform cross-sectional area

N_truss = length(conn(:,1)); % Number of trusses
N_node = length(coord(:,1)); % Number of nodes
N_bearing = length(boundaryCond(:,1));
n1 = conn(:, 1); % local node 1
n2 = conn(:, 2); % local node 2
x = coord(:, 1); % x coordinate
y = coord(:, 2); % y coordinate

f1 = figure;
hold on; % Begin making first plot
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p1 = plot([x_1, x_2], [y_1, y_2], '-ok');
    text((x_1 + x_2)/2, (y_1 + y_2)/2, num2str(i))
end

n1 = boundaryCond(:,1); % node number
n2 = boundaryCond(:,2); % dof
for i = 1:N_bearing
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    if n2(i) == 1
        p2 = plot(x_1 - 0.2, y_1, 'r>'); % May be made more generic
    else
        p2 = plot(x_1, y_1 - 0.2, 'r^');
    end
end

% Assign cross-sectional areas (uniform or proportional to length)
A = A_uniform * ones(N_truss, 1);

% Calculate tensile stiffness vector
EA = E * A;
[u, S] = calcTrussStructure(EA, N_node, N_truss, coord, conn, boundaryCond, force);

deformed_coord = coord + reshape(u, 2, [])';
n1 = conn(:, 1);
n2 = conn(:, 2);
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p3 = plot([x_1, x_2], [y_1, y_2], '-b');
end

axis equal;
title('Sub task 1'), xlabel('x'); ylabel('y');
legend([p1, p2, p3], 'undeformed', 'boundary condition', 'deformed');
hold off;

%% 

l_bound = 0.01 * ones(N_truss, 1); % Lower bound of scaling factor
u_bound = 5 * ones(N_truss, 1); % Upper bound of scaling factor
x_0 = rand(N_truss, 1).*(u_bound - l_bound) + l_bound; % Random start vector within bounds

% Call fmincon for optimization
%% Task 2 lines of code

N_truss = length(conn(:,1)); % Number of trusses
N_node = length(coord(:,1)); % Number of nodes
N_bearing = length(boundaryCond(:,1));
n1 = conn(:, 1); % local node 1
n2 = conn(:, 2); % local node 2
x = coord(:, 1); % x coordinate
y = coord(:, 2); % y coordinate

f2 = figure; grid; hold on; % Begin making first plot
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p1 = plot([x_1, x_2], [y_1, y_2], '-ok');
    text((x_1 + x_2)/2, (y_1 + y_2)/2, num2str(i))
end

n1 = boundaryCond(:,1); % node number
n2 = boundaryCond(:,2); % dof
for i = 1:N_bearing
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    if n2(i) == 1
        p2 = plot(x_1 - 0.2, y_1, 'r>'); % May be made more generic
    else
        p2 = plot(x_1, y_1 - 0.2, 'r^');
    end
end

% Assign cross-sectional areas (uniform or proportional to length)
A = A_uniform * ones(N_truss, 1);

% Calculate tensile stiffness vector
EA = E * A;
[u, S] = calcTrussStructure(EA, N_node, N_truss, coord, conn, boundaryCond, force);

deformed_coord = coord + reshape(u, 2, [])';
n1 = conn(:, 1);
n2 = conn(:, 2);
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p3 = plot([x_1, x_2], [y_1, y_2], '-b');
end

[x_opt2, objVal] = fmincon(@(x) objectiveFunction(x, EA, N_node, N_truss, coord, conn, boundaryCond, force), ...
                          x_0, [], [], [], [], l_bound, u_bound, []);

% Display results
disp('Optimized Scaling Factors:');
disp(x_opt2);
disp('Minimum Displacement Magnitude at Force Application Node:');
disp(objVal);


% Calculate scaled EA
EA_optimized = x_opt2.*EA;

% Calculate deformed truss with optimized EA
[u_optimized, S_optimized] = calcTrussStructure(EA_optimized, N_node, N_truss, coord, conn, boundaryCond, force);

% Plot deformed truss
deformed_coord = coord + reshape(u_optimized, 2, [])';
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p4 = plot([x_1, x_2], [y_1, y_2], 'r-', 'LineWidth', x_opt2(i)); % Line width proportional to scaling factor
end

axis equal;
title('Sub task 2'), xlabel('x'); ylabel('y');
legend([p1, p2, p3, p4], 'undeformed', 'boundary condition', 'deformed', 'Optimised');
hold off;

%% Task 3 lines of code

N_truss = length(conn(:,1)); % Number of trusses
N_node = length(coord(:,1)); % Number of nodes
N_bearing = length(boundaryCond(:,1));
n1 = conn(:, 1); % local node 1
n2 = conn(:, 2); % local node 2
x = coord(:, 1); % x coordinate
y = coord(:, 2); % y coordinate

f3 = figure;
hold on; % Begin making first plot
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p1 = plot([x_1, x_2], [y_1, y_2], '-ok');
    text((x_1 + x_2)/2, (y_1 + y_2)/2, num2str(i))
end

n1 = boundaryCond(:,1); % node number
n2 = boundaryCond(:,2); % dof
for i = 1:N_bearing
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    if n2(i) == 1
        p2 = plot(x_1 - 0.2, y_1, 'r>'); % May be made more generic
    else
        p2 = plot(x_1, y_1 - 0.2, 'r^');
    end
end

% Assign cross-sectional areas (uniform or proportional to length)
A = A_uniform * ones(N_truss, 1);

% Calculate tensile stiffness vector
EA = E * A;
[u, S] = calcTrussStructure(EA, N_node, N_truss, coord, conn, boundaryCond, force);

deformed_coord = coord + reshape(u, 2, [])';
n1 = conn(:, 1);
n2 = conn(:, 2);
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p3 = plot([x_1, x_2], [y_1, y_2], '-b');
end

Aeq = EA'; % Row vector of axial stiffness values
beq = 825; % total axial stifness
[x_opt3, objVal] = fmincon(@(x) objectiveFunction(x, EA, N_node, N_truss, coord, conn, boundaryCond, force), ...
                          x_0, [], [], Aeq, beq, l_bound, u_bound, []);

% Display results
disp('Optimized Scaling Factors:');
disp(x_opt3);
disp('Minimum Displacement Magnitude at Force Application Node:');
disp(objVal);


% Calculate scaled EA
EA_optimized = x_opt3.*EA;

% Calculate deformed truss with optimized EA
[u_optimized, S_optimized] = calcTrussStructure(EA_optimized, N_node, N_truss, coord, conn, boundaryCond, force);

% Plot deformed truss
deformed_coord = coord + reshape(u_optimized, 2, [])';
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p4 = plot([x_1, x_2], [y_1, y_2], 'r-', 'LineWidth', x_opt3(i)); % Line width proportional to scaling factor
end

axis equal;
title('Sub task 3'), xlabel('x'); ylabel('y');
legend([p1, p2, p3, p4], 'undeformed', 'boundary condition', 'deformed', 'Optimised');
hold off;

%% Task 4 lines of code

N_truss = length(conn(:,1)); % Number of trusses
N_node = length(coord(:,1)); % Number of nodes
N_bearing = length(boundaryCond(:,1));
n1 = conn(:, 1); % local node 1
n2 = conn(:, 2); % local node 2
x = coord(:, 1); % x coordinate
y = coord(:, 2); % y coordinate

f4 = figure;
hold on; % Begin making first plot
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p1 = plot([x_1, x_2], [y_1, y_2], '-ok');
    text((x_1 + x_2)/2, (y_1 + y_2)/2, num2str(i))
end

n1 = boundaryCond(:,1); % node number
n2 = boundaryCond(:,2); % dof
for i = 1:N_bearing
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    if n2(i) == 1
        p2 = plot(x_1 - 0.2, y_1, 'r>'); % May be made more generic
    else
        p2 = plot(x_1, y_1 - 0.2, 'r^');
    end
end

% Assign cross-sectional areas (uniform or proportional to length)
A = A_uniform * ones(N_truss, 1);

% Calculate tensile stiffness vector
EA = E * A;
[u, S] = calcTrussStructure(EA, N_node, N_truss, coord, conn, boundaryCond, force);

deformed_coord = coord + reshape(u, 2, [])';
n1 = conn(:, 1);
n2 = conn(:, 2);
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p3 = plot([x_1, x_2], [y_1, y_2], '-b');
end

[x_opt4, objVal] = fmincon(@(x) objectiveFunction(x, EA, N_node, N_truss, coord, conn, boundaryCond, force), ...
                          x_0, [], [], [], [], l_bound, u_bound, ...
                          @(x) constraintFunction(x, A, EA, S, 500)); % 500 is the total stiffness

% Display results
disp('Optimized Scaling Factors:');
disp(x_opt4);
disp('Minimum Displacement Magnitude at Force Application Node:');
disp(objVal);


% Calculate scaled EA
EA_optimized = x_opt4.*EA;

% Calculate deformed truss with optimized EA
[u_optimized, S_optimized] = calcTrussStructure(EA_optimized, N_node, N_truss, coord, conn, boundaryCond, force);

% Plot deformed truss
deformed_coord = coord + reshape(u_optimized, 2, [])';
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p4 = plot([x_1, x_2], [y_1, y_2], 'r-', 'LineWidth', x_opt4(i)); % Line width proportional to scaling factor
end

axis equal;
title('Sub task 4'), xlabel('x'); ylabel('y');
legend([p1, p2, p3, p4], 'undeformed', 'boundary condition', 'deformed', 'Optimised');
hold off;

%% Task 5 lines of code

N_truss = length(conn(:,1)); % Number of trusses
N_node = length(coord(:,1)); % Number of nodes
N_bearing = length(boundaryCond(:,1));
n1 = conn(:, 1); % local node 1
n2 = conn(:, 2); % local node 2
x = coord(:, 1); % x coordinate
y = coord(:, 2); % y coordinate

f5 = figure;
hold on; % Begin making first plot
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p1 = plot([x_1, x_2], [y_1, y_2], '-ok');
    text((x_1 + x_2)/2, (y_1 + y_2)/2, num2str(i))
end

n1 = boundaryCond(:,1); % node number
n2 = boundaryCond(:,2); % dof
for i = 1:N_bearing
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    if n2(i) == 1
        p2 = plot(x_1 - 0.2, y_1, 'r>'); % May be made more generic
    else
        p2 = plot(x_1, y_1 - 0.2, 'r^');
    end
end

% Assign cross-sectional areas (uniform or proportional to length)
A = A_uniform * ones(N_truss, 1);

% Calculate tensile stiffness vector
EA = E * A;
[u, S] = calcTrussStructure(EA, N_node, N_truss, coord, conn, boundaryCond, force);

deformed_coord = coord + reshape(u, 2, [])';
n1 = conn(:, 1);
n2 = conn(:, 2);
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p3 = plot([x_1, x_2], [y_1, y_2], '-b');
end

options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp', 'MaxIterations', 100);
[x_opt5, objVal] = fmincon(@(x) objectiveFunction(x, EA, N_node, N_truss, coord, conn, boundaryCond, force), ...
                          x_0, [], [], [], [], l_bound, u_bound, ...
                          @(x) constraintFunction(x, A, EA, S, 500), options);


% Display results
disp('Optimized Scaling Factors:');
disp(x_opt5);
disp('Minimum Displacement Magnitude at Force Application Node:');
disp(objVal);


% Calculate scaled EA
EA_optimized = x_opt5.*EA;

% Calculate deformed truss with optimized EA
[u_optimized, S_optimized] = calcTrussStructure(EA_optimized, N_node, N_truss, coord, conn, boundaryCond, force);

% Plot deformed truss
deformed_coord = coord + reshape(u_optimized, 2, [])';
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p4 = plot([x_1, x_2], [y_1, y_2], 'r-', 'LineWidth', x_opt5(i)); % Line width proportional to scaling factor
end

axis equal; 
title('Sub task 5'), xlabel('x'); ylabel('y');
legend([p1, p2, p3, p4], 'undeformed', 'boundary condition', 'deformed', 'Optimised');
hold off

%% Task 6

save Results_34_V4_Task_5 u_optimized S_optimized

%% Task 7
crane = load('V4_Input_Crane.mat');
boundaryCond = crane.boundaryCond;
coord = crane.coord;
force = crane.force;
conn = crane.conn;
clear filename pathname crane filepath

N_truss = length(conn(:,1));
N_node = length(coord(:,1));
N_bearing = length(boundaryCond(:,1));
n1 = conn(:, 1); % local node 1
n2 = conn(:, 2); % local node 2
x = coord(:, 1); % x coordinate
y = coord(:, 2); % y coordinate

f6 = figure;
hold on; % Begin making second plot
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p1 = plot([x_1, x_2], [y_1, y_2], '-ok');
    text((x_1 + x_2)/2, (y_1 + y_2)/2, num2str(i))
end

n1 = boundaryCond(:,1); % node number
n2 = boundaryCond(:,2); % dof
for i = 1:N_bearing
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    if n2(i) == 1
        p2 = plot(x_1 - 0.2, y_1, 'r>'); % May be made more generic
    else
        p2 = plot(x_1, y_1 - 0.2, 'r^');
    end
end

% Assign cross-sectional areas (uniform or proportional to length)
A = A_uniform * ones(N_truss, 1);

% Calculate tensile stiffness vector
EA = E * A;
[u, S] = calcTrussStructure(EA, N_node, N_truss, coord, conn, boundaryCond, force);

deformed_coord = coord + reshape(u, 2, [])';
n1 = conn(:, 1);
n2 = conn(:, 2);
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p3 = plot([x_1, x_2], [y_1, y_2], '-b');
end

l_bound = 0.01 * ones(N_truss, 1);
u_bound = 5 * ones(N_truss, 1);
x_0 = rand(N_truss, 1).*(u_bound - l_bound) + l_bound; % Random start vector within bounds

options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp', 'MaxIterations', 100);
[x_opt5, objVal] = fmincon(@(x) objectiveFunction(x, EA, N_node, N_truss, coord, conn, boundaryCond, force), ...
                          x_0, [], [], [], [], l_bound, u_bound, ...
                          @(x) constraintFunction(x, A, EA, S, 2175), options); % 2175 is the total stiffness

% Display results
disp('Optimized Scaling Factors:');
disp(x_opt5);
disp('Minimum Displacement Magnitude at Load Application Node:');
disp(objVal);


% Calculate scaled EA
EA_optimized = x_opt5.*EA;

% Calculate deformed truss with optimized EA
[u_optimized, S_optimized] = calcTrussStructure(EA_optimized, N_node, N_truss, coord, conn, boundaryCond, force);


% Plot deformed truss
deformed_coord = coord + reshape(u_optimized, 2, [])';
x = deformed_coord(:, 1);
y = deformed_coord(:, 2);
for i = 1:N_truss
    x_1 = x(n1(i));
    y_1 = y(n1(i));
    x_2 = x(n2(i));
    y_2 = y(n2(i));
    p4 = plot([x_1, x_2], [y_1, y_2], 'r-', 'LineWidth', x_opt5(i)); % Line width proportional to scaling factor
end

axis equal;
title('Sub task 7'), xlabel('x'); ylabel('y');
legend([p1, p2, p3, p4], 'undeformed', 'boundary condition', 'deformed', 'Optimised');
hold off

save Results_V4_Task_7_Crane u_optimized S_optimized







