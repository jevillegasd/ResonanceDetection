# Spectral Measurements 
Spectral Measurements is a matlab based application to interface with Keysight/Agilent Lightwave Measurement Systems. It supports the standard configuration of such systems that uses a variable laser source combined with a optical power sensor to allow carrying spectral sweeps, typical of optical characterization of photonic devices.
This version of the interfaces allows recording multiple measurements and adding user input independent variables. This in practice help keep track of difefrenmt experients and the conditions under which they are carried, Examples of independent variables are tempoerature, pressure, gas concentration, voltage etc. applied to the speciment being tested.

The interface saves the measurements as an h5 file (exptension smp (spectral measurements project)), and can export independent measuremnents as .mat data strcutures that can be imported in matlab.

Spectral Measurements supports the communication with multiple Lightwave Measurement Systems, however the present version can only communicate with one system at a time and while carrying sweeps it only supports a unique system (that is no0 external triggers are configured in the sweep routines).

Comments to: jev1@nyu.edu
