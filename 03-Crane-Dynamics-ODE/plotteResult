function plotteResultate(res)

% ============================================================================================================================
% ============================================================================================================================
r = res;
p = r.par;
t = r.t;

% ============================================================================================================================
l  = p.l;
nr = 0;

% ============================================================================================================================
% Plot der externen Kraft Fe(t)

if isempty(r.Fe)~=1
    
    nr = nr + 1;
    
    figure('Name',[inputname(1),' Abbildung ',num2str(nr)],'NumberTitle','off'); 
    plot(t, r.Fe); 
    xlim([t(1), t(end)]); 
    grid on; 
    title('Aeussere Kraft');  
    xlabel('t');  
    ylabel('Fe');
    
end

% Plot phi, phiD

if (isempty(r.phi)~=1)&&(isempty(r.phiD)~=1)
    
    nr = nr + 1;
    
    figure('Name',[inputname(1),' Abbildung ',num2str(nr)],'NumberTitle','off');
    subplot(1,2,1);
    plot(t, r.phi, t, r.phiD); xlim([t(1), t(end)]); 
    grid on; 
    xlabel('t'); 
    title('Loesung polar');            
    legend('\phi', '\phiD');
    
    subplot(1,2,2);
    plot(r.phi, r.phiD);  
    grid on; 
    xlabel('\phi');
    ylabel('\phiD');
    title('Phasenraumportrait');            
    
end

% Plot der kartesischen Koordinaten x, y, xD, yD

if (isempty(r.x)~=1)&&(isempty(r.y)~=1)&&(isempty(r.xD)~=1)&&(isempty(r.yD)~=1)
    
    nr = nr + 1;
    
    figure('Name',[inputname(1),' Abbildung ',num2str(nr)],'NumberTitle','off'); 
    subplot(1,3,1);
    plot(t, r.x, t, r.y, t, r.xD, t, r.yD); 
    xlim([t(1), t(end)]); 
    grid on; 
    xlabel('t'); 
    title('Loesung kartesisch');       
    legend('x', 'y', 'xD', 'yD');
    
    subplot(1,3,2);
    plot3(r.x, t, r.y); 
    ylim([t(1), t(end)]); 
    grid on;              
    title('Loesung kartesisch in 3D'); 
    xlabel('x'); 
    ylabel('t'); 
    zlabel('y');
    
    subplot(1,3,3); 
    plot(r.x  , r.y  ); 
    grid on; 
    xlabel('x');   
    ylabel('y');     
    title('Positionen');
    
end

% Energieplots

if (isempty(r.T)~=1)&&(isempty(r.V)~=1)&&(isempty(r.E)~=1)
    
    nr = nr + 1;
    
    figure('Name',[inputname(1),' Abbildung ',num2str(nr)],'NumberTitle','off'); 
    plot(t, r.T,  t, r.V,  t, r.E); 
    xlim([t(1), t(end)]); grid on; 
    xlabel('t'); 
    title('Energien');  
    legend('T', 'V', 'E');
    
end

% Plot der Stabkraftkomponenten

if (isempty(r.Zx)~=1)&&(isempty(r.Zy)~=1)&&(isempty(r.Z)~=1)
    
    nr = nr + 1;
    
    figure('Name',[inputname(1),' Abbildung ',num2str(nr)],'NumberTitle','off'); 
    plot(t, r.Zx, t, r.Zy, t, r.Z); 
    xlim([t(1), t(end)]); 
    grid on; 
    xlabel('t'); 
    title('Stabkraft'); 
    legend('Z_x', 'Z_y', 'Z');
    
end

% Plot der Schnittgroessen

if (isempty(r.N)~=1)&&(isempty(r.Q)~=1)&&(isempty(r.M)~=1)&&(isempty(r.X)~=1)
    [xi, tau] = meshgrid(r.X, t);
    
    nr = nr + 1;
    
    figure('Name',[inputname(1),' Abbildung ',num2str(nr)],'NumberTitle','off'); 
    subplot(1,3,1);
    surf(xi, tau,  r.N, 'edgecolor', 'none'); 
    ylim([0, t(end)]); 
    xlim([0, p.L]); 
    xlabel('x'); 
    ylabel('t'); 
    view(2); 
    title('Normalkraft N');
    
    subplot(1,3,2);
    surf(xi, tau,  r.Q, 'edgecolor', 'none'); 
    ylim([0, t(end)]); 
    xlim([0, p.L]); 
    xlabel('x'); 
    ylabel('t'); 
    view(2); 
    title('Querkraft Q');
    
    subplot(1,3,3);
    surf(xi, tau,  r.M, 'edgecolor', 'none'); 
    ylim([0, t(end)]); 
    xlim([0, p.L]); 
    xlabel('x'); 
    ylabel('t'); 
    view(2); 
    title('Moment M');
    
end

% ============================================================================================================================
% ============================================================================================================================

end % function

