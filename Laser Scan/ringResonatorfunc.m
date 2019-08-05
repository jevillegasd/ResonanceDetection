function [O] = ringResonatorfunc(Data,pks,locs,param)

%Extract ring resonator parameeters from power measuremnt data in dBm
    %Juan Esteban Villegas, Masdar Institute, 2018
    %edited by Hadi Assadi NYUAD, summer 2019
    % param = [S, windowSc, n_eff]
    % S = the length of resonanace cavity 
    % windowSc = 0.1; %scale of bandwidth to analyze one resonance (FSR*windowSc)
    % n_eff =  effective index of refraction 
     S = param(1);  windowSc = param(2); n_eff = param(3); 
    
    %% Initialize outputs
    l = length(pks);
    empty = zeros(1,l); 
    Q = empty; FWHM = empty; ng = empty; alpha = empty; alphadB = empty; FSR = empty;
   
  % assigning the data to x and y axes      
        D = cell2mat(Data);
        E = D(:,2);
        x = D(:,1);
        
   %looping through the data for each peak      
      
   %% select the peak in succession
        if ~isempty(pks)
            if l == 1
             FSR = (x(locs(1)))^2/S*n_eff^2;
            else
                %Calculate the FSR as the differenes in the peak
                %wavelengths
                FSR = diff(x(locs));   % finds the distance between peaks    
                FSR(end+1)= FSR(length(FSR)); % appending fsr's last element to itself to make it of equal length to peaks
            end  
            
            for i = 1:l  
             lambda0 = x(locs(i));
             
             %% Extract the region around the interested resonance peak
                dlambda = FSR(i)*windowSc;
                minx = lambda0 - dlambda/2;  maxx = lambda0 + dlambda/2; 
                x2 = x(x>minx & x<maxx);
                clear E2
                E2 = E(x>minx & x <maxx);

             %% Measure the FWHM at the resonance using the function below 
                 FWHM(i) = getFWHM([x2,E2],FSR(i));
             %% Compute resonator parameters
                Q(i) = lambda0/FWHM(i);
                ng(i)= lambda0^2/(S*FSR(i));
                alpha(i) = 2*pi*ng(i)/lambda0^2*FWHM(i)*1e9; %power fraction per m
                alphadB(i) = 0.1*alpha(i)/log(10); %

            end
             
        else
            disp 'No sufficent peaks found, using previous FSR'
         
        end
    
    %Fill output variables
    O.FSR = FSR;     O.FWHM = FWHM;
    O.Q = Q;     O.ng = ng;     O.alpha = alpha;     O.alphadB = alphadB;
end

%     windowSc = 0.1; %scale of bandwidth to analyze one resonance (FSR*windowSc)

function[fwhm]=getFWHM(data,FSR)
    %Find FWHM for raw power data measurements in dBm of one resonance peak
    %Data should be centered in the interested resonance
    %Juan Esteban Villegas, Masdar Institute, 2018
     x = data(:,1); y = data(:,2); 
    
    ind = round(length(x)/2); cp = x(ind); %Central peak info
    %[maxy, ind] = max(y);  
    
    %% Change axis of data and center around the resonance
    my = min(y);
    ny(:,1) = x-cp;
    ny(:,2) = (y-my);
    maxny = ny(ind,2);  
    %% Fit the data to the expected power function of the resonator
    equ =  sprintf('I/(1+(4*a/(1-a)^2)*(sin(phi/2+ps)^2))'); %this is a lorenzian-cauchy distribution 
    %ps is a small phase shift given that the maximum value could not
    %correspond to the actual resonance in the ring due to noise
    up = [maxny+20, 1, pi/20]; low = [maxny, 0,-pi/20]; start = [maxny+10, 0.99, 0];
    myfittype = fittype(equ,'independent',{'phi'});  %this is a fitting the data to the lorenzian-cauchy distribution  
    opts = fitoptions( 'Method', 'NonlinearLeastSquares','Upper',up,'Lower',low,'StartPoint',start );
      
     phi = 2*pi/FSR*ny(:,1);         %Phase shift
     myfit1 = fit(phi,ny(:,2),myfittype,opts);
     a = myfit1.a; fitmax = myfit1.I;
     newy1 = fitmax./(1+(4*a/(1-a)^2).*(sin(phi/2)).^2);
     
     %% Get the FWHM of the fitted function plot
     x2 = x(x>cp-FSR/2&x<cp+FSR/2); y2 = newy1(x>cp-FSR/2&x<cp+FSR/2); %Measure FWHM only in the max peak (if more than one)
     [fwhm, sp]= find_fwhm([x2 y2]);     
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
