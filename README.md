# IIR_filter
Use system verilog to implement an IIR filter

Create a notch filter at 1MHz at 40MHz sampled input. 
There is 1MHz noise due to the external switching device (i.e. MOSFET, IGBT)
The fixed point is scale by 8192 (i.e decimal point is at bit 13).

In the testbench, a NCO signal mixed with 1MHz and 2MHz sine wave is input to the filter
The output shows the 1MHz is suppressed while 2MHz is untouched.
