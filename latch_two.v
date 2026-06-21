//////////////////////////////////////STAGE 2///////////////////////////////////////////////////////

module latch_two(
    input wire clk,
    input wire st2_en,              // Stage 2 enable (from pipeline controller)
    input wire st2_rst,             // Reset stage 2 (from pipeline controller)
    input wire st2_pause,           // Pause stage 2 (from pipeline controller)

    input wire [31:0] rs1_val,      // rs1 value (from reg_bank)
    input wire [31:0] rs2_val,      // rs2 value (from reg_bank)
    input wire [4:0] rd_addr_one,   // rd address (from stage1)
    input wire [2:0] funct3_one,    // funct3 from RISC-V instruction set (from stage1)
    input wire [31:0] imm_one,      // 32-bit immediate value (from stage1)
    input wire [31:0] pc_one,       // 32-bit program counter (from stage1)
    
    // Control signals and flags (from stage 1)
    input wire en_imm_one,
    input wire en_rs1_one,
	 input wire en_rs2_one,
	 input wire en_rd_one,
    input wire en_jump_one,
	 input wire en_branch_one,
	 input wire unsigned_load_one,
	 input wire en_load_one,
	 input wire en_store_one,
    input wire [2:0] sum_imm_flag_one,
	 input wire [2:0] en_mem_access_one,
	 input wire [4:0] ALU_ctrl_one,

    output reg [31:0] rs1_two,      
    output reg [31:0] rs2_two,    
    output reg [4:0] rd_addr_two,     
    output reg [2:0] funct3_two,       
    output reg [31:0] imm_two,         
    output reg [31:0] pc_two,

    output reg en_imm_two,
    output reg en_rs1_two,
	 output reg en_rs2_two,
	 output reg en_rd_two,
    output reg en_jump_two,
	 output reg en_branch_two,
	 output reg unsigned_load_two,
	 output reg en_load_two,
	 output reg en_store_two,
    output reg [2:0] sum_imm_flag_two,
	 output reg [2:0] en_mem_access_two,
	 output reg [4:0] ALU_ctrl_two

);

	 assign gated_clk = clk && st2_en;

    always @(posedge gated_clk) begin
        if (!st2_rst) begin
            rs1_two     	 	<= 32'b0;
            rs2_two     	 	<= 32'b0;
            rd_addr_two 		<= 5'b0;
            funct3_two  	 	<= 3'b0;
            imm_two     	 	<= 32'b0;
            pc_two      	 	<= 32'b0;
            ALU_ctrl_two	 	<= 5'b0;
            en_imm_two  	 	<= 1'b0;
				en_rs1_two 		 	<= 1'b0;
				en_rs2_two  	 	<= 1'b0;
				en_rd_two   	 	<= 1'b0;
				en_jump_two    	<= 1'b0;
				en_branch_two		<= 1'b0;
				unsigned_load_two	<= 1'b0;
				en_load_two			<= 1'b0;
				en_store_two		<= 1'b0;
				sum_imm_flag_two  <= 3'b0;
				en_mem_access_two <= 3'b0;
        end
        else begin    
            rs1_two     		<= rs1_val;
            rs2_two      		<= rs2_val;
            rd_addr_two 		<= rd_addr_one;
            funct3_two  		<= funct3_one;
            imm_two     		<= imm_one;
            pc_two      		<= pc_one;
            ALU_ctrl_two 		<= ALU_ctrl_one;
            en_imm_two  	 	<= en_imm_one;
				en_rs1_two 		 	<= en_rs1_one;
				en_rs2_two  	 	<= en_rs2_one;
				en_rd_two   	 	<= en_rd_one;
				en_jump_two    	<= en_jump_one;
				en_branch_two		<= en_branch_one;
				unsigned_load_two	<= unsigned_load_one;
				en_load_two			<= en_load_one;
				en_store_two		<= en_store_one;
				sum_imm_flag_two  <= sum_imm_flag_one;
				en_mem_access_two <= en_mem_access_one;
        end
    end

endmodule