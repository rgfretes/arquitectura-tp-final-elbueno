`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:33 03/05/2014 
// Design Name: 
// Module Name:    GetRegAddr 
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
module GetRegAddr(
    input [14:0] instr,
    output reg [4:0] regAddr1,
    output reg [4:0] regAddr2,
	 output reg [4:0] rs
    );


always@(*)
begin
	regAddr1 			= instr[4:0]; // rd
	regAddr2 			= instr[9:5]; // rt
	rs						= instr[14:10];
end

endmodule
