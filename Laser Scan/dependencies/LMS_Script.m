%% Open the connection an read the ID (to test)
g = gpib('keysight',32,7)
fopen(g)
id = send(g,'*IDN?')

%% Turn on the laser at a specific wavelength and power
send(g,"outp "+1); %turn on the laser
laserStat = send(g,"outp?");
pow = 3; %dBm
send(g,"sour0:chan1:pow " + num2str(pow,'%5.0f'));
wav = 1550;
send(g,"sour0:chan1:wav " + num2str(wav,'%5.3f')+'nm');

%% Read the power sensor
avgT = 0.2; %Averaging time in secons
send(g,"sens1:pow:atim "+ num2str(avgT,'%5.2f') + 's');
send(g,"sens1:pow:rang:auto 1"); %Automatic Range
power = str2num(send(g,'read1:pow?')); %Inside of a timed function in SpectralM

%% Run a sweep

