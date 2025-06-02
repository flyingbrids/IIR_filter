# IIR_filter
Use system verilog to implement an IIR filter

Create a notch filter at 1MHz at 40MHz sampled input. 
There is 1MHz noise due to the external switching device (i.e. MOSFET, IGBT)
The fixed point is scale by 8192 (i.e decimal point is at bit 13).
The notch filter is implemented using second order IIR filter. The coefficient can be modified for generality

In the testbench, a NCO signal mixed with 1MHz and 2MHz sine wave is input to the filter
The output shows the 1MHz is suppressed while 2MHz is untouched.

Tool: Quartus 13.1 WebEdition;
Run the tcl file and the project will be rebuilt. 
After that run the rtl simulation and the result will be shown
![alt text](https://github.com/flyingbrids/IIR_filter/blob/main/simulation_output.png?raw=true)
