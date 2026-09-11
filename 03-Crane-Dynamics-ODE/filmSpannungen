function filmSpannungen(res)

% (AUFGABE 6)
% =========================================================================
% =========================================================================

figNr = 16;

% =========================================================================

sigma = res.sigma*10^-6;                    % Normalspannung als 3D-Array
t     = res.t;                              % Zeit
L     = res.par.L;                          % Laenge des Kragarms in m 
a     = res.par.a;                          % Halbe Dicke des Kragarms in m

% =========================================================================

nx = size(sigma, 1);                                % Longitudinaldimension
ny = size(sigma, 2);                                % Transversaldimension
nt = size(sigma, 3);                                % Zeitdimension

% =========================================================================

S_min = min(sigma,[],"all");                                  % Minimum des 3D-Arrays sigma
S_max = max(sigma,[],"all");                                  % Maximum des 3D-Arrays sigma

% =========================================================================

figure(figNr);
hold on;
set(gca,'YDir','reverse');

videoStress = VideoWriter(['videoStress_',inputname(1),'Szenario',res.par.szenario],'MPEG-4');
videoStress.FrameRate = 30;

open(videoStress);

% =========================================================================

for k = 1:nt
    
    % Spannungen zum Zeitpunkt t_k  
    s = sigma(:,:,k);
    
    % Figure erstellen
    figure(figNr);
    s = s.';
    
    % Normalspannungsverteilung darstellen
    imagesc(s); 
    
    % Titel und Achsenbeschriftung
    title(['sigma,    t =  ',num2str(t(k)),' s, sigma_{min} = ',...
        num2str(S_min),' N/mm^2, sigma_{max} = ',...
        num2str(S_max),' N/mm^2']);
    
    xticks(linspace(1,nx,L+1));
    xticklabels(num2cell(0:L));
    xlabel('x in m');
    yticks(linspace(1,ny,3));
    yticklabels({num2str(-a),'0',num2str(a)});
    ylabel('y in m');
    
    colormap(jet);                        % Farbgebung spezifizieren  
    color_b=colorbar;                        % Farbskala einblenden
    color_b.Label.String= 'sigma in N/mm^2;´';                     % Farbskala beschriften
    axis image;
    
    fr = getframe(gcf);
    writeVideo(videoStress, fr);
    
end % for k

hold off
close(videoStress);
    
% =========================================================================
% =========================================================================

end % function
