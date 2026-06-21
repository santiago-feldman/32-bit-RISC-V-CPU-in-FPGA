//////////////////////////////////////OPERAND BUILD/////////////////////////////////////////////////

module operand_build(

    input wire [31:0] rs1_val,              // rs1 value (from stage2)
    input wire [31:0] rs2_val,              // rs2 value (from stage2)
    input wire [31:0] imm,                  // 32-bit immediate value (from stage2)
    input wire [31:0] pc,                   // 32-bit program counter (from stage2)
    input wire imm_en,                      // Enable immediate (from stage2)
    input wire rs1_en,                      // Enable rs1 (from stage2)
    input wire jump_en,                     // Enable jump (from stage2)
    input wire [2:0] sum_imm_flag,          // From stage 2

    output wire [31:0] operandA,            // To ALU
    output wire [31:0] operandB             // To ALU

);

    // Operand 1: PC if instruction is a jump; IMM if instruction uses immediate but not rs1;
    // RS1 if instruction uses both immediate and rs1 (and all other cases)
    assign operandA = (jump_en || sum_imm_flag[0]) ? pc : (imm_en && !rs1_en) ? imm : rs1_val;

    // Operand 2: 4 if instruction is a jump; IMM if instruction uses immediate and rs1; 
    // 0 is instruction uses immedaite but not rs1; RS2 otherwise
    assign operandB = (jump_en) ? 4 : (sum_imm_flag[0]) ? imm : (imm_en && rs1_en) ? imm : (imm_en) ? 0 : rs2_val;

endmodule