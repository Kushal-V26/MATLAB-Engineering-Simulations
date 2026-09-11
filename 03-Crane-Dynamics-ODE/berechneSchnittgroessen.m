function [N, Q, M] = berechneSchnittgroessen(t, X, Zx, Zy, par)

% (AUFGABE 5)
% =========================================================================
% =========================================================================

b   = par.b;
rho = par.rho;
A   = par.A;
L   = par.L;
g   = par.g;

% =========================================================================

nt = length(t);
nx = length(X);

% =========================================================================

% Speicherplatz allokieren

N = zeros(nt, nx);
Q = zeros(nt, nx);
M = zeros(nt, nx);

disp('berechne Kraefte und Momente...');

% =========================================================================

for i = 1:nt % zeit
   
    for j = 1:nx % ort
    % Calculate ϱAg(x - L) term

        
        if (X(j) <= b)
          
            N(i, j) =  -Zx(i);              
            Q(i, j) =  rho * g* A * (X(j) - L)-Zy(i);           
            M(i, j) =  -0.5 * rho*A*g * (X(j) - L)^2 + Zy(i) * (X(j) - b);   
                    
        else
            
            Q(i, j) = rho * g* A * (X(j) - L);        
            M(i, j) = -0.5 * rho*A*g * (X(j) - L)^2;      
            
        end % if
        
    end % for j
end % for i

% =========================================================================
% =========================================================================

end % function
