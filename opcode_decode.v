///////////////////////////////////OPCODE DECODE////////////////////////////////////////////////////

`define OP 		5'b01100				// R type instruction
`define JALR	5'b11001				// I type instructions
`define LOAD	5'b00000
`define OPIMM	5'b00100
`define STORE	5'b01000				// S type instruction
`define BRANCH	5'b11000				// B type instruction
`define LUI		5'b01101				// U type instructions
`define AUIPC	5'b00101
`define JAL		5'b11011				// J type instruction

module opcode_decode(
    input wire [31:0] instr,            // Instruction from the fetch unit

    output wire imm_en,                 // Instruction uses immediate
    output wire rs1_en,                 // Insutruction uses rs1
    output wire rs2_en,                 // Insutruction uses rs2
    output wire rd_en,                  // Insutruction uses rd
    output wire branch_en,              // B-type instruction
    output wire jump_en,                // J-type instruction (JAL or JALR)
    output wire unsigned_load,			 // Loaded data is unsigned          
    output wire en_load,      	       // Memory load
    output wire en_store, 		          // Memory store
    output wire [2:0] sum_imm_flag,	    // 2: imm + rs1; 1: imm + rs2; 0: imm + pc
    output reg [2:0] en_mem_access,     // 2: 1 Byte; 1: 2 Bytes; 0: 4 Bytes
    output reg [4:0] ALU_ctrl           // ALU control signals
);

    assign imm_en = (instr[6:2] != `OP);    // 1 for every instruction except R-type

    assign rs1_en = (instr[6:2] == `BRANCH) | (instr[6:2] == `JALR) | (instr[6:2] == `LOAD) |  
                    (instr[6:2] == `STORE) | (instr[6:2] == `OPIMM) | (instr[6:2] == `OP);

    assign rs2_en = (instr[6:2] == `BRANCH) | (instr[6:2] == `STORE) | (instr[6:2] == `OP);

    assign rd_en = (instr[6:2] == `LUI) | (instr[6:2] == `AUIPC) | (instr[6:2] == `JALR) | 
                    (instr[6:2] == `JAL) | (instr[6:2] == `LOAD) | (instr[6:2] == `OPIMM) | 
                    (instr[6:2] == `OP);

    assign branch_en = (instr[6:2] == `BRANCH); 

    assign jump_en = (instr[6:2] == `JALR) | (instr[6:2] == `JAL); 

    assign unsigned_load = (instr[6:2] == `LOAD) ? instr[14] : 0;   // instr[14] = funct3[2] (0 for signed, 1 for unsigned)

    assign en_load = (instr[6:2] == `LOAD); 

    assign en_store = (instr[6:2] == `STORE);

    assign sum_imm_flag = ((instr[6:2] == `LUI) | (instr[6:2] == `OPIMM) | (instr[6:2] == `OP) | (instr[6:2] == `JALR)) ?
                            3'b000 : ((instr[6:2] == `LOAD) | (instr[6:2] == `STORE)) ? 3'b100 : 
                            3'b001;     // Last case is AUIPC, BRANCH and JAL     

    always @(*)
        begin
            case(instr[6:2])
                `LOAD, `STORE: begin
                    case(instr[13:12])      // funct3[1:0]
                        2'b00: en_mem_access = 3'b100;
                        2'b01: en_mem_access = 3'b010;
                        2'b10: en_mem_access = (instr[6:2] == `LOAD) ? 3'b001 : 3'b000;
                    endcase
                end
                default: en_mem_access = 3'b000;    // All other instructions
            endcase

            case(instr[6:2])
                `OP: ALU_ctrl = {instr[30:29], instr[14:12]};   // {funct7[5:4], funct3}
                `OPIMM: ALU_ctrl = ((instr[14:12] == 3'b101) | (instr[14:12] == 3'b001)) ? 
                                    {instr[30:29], instr[14:12]} : {2'b00, instr[14:12]};
                `AUIPC, `LUI, `JALR, `JAL: ALU_ctrl = 5'b00000;
                `BRANCH: ALU_ctrl = 5'b11110;
                default: ALU_ctrl = 5'b11111;   // LOAD and STORE
            endcase
        end

endmodule