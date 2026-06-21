///////////////////////////////////////IMM BUILDER//////////////////////////////////////////////////

`define OP 		5'b01100				// R type instruction
`define JALR	5'b11001				// I type instructions
`define LOAD	5'b00000
`define OPIMM	5'b00100
`define STORE	5'b01000				// S type instruction
`define BRANCH	5'b11000				// B type instruction
`define LUI		5'b01101				// U type instructions
`define AUIPC	5'b00101
`define JAL		5'b11011				// J type instruction

module imm_builder(
    input wire [31:0] instr,            // Instruction from the fetch unit
    output reg [31:0] imm              // 32-bit immediate value
);

    always @(*)
        begin 
            case(instr[6:2])                                // opcode (first 2 bits are 11)
                `JALR, `LOAD, `OPIMM:                       // I type instructions
                    imm = {{21{instr[31]}}, instr[30:20]};
                `STORE:                                     // S type instruction
                    imm = {{21{instr[31]}}, instr[30:25], instr[11:7]};
                `BRANCH:                                    // B type instruction
                    imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
                `LUI, `AUIPC:                               // U type instructions
                    imm = {instr[31:12], {12{1'b0}}};
                `JAL:                                       // J type instruction
                    imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
                default:                                    // R type instruction (and others)
                    imm = 32'b0;
            endcase
        end

endmodule