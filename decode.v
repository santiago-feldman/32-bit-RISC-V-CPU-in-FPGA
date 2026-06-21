////////////////////////////////DECODE//////////////////////////////////////////////////////////////

module decode(
    input wire [31:0] instr,  		// Instruction from the fetch unit
    
    output wire [4:0] rs1_addr,     // rs1 address
    output wire [4:0] rs2_addr,     // rs2 address
    output wire [4:0] rd_addr,      // rd address
    output wire [2:0] f_three,      // funct3 from RISC-V instruction set 
    output wire f_seven             // funct7 from RISC-V instruction set
);

	assign rs1_addr = instr[19:15];
	assign rs2_addr = instr[24:20];
	assign rd_addr  = instr[11:7];
   assign f_three  = instr[14:12];
	assign f_seven  = instr[30];     // Only the 6th bit from funct7 changes for R-type instructions

endmodule