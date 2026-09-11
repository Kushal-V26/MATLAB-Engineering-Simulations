function res = analyseKran(solver,Tol,szenario,res)

% =========================================================================
% =========================================================================

par     = parameter(solver,Tol,szenario);                   % Einlesen der Parameter
res.par = par;          % erstes Resultat der Simulation sind die Parameter 

% =========================================================================
% Ergebnisse

res.phi   = [];     res.phiD  = [];     res.phiDD = [];
res.x  = [];        res.xD = [];        res.xDD = [];                                            
res.y  = [];        res.yD = [];        res.yDD = [];

res.T = [];         res.V = [];         res.E = [];

res.Zx = [];        res.Zy = [];        res.Z = [];

res.N = [];         res.Q = [];         res.M = [];

res.sigma = [];     res.tau = [];

res.Fe =  [];       res.X = [];                                         

% =========================================================================
% Startwerte des Anfangswertproblems (t = 0)

phi0  = par.phi0;                       % Anfangswinkel
phiD0 = par.phiD0;                      % Anfangswinkelgeschwindigkeit
tEnd  = par.tEnd;                       % Simulationszeit

u0    = [phi0; phiD0];                  % Zustandsvektor zum Zeitpunkt Null

% =========================================================================
% Parameter fuer die Zeitintegration

disp('Zeitintegration ...'); 

solver  = par.solver;                           % Solver
odeopts = par.odeopts;                          % Parameter fuer den Loeser

% =========================================================================
% Zeitintegration

tic;

switch solver
    
    case 'ode45'  % Explizites Runge-Kutta-Verfahren von Dormand und Prince
        sol = ode45 (@f, [0 tEnd], u0, odeopts, par); 

    case 'ode23'  % Explizites Bogacki-Shampine method
        sol = ode23(@f, [0 tEnd], u0, odeopts, par); 

end % switch


toc;

% =========================================================================
% Auslesen und Speichern der Ergebnisse

t = sol.x.';          % numerisch berechnete Stellen t der Loesung u(t)
u = sol.y.';          % numerisch berechnete Loesung u zu den Zeitpunkten t

res.sol = sol;             % Abspeichern der Ergebnisse
res.t   = t;               % Zeitpunkte
res.u   = u;               % phi und phiD an den entsprechenden Zeitpunkten

% =========================================================================
% Postprocessing und Plotten der Resultate

res = postprocessing(res); toc;                            % Postprocessing    

% =========================================================================
% =========================================================================

end % function
