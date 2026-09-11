function uD = f(t, u, par)

% (AUFGABE 1)
% =========================================================================
% =========================================================================
% Dynamische rechte Seite des Kranpendels 

disp(t);                               % Kontrolle waehrend Zeitintegration

% =========================================================================
% Benoetigte Parameter auslesen

m = par.m;                                            % Masse
d = par.d;                                            % Daempfungsparameter
g = par.g;                                            % Erdbeschleunigung
l = par.l;                                            % Laenge des Pendels

% =========================================================================
% Zustandsvektor auslesen

u     = u(:);                             % ggf. zum Spaltenvektor umformen

phi   = u(1);                             % Winkelkoordinate phi
omega = u(2);                             % Winkelgeschwindigkeit omega

% =========================================================================
% Externe Kraft zum Zeitpunkt t einlesen

Fe = externeKraft(t,par);   

% =========================================================================
% Bewegungsdifferentialgleichung (erster Ordnung)

phiD   = omega;                                     % Winkelgeschwindigkeit
omegaD = (1 / (m * l^2)) * (-m * g * l * sin(phi) - d * l^2 * omega + Fe * l); % Winkelbeschleunigung

% =========================================================================
% Zeitableitung des Zustandsvektors

uD = zeros(size(u));           % Dimensionen von uD identisch mit der von u

uD(1) = phiD;                                    % Winkelgeschwindigkeit
uD(2) = omegaD;                                   % Winkelbeschleunigung
% =========================================================================
% =========================================================================

end % function
