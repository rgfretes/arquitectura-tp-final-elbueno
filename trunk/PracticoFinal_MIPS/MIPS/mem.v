`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:33:57 02/17/2014 
// Design Name: 
// Module Name:    mem 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mem(
	 input clk,
	 input reset,
    input [1:0] wbi,
	 input [4:0] regaddr,
    output reg [1:0] wbo,
    input M,
	 input [1:0] memdatasize,
	 input nop_exe,
    input [31:0] data,
    input [31:0] dataaddr,
	 input forw,
	 input [31:0] result_from_mem,
	 output  [31:0] datafrommem,
    output reg [31:0] datafromimm,
	 output reg [4:0] regaddrout,
	 output reg [23:0] datamask,
	 output reg nop
    );
	 
	 wire [31:0] douta;
	 reg [3:0] dataselect;
	 reg [23:0] outmask;
	 
	 reg [31:0] processed_entry;
	 wire processed_M = (nop_exe)? 1'b0 : M;
	 wire [3:0] writeenable = (processed_M)? dataselect : 4'b0;
	 
	always @ (*)
	begin
		if(forw == 1)
			processed_entry = result_from_mem;
		else
			processed_entry = data;
			
		case (memdatasize)
				2'b00:
					begin 
						dataselect = 4'b0001;
						outmask = 24'b0;
					end
				2'b01:
					begin 
						dataselect = 4'b0011;
						outmask = 24'b11111111;
					end
				2'b10:
					begin 
						dataselect = 4'b0111;
						outmask = 24'b1111111111111111;
					end
				2'b11:
					begin 
						dataselect = 4'b1111;
						outmask = 24'b111111111111111111111111;
					end		
		endcase
	end
 
	rammemory memory (
  .clka(clk), // input clka
  .wea(writeenable), // input [3 : 0] wea
  .addra(dataaddr[12:0]), // input [12 : 0] addra
  .dina(processed_entry), // input [31 : 0] dina
  .douta(datafrommem), // output [31 : 0] douta
  .rsta(reset)
);
	 
	 always @ (posedge clk)
	 begin
	   if (reset)
			begin
				wbo = 2'b0;
				datafromimm = 32'b0;
				datamask = 24'b0;
				regaddrout = 5'b0;
				nop = 1;
			end
		wbo = wbi;
		datafromimm = dataaddr;
		regaddrout = regaddr;
		nop = nop_exe;
		datamask = outmask;
	 end


endmodule
