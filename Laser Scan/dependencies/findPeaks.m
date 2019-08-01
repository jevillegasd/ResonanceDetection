function [pks,wav,FSR]=getPeaks(data,filterStat,filterParam)
%% Function to find the peaks from on a plot
    if isempty (data)    
     return         
    end
    pks = {}; wav= {}; FSR = {};
    E = data(:,2);
    x = data(:,1);

    [m] = size(x,1); %units
    R = 1e9 * (x(m)-x(1)); %nm
    Distunit = R/m; %nm/units

    nullHeight = -120;
    nullProminence = 0;
    nullMaxWidth = 100;
    nullMinWidth = 0;
    nullDistance = 0;

    for j = 1:length(filterStat)
        fstat = filterStat{j};
        fparam = filterParam{j};
        
        factive = fstat(1)|fstat(2)|fstat(3)|fstat(4)|fstat(5);
        if (factive)
            if fstat(1), Height = fparam(1); else, Height = nullHeight; end 
            if fstat(2), Prominence = fparam(2); else, Prominence = nullProminence; end            
            if fstat(3),   MaxWidth = round (fparam(3)/Distunit); else, MaxWidth = nullMaxWidth;   end
            if fstat(4),  MinWidth = round (fparam(4)/Distunit); else, MinWidth = nullMinWidth;  end
            if fstat(5), Distance = round (fparam(5)/Distunit); else, Distance = nullDistance;   end

            [pks{j},locs]= findpeaks(E,'MinPeakHeight',Height,'MinPeakProminence', Prominence,'MaxPeakWidth', MaxWidth, 'MinPeakWidth', MinWidth, 'MinPeakDistance', Distance,'Annotate','extents');
            wav{j} = x(locs);
            
            dv =  diff(wav{j});   % Free spectral range (distance between peaks.   
            dv(end+1)=dv(length(dv)); %appending FSR's last element to itself
            FSR{j} = dv;
        end
    end 
end