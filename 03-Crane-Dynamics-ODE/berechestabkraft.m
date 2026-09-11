function [phiDD, xDD, yDD, Z, Zx, Zy] = berechneStabkraft(t, phi, phiD, par)

% (AUFGABE 4)
% =========================================================================
% =========================================================================
% Parameter auslesen

m = par.m;
h = par.h;
b = par.b;
l = par.l;
g = par.g;
d = par.d;

% =========================================================================
% Speicherplatz allokieren

N = length(t);

% Beschleunigungen
phiDD = zeros(N ,1);
xDD = zeros(N, 1);
yDD = zeros(N, 1);

% Stabkraft
Zx = zeros(N, 1);
Zy = zeros(N, 1);

% Radialkomponente Z der Stabkraft
Z = zeros(N ,1);

disp('berechne Stabkraft');

% =========================================================================
% Berechnung von phiDD, xDD, yDD, Zx und Zy zu jedem Zeitschritt

for n = 1:N
    
    Fe = externeKraft(t,par);
        
    A = [m*l^2, 0, 0, 0, 0;
        -l*cos(phi(n)), 1, 0, 0, 0;
        -l*sin(phi(n)), 0, 1, 0, 0;
        0, m, 0, -1, 0;
        0, 0, m, 0, -1];
    
    Y = [-m*g*l*sin(phi(n)) - d*l*phiD(n) + Fe*l;
        -l*phiD(n)^2*sin(phi(n));
        l*phiD(n)^2*cos(phi(n));
        -d*l*phiD(n)*cos(phi(n)) + Fe*cos(phi(n));
        -m*g - d*l*phiD(n)*sin(phi(n)) + Fe*sin(phi(n))];
    
    X = A \ Y;
    
    % Beschleunigungen
    phiDD(n) = X(1);
    xDD(n) = X(2);
    yDD(n) = X(3);  
    
    % Zwangskraftkomponenten
    Zx(n) = X(4);
    Zy(n) = X(5);
    
    % Berechne Radialkomponente Z der Stabkraft
    Z(n) = sqrt(Zx(n)^2 + Zy(n)^2);
    
end % for n

% =========================================================================
% =========================================================================

end % function

