function [T, V, E] = berechneEnergien(t, x, y, xD, yD, par)

% (AUFGABE 3)
% =========================================================================
% =========================================================================

g = par.g;
l = par.l;
m = par.m;

% =========================================================================

disp('Rechenzeitvergleich Postprocessing Energien');
disp('Vektorisierte Berechnung ...');

tic;

T = 0.5 * m  * (xD.^2 + yD.^2);    
V = m * g  * (l+y );                
E = T + V;                      

toc;


% =========================================================================
% =========================================================================

N = length(t);

% =========================================================================
% For - Schleifen mit vorheriger Speicherallokation

disp('For-Schleifen mit Speicherallokation...');

tic; 

T = zeros(N, 1);
V = zeros(N, 1);
E = zeros(N, 1);

for n = 1:N
    
    T(n) =  0.5 * m  * (xD(n).^2 + yD(n).^2);   
    V(n) = m * g *(l+y(n) );                     
    E(n) = T(n) + V(n);                         
    
end % for n

toc;

% =========================================================================
% For - Schleifen ohne vorheriger Speicherallokation

clear T
clear V
clear E

disp('For-Schleifen ohne Speicherallokation...');

tic;

for n = 1:N
    
    T(n) = 0.5 * m * (xD(n).^2 + yD(n).^2);   
    V(n) = m * g * (l+y(n));                     
    E(n) = T(n) + V(n);                          
    
end % for n

toc;

% =========================================================================
% =========================================================================

end % function
