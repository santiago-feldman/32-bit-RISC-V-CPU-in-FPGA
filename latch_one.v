//////////////////////////////////////STAGE 1///////////////////////////////////////////////////////

module latch_one(

    input wire clk,
	 
    input wire st1_en,              // Stage 1 enable (from pipeline controller, active high)
    input wire st1_rst,             // Reset stage 1 (from pipeline controller, active low)
    input wire st1_pause,           // Pause stage 1 (from pipeline controller, active low)

    input wire [4:0] rs1_addr,      // rs1 address (from decode)
    input wire [4:0] rs2_addr,      // rs2 address (from decode)
    input wire [4:0] rd_addr,       // rd address (from decode)
    input wire [2:0] f_three,        // funct3 from RISC-V instruction set (from decode)
    input wire [31:0] imm,          // 32-bit immediate value (from imm_builder)
    input wire [31:0] pc,           // 32-bit program counter (from fetch)
    
    // Control signals and flags from opcode_decode
	 input wire imm_en,              
    input wire rs1_en,              
	 input wire rs2_en,
	 input wire rd_en,
	 input wire branch_en,				
    input wire jump_en,             
	 input wire unsigned_load,
	 input wire en_load,
	 input wire en_store,
    input wire [2:0] sum_imm_flag,    
	 input wire [2:0] en_mem_access,
    input wire [4:0] ALU_ctrl,      

    output reg [4:0] rs1_addr_one,      
    output reg [4:0] rs2_addr_one,    
    output reg [4:0] rd_addr_one,     
    output reg [2:0] funct3_one,       
    output reg [31:0] imm_one,         
    output reg [31:0] pc_one,
    

    output reg en_imm_one,
    output reg en_rs1_one,
	 output reg en_rs2_one,
	 output reg en_rd_one,
    output reg en_jump_one,
	 output reg en_branch_one,
	 output reg unsigned_load_one,
	 output reg en_load_one,
	 output reg en_store_one,
    output reg [2:0] sum_imm_flag_one,
	 output reg [2:0] en_mem_access_one,
	 output reg [4:0] ALU_ctrl_one

);



    always @(posedge clk) begin
        if (!st1_rst && st1_en) begin							// Stage 1 reset
            rs1_addr_one    	 <= 5'b0;
            rs2_addr_one    	 <= 5'b0;
            rd_addr_one     	 <= 5'b0;
            funct3_one      	 <= 3'b0;
            imm_one         	 <= 32'b0;
            pc_one          	 <= 32'b0;
            ALU_ctrl_one    	 <= 5'b0;
            en_imm_one      	 <= 1'b0;
            en_rs1_one      	 <= 1'b0;
				en_rs2_one      	 <= 1'b0;
				en_rd_one     		 <= 1'b0;
            en_jump_one   	    <= 1'b0;
				en_branch_one	 	 <= 1'b0;
				unsigned_load_one  <= 1'b0;
				en_load_one			 <= 1'b0;
				en_store_one		 <= 1'b0;
            sum_imm_flag_one 	 <= 3'b0;
				en_mem_access_one	 <= 3'b0;
        end
        else if (st1_pause && st1_en) begin    				// Stage 1 enable (without pause or reset)
            rs1_addr_one       <= rs1_addr;
            rs2_addr_one       <= rs2_addr;
            rd_addr_one        <= rd_addr;
            funct3_one         <= f_three;
            imm_one            <= imm;
            pc_one             <= pc;
            ALU_ctrl_one       <= ALU_ctrl;
            en_imm_one         <= imm_en;
            en_rs1_one         <= rs1_en;
				en_rs2_one         <= rs2_en;
				en_rd_one     	    <= rd_en;
            en_jump_one      	 <= jump_en;
				en_branch_one	  	 <= branch_en;
				unsigned_load_one  <= unsigned_load;
				en_load_one			 <= en_load;
				en_store_one		 <= en_store;
            sum_imm_flag_one	 <= sum_imm_flag; 
        end
		  else if(!st1_pause) begin    									// Stage 1 pause (outputs mantain their values; !st1_pause)
            rs1_addr_one       <= rs1_addr_one;
            rs2_addr_one       <= rs2_addr_one;
            rd_addr_one        <= rd_addr_one;
            funct3_one         <= funct3_one;
            imm_one            <= imm_one;
            pc_one             <= pc_one;
            ALU_ctrl_one       <= ALU_ctrl_one;
            en_imm_one         <= en_imm_one;
            en_rs1_one         <= en_rs1_one;
				en_rs2_one         <= en_rs2_one;
				en_rd_one     	    <= en_rd_one;
            en_jump_one      	 <= en_jump_one;
				en_branch_one	  	 <= en_branch_one;
				unsigned_load_one  <= unsigned_load_one;
				en_load_one			 <= en_load_one;
				en_store_one		 <= en_store_one;
            sum_imm_flag_one	 <= sum_imm_flag_one; 
        end
    end

endmodule