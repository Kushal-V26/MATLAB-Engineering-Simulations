% =========================================================================
% =========================================================================
% Praktikum MATLAB
% Versuch 'Dynamischer Kran'
% Lehrstuhl fuer Technische Dynamik
% Friedrich-Alexander Universitaet Erlangen Nueremberg
% Immerwahrstrasse 1
%
%
% Hauptskript 'Kran'
% =========================================================================
% =========================================================================

clear;                  % Arbeitsspeicher loeschen
clc;                    % Kommandozeile loeschen
format  long e;         % Anzeige Fliesskommaarithmetik lang (vollstaendig)
format short e;         % Anzeige Fliesskommaarithmetik kurz

szenario = 'C';         % Auswahl des Berechnunsszenarios
Vgl = 1;                % Aktivierung des Vergleichs von ode45 und ode23

% =========================================================================
% =========================================================================

% Analyse mit ode 45 

solver = 'ode45';       % Auswahl des Solvers
Ex = 4;
Tol = 10^-Ex;           % Toleranz festlegen
resOde45 = struct;

resOde45 = analyseKran(solver,Tol,szenario,resOde45);  % Aufruf der Analyse


% Plotten der Resultate
 
plotteResultate(resOde45);                             % Resultate plotten

% Film

filmSpannungen(resOde45);





% (AUFGABE 7)
% =========================================================================
% =========================================================================

% Analysen mit ode23 bei verschiedenen Toleranzen

le = cell(8,1);

if Vgl == 1

    figure('Name','Vergleich','NumberTitle','off');
    
    % Plot der Gesamtenergie E aus resOde45:
    plot(resOde45.t, resOde45.E);
    
    le{1} = ['ode45, Tol = 10^{-',num2str(Ex),'}'];
    hold on;

    for Ex = 2:8

        solver = 'ode23';       % Auswahl des Solvers
        Tol = 10^-Ex;           % Toleranz festlegen
        resOde23 = struct;
        
        % Aufruf von analyseKran.m
        resOde23 = analyseKran(solver,Tol,szenario,resOde23);
        
        % Plot der Gesamtenergie E aus resOde23:
        plot(resOde23.t, resOde23.E);

        le{Ex} = ['ode23, Tol = 10^{-',num2str(Ex),'}'];

    end % for
    
    % Legende und Achsenbeschriftung
    
    xlabel('t');
    title('Vergleich Solver');
    legend(le);
    ylabel('E');
    hold off;
    
end % if

% =========================================================================
% =========================================================================
