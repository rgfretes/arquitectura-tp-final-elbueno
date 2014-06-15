`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:57:10 03/14/2014 
// Design Name: 
// Module Name:    debuger_decoder 
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
module debuger_decoder(
		input [7:0] code,
		input reset,
//		input clk,
		output reg [31:0] result,
		output reg [1:0] size
    );
reg clk;
/*IF*/
wire control_is_jump_if, control_branch_eq_if, control_branch_inc_if, control_is_zero_if;
wire [31:0] data_jump_address;

/*ID*/
wire [31:0] instr, writeData, pc_id;
wire [4:0] 	writeAddr;
wire 			regWrite;
reg [4:0] addrAsync;
wire [31:0] outputAsync;

/*EX*/
wire [31:0] data_a, data_b, data_imm, npc;
wire [3:0] control_oper;
wire control_use_b, control_Reg_DST, control_is_jump, control_branch_eq, control_branch_inc;
wire [4:0] regaddr1, regaddr2;
wire [25:0] jumpimmediate;

wire [1:0] wb_exe;
wire M_exe;
wire [1:0] memdatasize_exe;
wire [4:0] rs;

/*MEM*/
wire M;
wire [1:0] memdatasize;
wire [31:0] data, dataaddr;
wire [1:0] wb_mem;
wire [4:0] regaddr_mem;
wire [4:0] rt_id;

/*WB*/
wire [31:0] datafrommem, datafromimm, datamask;
wire [1:0] wb;

/*Forwarding*/
wire [1:0] forw_exe_a, forw_exe_b;
wire forw_mem;

// control hazzard
wire isJumped;

// wire NOP
wire nop_if, nop_id, nop_exe, nop_mem;
//wire stall
wire stall;

StallHandler staller (
    .clock(clk), 
	 .reset(reset),
    .isFromAlu(wb_mem[0]), 
    .nop_exe(nop_exe), 
    .reg_Dst(control_Reg_DST), 
    .regAddrOutAlu(regaddr_mem), 
    .regAddrInRs(rs), 
    .regAddrInRt(regaddr2), 
    .regAddrInRd(regaddr1), 
    .stall(stall)
    );

	 
forwarding_exe fe (
    .rs_id(rs), 
    .rd_id(regaddr1), 
    .rt_id(regaddr2), 
	 .nop_exe(nop_exe),
	 .nop_mem(nop_mem),
	 .wb_exe(wb_mem[1]),
	 .wb_mem(wb[1]),
    .regDst(control_Reg_DST), 
    .outReg_exe(regaddr_mem), 
    .outReg_mem(writeAddr), 
    .selector_salida_a(forw_exe_a), 
    .selector_salida_b(forw_exe_b)
    );
	 
forwarding_mem fm (
    .rt_id(rt_id), 
    .outReg_mem(writeAddr), 
	 .nop_mem(nop_mem),
	 .wb_mem(wb[1]),
    .selector_salida(forw_mem)
    );

stage_if instr_fetch (
    .clock(clk), 
    .reset(reset),
	 .stall(stall),
    .control_is_jump(control_is_jump_if), 
	 .nop_exe(nop_exe),
    .control_branch_eq(control_branch_eq_if), 
    .control_branch_inc(control_branch_inc_if), 
    .control_is_zero(control_is_zero_if), 
    .data_jump_address(data_jump_address),
	 .iadd(pc_id),
    .instruction(instr),
	 .isJumped(isJumped),
	 .nop(nop_if)
    );
	 
stage_id ins_decoder (
    .clock(clk),
	 .reset(reset),
	 .stall(stall),
	 .addrAsync(addrAsync),
	 .nop_if(nop_if),
    .instr(instr), 
	 .isJumped(isJumped),
    .writeData(writeData), 
    .writeAddr(writeAddr), 
    .regWrite(regWrite), 
    .pc_id(pc_id), 
    .pc_ex(npc), 
    .aluOp(control_oper), 
    .isJump(control_is_jump), 
    .isNotConditional(control_branch_inc), 
    .isEq(control_branch_eq), 
    .memWrite(M_exe),
	 .memdatasize(memdatasize_exe),
    .wbi(wb_exe), 
    .memRead(), 
    .aluSrc(control_use_b), 
    .reg1(data_a), 
    .reg2(data_b), 
    .extendedInstr(data_imm), 
    .regAddr1(regaddr1), 
    .regAddr2(regaddr2),
	 .rs(rs),
    .regDst(control_Reg_DST),
	 .jumpimmediate(jumpimmediate),
	 .nop(nop_id),
	 .outputAsync(outputAsync)
    );


stage_exe exe(
    .clock(clk), 
    .reset(reset),
	 .stall(stall),	 
	 .nop_id(nop_id),
    .data_a(data_a), 
    .data_b(data_b), 
    .data_imm(data_imm), 
    .control_oper(control_oper), 
    .control_use_b(control_use_b), 
    .control_Reg_DST(control_Reg_DST), 
    .npc(npc), 
    .control_is_jump(control_is_jump), 
    .control_branch_eq(control_branch_eq), 
    .control_branch_inc(control_branch_inc), 
    .is_jump_o(control_is_jump_if), 
    .branch_eq_o(control_branch_eq_if), 
    .branch_inc_o(control_branch_inc_if), 
    .zero(control_is_zero_if), 
    .jump_address(data_jump_address), 
    .wbi(wb_exe), 
    .M(M_exe),
    .memdatasize(memdatasize_exe),	 
    .regaddr1(regaddr1), 
    .regaddr2(regaddr2),
    .wbi_o(wb_mem), 
    .M_o(M),
	 .memdatasize_o(memdatasize),
    .regaddr_o(regaddr_mem), 
    .data_b_o(data), 
    .out(dataaddr),
	 .for_a(forw_exe_a),
	 .for_b(forw_exe_b),
	 .rt_id(rt_id),
	 .result_from_exe(dataaddr),
	 .result_from_mem(writeData),
	 .isJumped(isJumped),
	 .jumpimmediate(jumpimmediate),
	 .nop(nop_exe)
    );

mem stage_mem (
    .clk(clk),
	 .nop_exe(nop_exe),
    .wbi(wb_mem), 
    .regaddr(regaddr_mem), 
    .wbo(wb), 
    .M(M),
	 .memdatasize(memdatasize),
    .data(data), 
    .dataaddr(dataaddr), 
    .datafrommem(datafrommem), 
    .datafromimm(datafromimm), 
    .regaddrout(writeAddr),
	 .forw(forw_mem),
	 .result_from_mem(writeData),
	 .reset(reset),
	 .datamask(datamask),
	 .nop(nop_mem)
    );
	 
wb write_back (
	 .nop_mem(nop_mem),
    .datafrommem(datafrommem), 
    .datafromimm(datafromimm), 
    .wb(wb),
	 .datamask(datamask),
    .datatoregfile(writeData), 
    .weregfile(regWrite)
    );



always @ (*)
begin
	case (code[7:0])
		8'b00111000: clk = 0;
		8'b00111111: clk = 1;
		default: clk = 0;
	endcase
	case (code[7:0])
		/*IF*/ 
		8'b00000001: 
		begin
			size <= 2'b11;
			result <= 32'b0 + instr; //instruction
		end
		8'b00100010: 
		begin
			size <= 2'b11;
			result <= 32'b0 + pc_id; //iadd
		end
		/*ID*/
		8'b00000010:
		begin		
			size <= 2'b00;
			result <= 32'b0 + control_oper; //aluOp
		end
		8'b00000011: 
		begin
			size <= 2'b00;
			result <= 32'b0 + control_is_jump; //isJump
		end
		8'b00000100: 
		begin
			size <= 2'b00;
			result <= 32'b0 + control_branch_inc; //isNotConditional
		end
		8'b00000101: 
		begin
			size <= 2'b00;
			result <= 32'b0 + control_branch_eq; //isEq
		end
		8'b00000110: 
		begin
			size <=  2'b00;
			result <= 32'b0 + M_exe; //memWrite
		end
		8'b00000111: 
		begin
			size <= 2'b00;
			result <= 32'b0 + wb_exe; //wbi
		end
		//6'b001000: result <= //memRead
		8'b00001001: 
		begin
			size <= 2'b00;
			result <= 32'b0 + control_use_b; //aluSrc
		end
		8'b00001010: 
		begin
			size <= 2'b11;
			result <= 32'b0 + data_a; //reg1
		end
		8'b00001011: 
		begin
			size <= 2'b11;
			result <= 32'b0 + data_b; //reg2
		end
		8'b00001100: 
		begin
			size <= 2'b11;
			result <= 32'b0 + data_imm; //extendedInstr
		end
		8'b00001101: 
		begin
			size <= 2'b00;
			result <= 32'b0 + regaddr1; //regAddr1
		end
		8'b00001110: 
		begin
			size <= 2'b00;
			result <= 32'b0 + regaddr2; //regAddr2
		end
		8'b00001111: 
		begin
			size <= 2'b00;
			result <= 32'b0 + control_Reg_DST; //regDst
		end
		/*EXE*/
		8'b00010000: 
		begin
			size <= 2'b00;
			result <= 32'b0 + control_is_jump_if; //is_jump_o
		end
		8'b00010001: 
		begin
			size <= 2'b00;
			result <= 32'b0 + control_branch_eq_if; //branch_eq_o
		end
		8'b00010010: 
		begin
			size <= 2'b00;
			result <= 32'b0 + control_branch_inc_if; //branch_inc_o
		end
		8'b00010011:
		begin
			size <= 2'b00;
			result <= 32'b0 + control_is_zero_if; //zero
		end
		8'b00010100: 
		begin
			size <= 2'b11;
			result <= 32'b0 + data_jump_address; //jump_address
		end
		8'b00010101: 
		begin
			size <= 2'b00;
			result <= 32'b0 + wb_mem; //wbi_o
		end
		8'b00010110: 
		begin
			size <= 2'b00;
			result <= 32'b0 + M; //M_o
		end
		8'b00010111: 
		begin
			size <= 2'b00;
			result <= 32'b0 + regaddr_mem; //regaddr_o
		end
		8'b00011000: 
		begin
			size <= 2'b11;
			result <= 32'b0 + data;//data_b_o
		end
		8'b00011001: 
		begin
			size <= 2'b11;
			result <= 32'b0 + dataaddr;//out
		end
		/*MEM*/
		8'b00011010: 
		begin
			size <= 2'b11;
			result <= 32'b0 + datafrommem; //datafrommem
		end
		8'b00011011: 
		begin
			size <= 2'b11;
			result <= 32'b0 + datafromimm; //datafromimm
		end
		8'b00011100: 
		begin
			size <= 2'b00;
			result <= 32'b0 + writeAddr; //regaddrout
		end
		// 8'b00011101:
			// in WB 
		//	8'b00011110:
			// in WB
		8'b00011111: 
		begin
			size <= 2'b00;
			result <= 32'b0 + wb; //wbo
		end
		/*WB*/
		8'b00011101: 
		begin
			size <= 2'b11;
			result <= 32'b0 + writeData; //datatoregfile
		end
		8'b00011110: 
		begin
			size <= 2'b00;
			result <= 32'b0 + regWrite; //weregfile
		end
		//clocks
      8'b00111000: 
		begin
			size <= 2'b00;
			result <= 32'b0 + 8'b01010101;
		end
		8'b00111111: 
		begin
			size <= 2'b00;
			result <= 32'b0 + 8'b11111111;
		end
		//******************* registros  **************//
		8'b01000000:
		begin
			addrAsync <= 5'b0;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01000001:
		begin
			addrAsync <= 5'd1;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01000010:
		begin
			addrAsync <= 5'd2;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01000011:
		begin
			addrAsync <= 5'd3;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01000100:
		begin
			addrAsync <= 5'd4;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01000101:
		begin
			addrAsync <= 5'd5;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01000110:
		begin
			addrAsync <= 5'd6;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01000111:
		begin
			addrAsync <= 5'd7;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01001000:
		begin
			addrAsync <= 5'd8;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01001001:
		begin
			addrAsync <= 5'd9;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01001010:
		begin
			addrAsync <= 5'd10;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01001011:
		begin
			addrAsync <= 5'd11;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01001100:
		begin
			addrAsync <= 5'd12;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01001101:
		begin
			addrAsync <= 5'd13;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01001110:
		begin
			addrAsync <= 5'd14;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01001111:
		begin
			addrAsync <= 5'd15;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01010000:
		begin
			addrAsync <= 5'd16;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01010001:
		begin
			addrAsync <= 5'd17;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01010010:
		begin
			addrAsync <= 5'd18;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01010011:
		begin
			addrAsync <= 5'd19;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01010100:
		begin
			addrAsync <= 5'd20;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01010101:
		begin
			addrAsync <= 5'd21;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01010110:
		begin
			addrAsync <= 5'd22;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01010111:
		begin
			addrAsync <= 5'd23;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01011000:
		begin
			addrAsync <= 5'd24;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01011001:
		begin
			addrAsync <= 5'd25;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01011010:
		begin
			addrAsync <= 5'd26;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01011011:
		begin
			addrAsync <= 5'd27;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01011100:
		begin
			addrAsync <= 5'd28;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01011101:
		begin
			addrAsync <= 5'd29;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01011110:
		begin
			addrAsync <= 5'd30;
			size <= 2'b11;
			result <= outputAsync;
		end
		8'b01011111:
		begin
			addrAsync <= 5'd31;
			size <= 2'b11;
			result <= outputAsync;
		end
		default:
		begin		
			result <= 0;
			size <= 2'b00;
		end
		
	endcase
	
	
	
end

endmodule
