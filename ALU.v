//////////////////////////////////////ALU///////////////////////////////////////////////////////////

`define ADD  5'b00000   // ALU control signal for ADD, ADDI, JALR, JAL, LUI or AUIPC
`define SUB  5'b10000   // ALU control signal for SUB
`define SLL  5'b00001   // ALU control signal for SLL or SLLI (uses shamt)
`define SLT  5'b00010   // ALU control signal for SLT or SLTI
`define SLTU 5'b00011   // ALU control signal for SLTU or SLTIU
`define XOR  5'b00100   // ALU control signal for XOR or XORI
`define SRL  5'b00101   // ALU control signal for SRL or SRLI (uses shamt)
`define SRA  5'b10101   // ALU control signal for SRA or SRAI (uses shamt)
`define OR   5'b00110   // ALU control signal for OR or ORI
`define AND  5'b00111   // ALU control signal for AND or ANDI


module ALU(
    input wire [31:0] operandA,            // From operand_build
    input wire [31:0] operandB,            // From operand_build
    input wire [4:0] ALU_ctrl,             // ALU control signals (from stage2)

    output reg [31:0] rd
);

    always@(*) begin
        case(ALU_ctrl)
         `ADD:   	rd = operandA + operandB;
			`SUB:		rd = operandA - operandB;
			`SLL:		rd = operandA << operandB[4:0];
			`SLT:   	rd = ($signed(operandA) < $signed(operandB));
			`SLTU:	rd = (operandA < operandB);  
			`XOR:		rd = operandA ^ operandB;
			`SRL:		rd = operandA >> operandB[4:0];
			`SRA:		rd = $signed(operandA) >>> operandB[4:0];
			`OR:		rd = operandA | operandB;
			`AND:		rd = operandA & operandB;
			default: rd = 32'b0;
        endcase
    end

endmodule