send(g,'sour0:pow 1 dBm');
send(g,'sens1:pow:unit dbm');
send(g,'sour0:wav:sweep:mode CONT');
send(g,'source0:wav:sweep:cycl 1');
send(g,'source0:wav:sweep:speed 5nm/s');
send(g,'source0:wav:sweep:star 1500 nm');
send(g,'source0:wav:sweep:stop 1550 nm');
send(g,'source0:am:state 0');
send(g,'source0:wav:sweep:step 0.1 nm');

send(g,'trig0:outp0 STF'); 
%send(g,'sens1:chan2:pow:range:auto 1'); %% Turn auto range for the sensor
send(g,'source0:wav:sweep:llog 1');
send(g,'lock 0,1234');
send(g,'source0:pow:state 1');
send(g,'source0:wav:sweep start');
send(g,"sens1:func:par:logg 5001,0.002s");

send(g,'trig0:inp SME'); %%
send(g,'trig0:conf LOOP'); %%

send(g,'sens1:func:stat logg,star');


