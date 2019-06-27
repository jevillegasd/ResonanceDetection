   
    scanData.power = 3;             % Power in dBm (0dBm = 1mW)  
    scanData.starWav =  1400*1e-9;  % start wavelength in m
    scanData.stopWav =  1680*1e-9;  % stop wavelength in m
    scanData.step =     0.1*1e-9;   % Stepsize in meters
    scanData.sweepSpeed = 40*1e-9;  % Sweep speed in m/s
    scanData.range = 10;            % Range in dBm in steps of 10, between [-70 and 40];
    
      
    flushinput(g);
    
    %% Unlock laser
    lockStat = str2double(send(g,'lock?'));
    if lockStat, send(g,'lock 0,1234');end
    
    %% Prepare scan
    [nData,sweepP] = prepareScan(g,scanData);
    
    %% Run Scan
    if sweepP.stat 
        send(g,"outp0 1");
        
        %Starts the logging of data
        send(g,'wav:swe:llog 1');            
        send(g,'sens1:chan1:func:stat logg,star'); 
        
        send(g,'sour0:wav:swe 1');                %Runs the sweep    
    
        %% Wait for sweep to finish
        sweeping = 1;
        while sweeping
            sweeping = str2double(send(g,'sour0:wav:swe?'));
            
        end
    
        %% Turn off laser
        send(g,"outp0 0"); if lockStat, send(g,'lock 1,1234');end

        %% Read Scan Data
        wav = getDataStream(g,'sour0:read:data? llog','double');
        pow = getDataStream(g,'sens1:chan1:func:res?','float');
        send(g,'sens1:chan1:func:stat logg, stop'); 
        
        powdb = 10*log10(pow*1000);
        powdb(powdb < nData.range-60) = nData.range-60;


        plot(wav,powdb);
    
    end
    %fclose(g); 
    
    
    
    
    