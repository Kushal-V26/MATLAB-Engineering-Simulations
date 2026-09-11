function par = parameter(solver,Tol,szenario)

% =========================================================================
% =========================================================================
% Allgemeine unabhaengige Modellparameter, Default

g   = 9.81;                        % Erdbeschleunigung in m/s^2
h   = 20;                          % Hoehe des Kranmasts in m
rho = 2700;                        % Dichte des Kragarms in kg/m^3
L   = 18;                          % Laenge des Kragarms in m
b   = 15;                          % Aufhaengestelle in m
l   = 0.8*b;                       % Laenge der Pendelstange in m
a   = 0.25;                        % Halbe Dicke des Kragarms in m
c = 0.2;                           % Breite des Kragarms in m

m   = 1000;                        % Masse der Pendellast in kg
d   = 0.8;                         % Daempfungsparameter

tEnd = 2;                          % physikalische Simulationszeit

% =========================================================================
% Default-Parameter fuer die Zeitintegration

relTol      = Tol;                  %               absolute Fehlertoleranz
absTol      = Tol;                  %               relative Fehlertoleranz
initialStep = 1.0E-3;               %               Anfangszeitschrittweite
maxStep     = Inf;                  %             Maximale Zeitschrittweite
maxOrder    = 1;                    %    Maximale Ordnung bei BDF-Verfahren
refine      = 1;                    % Interpolation der numerischen Loesung

% =========================================================================
% Wahl des Berechnungsszenarios

switch szenario
    
    % ---------------------------------------------------------------------
    % stabiles statisches Gleichgewicht am Tiefpunkt
    case 'a'
        
        phi0  = 0;      
        phiD0 = 0;  
        
        d = 0;
        
        tEnd = 20;

    % ---------------------------------------------------------------------
    % gleichfoermige Kreisbewegung ohne Schwerkraft
    case 'b'
        
        phi0  = 0;      
        phiD0 = 1;   
        
        d = 0;
        g = 0;
        
        tEnd = 20;
        
        maxStep = tEnd / 100;

    % ---------------------------------------------------------------------
    % Pendelbewegung 
    case 'c'
        
        phi0  = 0.05;      
        phiD0 = 0.5;       
        
        d = 0;


        tEnd = 20;

        maxStep = tEnd / 100;
                
    % ---------------------------------------------------------------------
    % Pendelbewegung mit Daempfung
    case 'd'
        
        phi0  = -0.1;      
        phiD0 = 1;       
        
        d = 50;


        tEnd = 20;

        maxStep = tEnd / 100;
        
    % ---------------------------------------------------------------------
    % Externer Kraft
    case 'e'
        
        phi0  = 0;
        phiD0 = 0;
        
        d = 1;
        
        tEnd = 20;
        
        par.FeMax = 1000;
        
        maxStep = tEnd / 100;
        
end % switch

% =========================================================================
% Parameter fuer die Zeitintegration

odeopts = odeset(...
   'reltol'     , relTol,      ...  %               absolute Fehlertoleranz
   'abstol'     , absTol,      ...  %               relative Fehlertoleranz
   'initialstep', initialStep, ...  %               Anfangszeitschrittweite
   'maxstep'    , maxStep,     ...  %             Maximale Zeitschrittweite
   'maxorder'   , maxOrder,    ...  %    Maximale Ordnung bei BDF-Verfahren
   'refine'     , refine);          % Interpolation der numerischen Loesung

% =========================================================================
% abhaengige Modellparameter     

A   = 2 * a * c;                                 % Flaecheninhalt
I   = 1/12 * c * (2*a)^3;                        % Flaechentraegheitsmoment

% =========================================================================
% Modellparameter im Struct 'par' speichern
  
par.h   = h;    par.L   = L;    par.g   = g;      par.m   = m;
par.l   = l;    par.d   = d;    par.b   = b;      par.a   = a;
par.A   = A;    par.I   = I;    par.rho = rho;    par.Tol = Tol;
par.szenario = szenario; 

% =========================================================================
% Anfangswerte als Parameter in 'par' speichern

par.phi0  = phi0;
par.phiD0 = phiD0;

% =========================================================================
% Parameter fuer die Zeitintegration in 'par' speichern

par.szenario = szenario;
par.solver   = solver;
par.odeopts  = odeopts;
par.tEnd     = tEnd;

% =========================================================================
% =========================================================================

end % function
