`timescale 1ns / 1ps

module iir_filter_tb;

// Clock and reset
logic clk;
logic rst_n;

// Inputs/outputs
logic signed [13:0] x_in;
logic signed [13:0] y_out;

// Instantiate DUT
iir_filter dut (
.clk(clk),
.rst_n(rst_n),
.x_in(x_in),
.y_out(y_out)
);

// Clock generation: 40 MHz = 25 ns period
initial clk = 0;
always #12.5 clk = ~clk;

// Stimulus
// Input data array (Q1.13) — pre-generated 1 MHz + 2 MHz signal with max 2048 each
logic signed [13:0] x_data [0:119] = {
0, 1419, 2666, 3649, 4303, 4604, 4556, 4193,
3575, 2781, 1903, 1036, 268, -350, -791, -1044,
-1119, -1027, -783, -410, 0, 410, 783, 1027,
1119, 1044, 791, 350, -268, -1036, -1903, -2781,
-3575, -4193, -4556, -4604, -4303, -3649, -2666, -1419,
0, 1419, 2666, 3649, 4303, 4604, 4556, 4193,
3575, 2781, 1903, 1036, 268, -350, -791, -1044,
-1119, -1027, -783, -410, 0, 410, 783, 1027,
1119, 1044, 791, 350, -268, -1036, -1903, -2781,
-3575, -4193, -4556, -4604, -4303, -3649, -2666, -1419,
0, 1419, 2666, 3649, 4303, 4604, 4556, 4193,
3575, 2781, 1903, 1036, 268, -350, -791, -1044,
-1119, -1027, -783, -410, 0, 410, 783, 1027,
1119, 1044, 791, 350, -268, -1036, -1903, -2781,
-3575, -4193, -4556, -4604, -4303, -3649, -2666, -1419
};


initial begin
// Reset
	rst_n = 0;
	x_in = 0;
	#100;
	rst_n = 1;

// Stimulate DUT
for (int i = 0; i < 120; i++) begin
	x_in = x_data[i];
	#25; // one 40 MHz clock cycle
end

$stop;
end

endmodule
