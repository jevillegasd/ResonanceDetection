function Lamdascan(handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
POWERUNIT = get(handles.pm_ls_unit,'Value')-1;  %% 0 = dBm, 1 = W
POWER = str2num(get(handles.edit_ls_power,'string'));
if POWERUNIT
    POWER=POWER/1000;
end
OPTICALOUTPUT = get(handles.pm_ls_source,'Value')-1; %% 0 = HighPower (Laser Output Port 2), 1 = LowSSE (Laser Output Port 1)                   
STARTWAVELENGTH = str2num(get(handles.edit_ls_start,'string'))/10^9; %% Start wavelength in meters 
STOPWAVELENGTH = str2num(get(handles.edit_ls_stop,'string'))/10^9; %% Stop wavelength in meters   
STEPSIZE = str2num(get(handles.edit_ls_step,'string'))/10^12; %% Step wavelength in meters            
PWMCHANNEL = str2num(get(handles.edit_ls_channel,'string')); %% 0 = 1st PM Channel
SETSWEEPSPEED = get(handles.pm_ls_speed,'Value')-2;   % -1 = 80nm/s 0 = 40nm/s 1 = 20 nm/s, 2 = 10 nm/s, 3 = 5 nm/s, 4 = 500 pm/s
SETINITIALRANGE = str2num(get(handles.edit_ls_range,'string'));


PWMCHANNELS = 3;   %% 1 = 1 Power Meter Channel
NUMBEROFSCANS = 0; %% 0 = 1 Scan, 1 = 2 Scan, 2 = 3 Scan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

deviceObj=get(handles.b_connect,'UserData');

groupObj = get(deviceObj, 'Applicationswavelengthscanfunctionsmultiframelambdascan'); %creating group object to call functions in the group
invoke(groupObj,'registermainframe'); %registering mainframe

invoke(groupObj,'setsweepspeed',SETSWEEPSPEED);

%setting up the parameters for executemflambdascan
[DATAPOINTS,CHANNELS] = invoke(groupObj,'preparemflambdascan',POWERUNIT,POWER,OPTICALOUTPUT,NUMBEROFSCANS,PWMCHANNELS,STARTWAVELENGTH,STOPWAVELENGTH,STEPSIZE);

WAVELENGTHARRAY = zeros(1,DATAPOINTS);

CLIPTOLIMIT = 0; %% 0 = False, 1 = True
CLIPPINGLIMIT = -100; %% Clipping Limit
POWERARRAY = zeros(1, DATAPOINTS);
LAMBDAARRAY = zeros(1, DATAPOINTS);
SETRESETTODEFAULT = 0;
SETRANGEDECREMENT = 30;

invoke(groupObj,'setinitialrangeparams',PWMCHANNEL,SETRESETTODEFAULT,SETINITIALRANGE,SETRANGEDECREMENT);

[WAVELENGTHARRAY] = invoke(groupObj,'executemflambdascan', WAVELENGTHARRAY);
[START,STOP,AVERAGINGTIME,SWEEPSPEED] = invoke(groupObj,'getmflambdascanparametersq');
[POWERARRAY,LAMBDAARRAY] = invoke(groupObj,'getlambdascanresult',PWMCHANNEL,CLIPTOLIMIT,CLIPPINGLIMIT,POWERARRAY,LAMBDAARRAY);

invoke(groupObj,'unregistermainframe');


%% Rest laser
LASERWAV = 1.55e-6; LASERCHANNEL = 1;

TLSmodule=get(deviceObj, 'Tunablelasersources');
invoke(TLSmodule,'settlsparameters', 0,    POWERUNIT,  LASERCHANNEL,         1,POWER,     0,       LASERWAV);
invoke(TLSmodule,'settlslaserstate',0,0);


%% Set the sensor to dBm
PWMUNIT = 0; AVGTIME = 20e-3;
PMWmodule=get(deviceObj, 'Powermetermodules');
invoke(PMWmodule,'setpwmparameters',PWMCHANNEL, 0, 1, PWMUNIT, 1, LASERWAV, AVGTIME, -10);

% setpwmparameters(obj,ChannelNumber, PWMSlot , RangeMode, PowerUnit, InternalTrigger, Wavelength, AveragingTime, PowerRange)
% RangeMode 1=Auto
% PowerUnit 1=W 0=dbm
% AveragingTime must be the number listed in the machine

%% Plot and return
LAMBDAARRAY = 1e9.*LAMBDAARRAY;

plot(LAMBDAARRAY,POWERARRAY,'Marker','.');
xlabel('Wavelength (nm)');
ylabel('Power(dBm)');
% xlim([1e9*STARTWAVELENGTH 1e9*STOPWAVELENGTH]);
%ylim([-ax(POWERARRAY)  -75]);
%ylim([-80 -30])
grid on

result(1, 1:DATAPOINTS)=LAMBDAARRAY;
result(2, 1:DATAPOINTS)=POWERARRAY;

set(handles.p_save,'UserData',result);
