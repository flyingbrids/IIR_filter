/*----------------------------------------------------------------------------------
-- Company: 				
-- Engineer: 				Leon.S
-- 
-- Create Date:    		5/14/2025
-- Design Name: 			iir_filter
-- Module Name:    		iir_filter
-- Project Name: 			
-- Target Devices: 			
-- Tool versions: 			
-- Description: 		Second order IIR notch filter design. The transfer function is  
--							H(z) = Y(z)/ X(z) = (1-2cos(w0)z^-1 + z^-2)/(1-2rcos(wo)z^-1+r^2*z^-2); 						                                    
--							the coefficient for numerator is  b = [1, -2cos(wo), 1]
--						   the coefficient for denomator is  a = [1, -2r*cos(wo), r^2]
--                          
--							LET notch width r = 0.95,
--						        normalized freq: wo = 2pi* f0/Fs = 2pi* 1/40 = pi/20; (notch frequency is 1MHz at 40MHz sampling frequency )
--						    
--                   Since FPGA do fixed point DSP, we need to scale the number by 8192 (13 bits for decimal)
--							Therefore,  Q1.13 quantized coefficients:
--                   b_q13 = [8192, -16182, 8192] (numerator)
-- 						a_q13 = [8192, -15373, 7393]  (denominator)
--							By taking inverse Z transform, the difference equation implemented is  
--                   a_q13 * [y(n),y(n-1), y(n-2)]T = b_q13*[x(n),x(n-1),x(n-2)]T

-- Dependencies: 			multiply IPs by Lattice	
--							 
--
-- Revision: 				
--
--

----------------------------------------------------------------------------------
*/

module iir_filter (
		input  logic clk,
		input  logic rst_n,
		input  logic signed [13:0] x_in,
		output logic signed [13:0] y_out
);

parameter signed b0 = 8192;
parameter signed b1 = -16182;
parameter signed b2 = 8192;
parameter signed a0 = 8192;
parameter signed a1 = -15373;
parameter signed a2 = 7393;


logic signed [13:0] x1;
logic signed [27:0] b1x1;
logic signed [27:0] b2x2;
logic signed [31:0] sx;
logic signed [45:0] a0y;
logic signed [31:0] y;
logic signed [31:0] y1;
logic signed [45:0] a1y1;
logic signed [45:0] a2y2;

always @ (posedge clk, negedge rst_n) begin
		if (~rst_n) begin			
			b1x1 <= '0;
			x1   <= '0;
			b2x2 <= '0;
			sx   <= '0;
			a1y1 <= '0;
			y1   <= '0;
		   a2y2 <= '0;
		   y_out<= '0;	
		end else begin		   
			b1x1 <= x_in * b1;
			x1   <= x_in;
			b2x2 <= x1 * b2;
			sx   <= x_in * b0 + b1x1 + b2x2; // FIR part for x
		   a1y1 <= y * a1;
			y1   <= y;
		   a2y2 <= y1 * a2;	
		   y_out <= y[13:0]; // register output	
		end
end 

assign a0y = sx - a1y1 - a2y2; // FIR + feedback 
assign y   = a0y [44:13];


endmodule


