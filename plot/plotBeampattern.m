function [] = plotBeampattern(xPos, yPos, w, f, c, dBmin, thetaScanningAngles, thetaSteeringAngle)
%plotBeampattern - plots the beampattern for various frequencies
%
%plotBeampattern(xPos, yPos, w, f, c, dBmin, thetaScanningAngles, thetaSteeringAngle)
%
%IN
%xPos                - 1xP vector of x-positions [m]
%yPos                - 1xP vector of y-positions [m]
%w                   - 1xP vector of element weights
%f                   - Wave frequency [Hz]
%c                   - Speed of sound [m/s]
%thetaScanningAngles - 1xN vector of theta scanning angles [degrees]
%thetaSteeringAngle  - 1x1 theta steering angle
%
%OUT
%[]              - The figure plot
%
%Created by J�rgen Grythe, Norsonic AS
%Last updated 2015-10-27


if ~exist('thetaSteeringAngle','var')
    thetaSteeringAngle = 0;
end

if ~exist('theta','var')
    thetaScanningAngles = -90:0.2:90;
end


if ~exist('dBmin','var')
    dBmin = 50;
end

%Linewidth
lwidth = 1;

% Plot beampattern
bpFig = figure;clf
for ff = f
	W = arrayFactor(xPos, yPos, w, ff, c, thetaScanningAngles, 0, thetaSteeringAngle);
    W = 20*log10(W);
    
    
    % Rectangular plot
    subplot(211)
    plot(thetaScanningAngles,W,'DisplayName',[num2str(ff*1e-3) ' kHz'],'linewidth',lwidth);
    hold on
    
    % Polar plot
    subplot(212)
    p = mmpolar(thetaScanningAngles*pi/180,W,...
    'Style','Compass',...
    'RLimit',[-dBmin 0],...
    'TLimit',[-pi/2 pi/2],...
    'RGRidLineStyle',':',...
    'TGRidLineStyle',':',...
    'RGridVisible','on',...
    'TGridVisible','on',...
    'RTickValue',[-10 -20 -30 -40],...
    'TTickValue',[-80 -60 -40 -20 0 20 40 60 80]);


    hold on
end

subplot(211)
xlabel('Angle (deg)')
ylabel('Attenuation (dB)')

grid on
axis([thetaScanningAngles(1) thetaScanningAngles(end) -dBmin 0])
legend('show','Location','NorthEast')

set(gca,'YTick',[-50 -45 -40 -35 -30 -25 -20 -15 -10 -6 -3 0])

set(gca,'XTick',[-90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90])
set(gca,'XTickLabel',{'-90','-80','-70','-60','-50','-40','-30','-20','-10','0'...
    ,'10','20','30','40','50','60','70','80','90'})

cmap = {[0 0.4470 0.7410],...
    [0.8500 0.3250 0.0980],...
    [0.9290 0.6940 0.1250],...
    [0.4940 0.1840 0.5560],...
    [0.4660 0.6740 0.1880],...
    [0.3010 0.7450 0.9330],...
    [0.6350 0.0780 0.1840]};

pline = findobj(p, 'type', 'line');
for j = 1:length(f)
    set(pline(j),'Color',cmap{j},'linewidth',lwidth)
end

set(bpFig,'position',[500 200 540 600])