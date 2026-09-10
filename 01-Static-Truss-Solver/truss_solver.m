%Task 2
[filename, pathname] = uigetfile('*.mat');
filepath = [pathname, filename];
input = load(filepath);
bearings = input.bearing;
coord_of_nodes = input.coord;
conn_matrix = input.conn;
Forces = input.F;

%Task 3
x = coord_of_nodes(:,1);
y = coord_of_nodes(:,2);
a = size(bearings,1);
%disp(num_of_bearings);
s = size(conn_matrix,1);
k = size(x,1);
%disp(num_of_nodes);
num_of_forces = size(Forces,1);
f = 2*(k) - ((a)+(s));
%disp(f);
disp(['Degree of freedom = ',num2str(f)]);
fa = 3 - a;
f1 = figure;
hold on;
filenamechange=split(filename,".");
filenamechange2=split(filenamechange(1,1),"_");
truss_num=filenamechange2(2,1);
title("Truss " + truss_num);
subtitle(['Degree of freedom = ',num2str(f)]);
for i = 1: s
    A = conn_matrix(i,1);
    B = conn_matrix(i,2);      
    x1 = coord_of_nodes(A,1);
    x2 = coord_of_nodes(B,1);
    y1 = coord_of_nodes(A,2);
    y2 = coord_of_nodes(B,2);     
    plot1 = plot([x1, x2], [y1, y2], '-ok');
    text((x1 + x2)/2, (y1 + y2)/2, sprintf('%d', i));
end
for i = 1: a
    A = bearings(i,1);
    B = bearings(i,2);
    x = coord_of_nodes(A,1);
    y = coord_of_nodes(A,2);
    if B == 1
        plot2 = plot(x - 0.1, y, 'r>');
    else
        plot2 = plot(x, y - 0.1, 'r^');
    end
end
for i = 1: num_of_forces
    A = Forces(i,1);
    x = coord_of_nodes(A,1);
    y = coord_of_nodes(A,2);
    plot3 = quiver(x, y, Forces(i,2), Forces(i,3), 'MaxHeadSize', 1 / norm(Forces(i,2:3)), 'color', 'b');
end
axis equal;
legend([plot1, plot2, plot3], 'Bars', 'Bearings', 'Forces','location','southeast');
hold off;

% Task 4
if (f > 0 || fa > 0)
    error('Conditions for the rigidity and load-bearing capacity of the truss are not satisfied');
else
    disp('Conditions for the rigidity and load-bearing capacity of the truss are satisfied')
end

if f == 0
    disp('statically determined')
elseif f < 0
    disp('statically undetermined')
else
    disp('moveable')
end

% Task 5
angles = [s, 2];
for i = 1: s
    A = conn_matrix(i,1);
    B = conn_matrix(i,2);
    dx = coord_of_nodes(B,1) - coord_of_nodes(A,1);
    dy = coord_of_nodes(B,2) - coord_of_nodes(A,2);
    angles(i,1) = atan(dy / dx);
    angles(i,2) = atan2(-dy, -dx);
end

% Task 6
n = 2 * k;
A = zeros(n, n);
F = zeros(n, 1);

for i = 1: a
    bearing_force_index = 2 * (bearings(i,1) - 1) + bearings(i,2);
    A(bearing_force_index, i) = 1;
end

for i = 1: s
    bar_force_localnode = conn_matrix(i,1);
    bar_force_row = ((bar_force_localnode - 1) * 2 + 1);
    bar_force_column = i + a;
    A(bar_force_row, bar_force_column) = cos(angles(i,1));
    A(bar_force_row + 1, bar_force_column) = sin(angles(i,1));

    bar_force_localnode = conn_matrix(i,2);
    bar_force_row = ((bar_force_localnode - 1) * 2 + 1);
    bar_force_column = i + a;
    A(bar_force_row, bar_force_column) = cos(angles(i,2));
    A(bar_force_row + 1, bar_force_column) = sin(angles(i,2));
end

for i = 1: num_of_forces
    bar_force_row = (Forces(i,1) - 1) * 2 + 1;
    F(bar_force_row) = Forces(i,2);
    F(bar_force_row + 1) = Forces(i,3);
end
r = A \ (-F);

% Task 7
f2 = figure;
hold on
title("Truss " + truss_num);

subtitle(['Degree of freedom = ',num2str(f)]);
Plot4yes = 0;
Plot5yes = 0;
Plot6yes = 0;
for i = 1: s
    bar_force_row = i + a;
    Si = r(i + a, 1);
    A = conn_matrix(i,1);
    B = conn_matrix(i,2);
    x1 = coord_of_nodes(A,1);
    x2 = coord_of_nodes(B,1);
    y1 = coord_of_nodes(A,2);
    y2 = coord_of_nodes(B,2);
    
    if Si > 1e-13
        Plot4 = plot([x1, x2], [y1, y2], '-og');
        Plot4yes = 1;

    elseif Si < -10^(-13)
        Plot5 = plot([x1, x2], [y1, y2], '-or');
        Plot5yes = 1;
    else
        Plot6 = plot([x1, x2], [y1, y2], '-ob');
        Plot6yes = 1;
    end
    text((x1 + x2) / 2, (y1 + y2) / 2, sprintf('%d', i));
end

for i = 1: a
    A = bearings(i,1);
    B = bearings(i,2);
    x = coord_of_nodes(A,1);
    y = coord_of_nodes(A,2);
    if B == 1
        plot2 = plot(x - 0.1, y, 'k>');
    else
        plot2 = plot(x, y - 0.1, 'k^');
    end
end

for i = 1: num_of_forces
    A = Forces(i,1);   
    x = coord_of_nodes(A,1);
    y = coord_of_nodes(A,2);
    p3 = quiver(x, y, Forces(i,2), Forces(i,3), 'MaxHeadSize', 1 / norm(Forces(i,2:3)), 'color', 'k');
end


if (Plot4yes == 1 && Plot5yes == 1 && Plot6yes == 1)
    legend([Plot4, Plot5, Plot6], 'Tension bar','Compression bar','Zero Force bar','location','southeast');
elseif (Plot4yes == 1 && Plot5yes == 1)
    legend([Plot4, Plot5], 'Tension bar', 'Compression bar','location','southeast');
else
    legend(Plot6, 'Zero Force bar');
end
axis equal;

hold off;

%Task8
%save('Results_truss.mat')
