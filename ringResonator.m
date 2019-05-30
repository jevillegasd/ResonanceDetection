% Data = {TE1,TE2,TE3,TE4,TE5}
% param = [1570, 15e3, 15,  0.1]
% param = [cenWav, r, pt,  windowSc]
%     cenWav = 1570;  %Resonance frequency around which analyze the Ring  
%     r = 15e3;% ring resonator radius in nm
%     pt = 15; %Resonance peak prominence threshold
%     windowSc = 0.1; %scale of bandwidth to analyze one resonance (FSR*windowSc)
function [S, O] = ringResonator(Data, param)
    %Extract ring resonator parameeters from power measuremnt data in dBm
    %Juan Esteban Villegas, Masdar Institute, 2018
    cenWav = param(1); r = param(2); pt = param(3); windowSc = param(4);
    
    %% Initialize outputs
    FSR = zeros(1,length(Data));
    Q = FSR; FWHM = FSR; ng = FSR; alpha = FSR; alphadB = FSR;
    
    %% Measurement of FSR for all the data
    for i=1:length(Data)
        F = Data{i}';
        E = F(:,2);x = F(:,1);
        
        E(E==min(E)) = mean(E); %Clear zero power peaks

        %% Find field peaks
        [pks,locs] = findpeaks(E,'MinPeakProminence',pt,'Annotate','extents'); 
        dv =  diff(x(locs));
        subplot(2,1,1); cla; grid on; hold on;
        plot(x,E,x(locs),pks,'V','MarkerFaceColor','red');
        
        %% Estimate the FSR and peak that corresponds to an objective peak
        if ~isempty(pks)
            [dx, locm] = min(abs(cenWav-x(locs))); %Find resonance closer to the reference one
            peakloc = locs(locm);
            lambda0 = x(peakloc);
            FSR(i) = dv(min(locm,length(dv))); 
        else
            disp 'No sufficent peaks found, using previous FSR'
            FSR(i) = FSR(i-1);
            [maxy, locm] = max(E);
            lambda0 = x(locm);
        end
        

        %% Extract the region around the interested resonance
        dlambda = FSR(i)*windowSc;
        minx = lambda0 - dlambda/2;  maxx = lambda0 + dlambda/2; 
        x2 =x(x>minx&x<maxx);
        clear E2
        E2 = E(x>minx &x <maxx);
        
        %% Measure the FWHM at the resonance
        subplot(2,1,2); cla; hold on;
        FWHM(i) = getFWHM([x2,E2],FSR(i));
        hold off;
        %% Compute resonator parameters
        
        Q(i) = lambda0/FWHM(i);
        ng(i)= lambda0^2/(2*pi*r*FSR(i));
        alpha(i) = 2*pi*ng(i)/lambda0^2*FWHM(i)*1e9; %power fraction per m
        alphadB(i) = 0.1*alpha(i)/log(10); %
        
        disp(strcat('FSR (nm):',num2str(FSR(i)),'nm / FWHM (nm):',num2str(FWHM(i))));
        pause
    end
    
    %Fill output variables
    S.FSR = FSR;     S.FWHM = FWHM;
    O.Q = Q;     O.ng = ng;     O.alpha = alpha;     O.alphadB = alphadB;
end


function[fwhm]=getFWHM(data,FSR)
    %Find FWHM for raw power data measurements in dBm of one resonance peak
    %Data should be centered in the interested resonance
    %Juan Esteban Villegas, Masdar Institute, 2018
    x = data(:,1); y= data(:,2); 

    ind = round(length(x)/2); cp = x(ind); %Central peak info
    %[maxy, ind] = max(y);  
    
    %% Change axis of data and center around the resonance
    my = min(y);
    ny(:,1) = x-cp;
    ny(:,2) = (y-my);
    maxny = ny(ind,2);  
    %% Fit the data to the expected power function of the resonator
    equ =  sprintf('I/(1+(4*a/(1-a)^2)*(sin(phi/2+ps)^2))'); 
    %ps is a small phase shift given that the maximum value could not
    %correspond to the actual resonance in the ring due to noise
    up = [maxny+20, 1, pi/20]; low = [maxny, 0,-pi/20]; start = [maxny+10, 0.99, 0];
    myfittype = fittype(equ,'independent',{'phi'});
    opts = fitoptions( 'Method', 'NonlinearLeastSquares','Upper',up,'Lower',low,'StartPoint',start );
    
    plot(x,ny(:,2)+min(y)); grid on; hold on; %Plot input spectrum
     phi = 2*pi/FSR*ny(:,1);         %Phase shift
     myfit1 = fit(phi,ny(:,2),myfittype,opts);
     a = myfit1.a; fitmax = myfit1.I;
     newy1 = fitmax./(1+(4*a/(1-a)^2).*(sin(phi/2)).^2);
     plot(x,newy1+my); grid on; %Plot fitted spectrum
     
     %% Get the FWHM of the fitted function plot
     x2 = x(x>cp-FSR/2&x<cp+FSR/2); y2 = newy1(x>cp-FSR/2&x<cp+FSR/2); %Measure FWHM only in the max peak (if more than one)
     [fwhm, sp]= find_fwhm([x2 y2]);     
     plot(sp,[fitmax-3+my fitmax-3+my],'marker','o');
end

function[fwhm, sp]=find_fwhm(data)
    %Find FWHM for noize free diferentiable data in dBm
    %Juan Esteban Villegas, Masdar Institute, 2018
    %Based on code by Ebo Ewusi-Annan / University of Florida/August 2012
    x = data(:,1); y = data(:,2);
    
    %% Spline approximation method
    y_lin = 10.^(y./10); %Data from dB to power fraction
    [maxy, cen_i] = max(y_lin);  
    y1= y_lin./maxy; 
    ydata(:,1) = y1; ydata(:,2) = x;
    lh = ydata(1:cen_i,:);
    rh = ydata(cen_i:length(x),:);
    sp1 = spline(lh(:,1),lh(:,2), 0.5); %fit a transversal spline to a value of -3dB the maximum
    sp2 = spline(rh(:,1),rh(:,2), 0.5); %fit a spline to a value of -3dB the maximum
    sp = [sp1 sp2];
    fwhm = diff(sp);
 end
