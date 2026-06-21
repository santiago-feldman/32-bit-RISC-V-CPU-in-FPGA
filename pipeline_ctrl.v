module pipeline_ctrl(
	input wire clk,
	input wire rst,
	
	// Enable flags from opcode_decode
	input wire rs1_en,
	input wire rs2_en,
	input wire jump_en,
	input wire branch_en,
	input wire en_load,
	input wire en_store,
	
	input wire [2:0] f_three,
	
	// Branch flags from addr_builder
	input wire BEQ,
	input wire BNE,
	input wire BLT,
	input wire BGE,
	input wire BLTU,
	input wire BGEU,
	
	input wire mem_busy,

	input wire [4:0] rd_addr_one,	// rd address from instruction in stage 1
	input wire [4:0] rd_addr_two,	// rd address from instruction in stage 2
	input wire [4:0] rs1_addr,		// rs1 address from instruction in decode stage
	input wire [4:0] rs2_addr,		// rs2 address from instruction in decode stage

	output reg instr_ready,			// Fetch enable
	output reg st1_en,				// Stage 1 enable
	output wire st1_rst,				// Stage 1 reset
	output wire st1_pause,			// Stage 1 pause
	output reg st2_en,				// Stage 2 enable
	output reg st3_en,				// Stage 3 (reg_bank) enable
	//output reg ////en_regs,
	output reg en_addr_builder		// Address builder enable
	
);

// Cycle counters and flags for pipeline control
reg [1:0]skip_branch;				// B type instruction
reg skip_jump;							// JAL or JALR
reg skip_cycle;						// Instruction in stage 1 uses result from instruction in stage 2
reg [1:0]skip_load;					// Load instructions
reg skip_store;						// S type instruction
reg mem_access;						// S type instruction is accessing memory

// Don´t reset stage 1 when memory is busy or instruction in stage 1 uses rs1 or rs2 to be defined
// by instruction in stage 2
assign st1_rst = mem_busy || 
				!(((((rd_addr_two == rs1_addr) && rs1_en) || ((rd_addr_two == rs2_addr) && rs2_en)) 
				&& (rd_addr_two != 5'b0)) || 
				((((rd_addr_one == rs1_addr) && rs1_en) || ((rd_addr_one == rs2_addr) && rs2_en)) 
				&& (rd_addr_one != 5'b0)));

assign st1_pause= 1;//!(((((rd_addr_two == rs1_addr) && rs1_en) || ((rd_addr_two == rs2_addr) && rs2_en)) 
				//&& (rd_addr_two != 5'b0)) || 
				//((((rd_addr_one == rs1_addr) && rs1_en) || ((rd_addr_one == rs2_addr) && rs2_en)) 
				//&& (rd_addr_one != 5'b0))); //que se pausa (0) cuando usa rs1_en==1 en la primera etapa y la segunda Y ((rd_adress_stage_1 == rd_adress_stage_2)|| )

always @(posedge clk, negedge rst) begin


	if (!rst) begin
		instr_ready <= 0;
		st1_en <= 0;
		st2_en <= 0;
		st3_en <= 0;
		////en_regs <= 0;
		skip_branch <= 0;
		skip_jump <= 0;
		skip_cycle <= 0;
		skip_store <= 0;
		skip_load <= 0;
		mem_access <= 0;
		en_addr_builder <= 0;
	end
	else begin
		
		// rs1 or rs2 (in stage 1) try to access rd to be determined by instruction in stage 2. 
		// Pipeline stops for 1 cycle
		if (skip_cycle) begin
			skip_cycle <= 0;
			en_addr_builder <= 1;
		end
		else if ((((rd_addr_two == rs1_addr) && rs1_en) || ((rd_addr_two == rs2_addr) && rs2_en)) && 
				 (rd_addr_two != 0)) begin
			st1_en <= 1;
			skip_cycle <= 1;
			st2_en <= 1;
			st3_en <= 1;
			en_addr_builder <= 1;
		end 
		else if ((((rd_addr_one == rs1_addr) && rs1_en) || ((rd_addr_one == rs2_addr) && rs2_en)) &&
				 (rd_addr_one != 0)) begin
			st1_en <= 1;
			st2_en <= 1;
			st3_en <= 1;
			en_addr_builder <= 1;
		end 
		
		// For J type instructions, pipeline stops for 2 cycles
		else if (skip_jump) begin
			en_addr_builder <= 0;
			skip_jump <= 0;
		end
		else if (jump_en) begin
			st1_en <= 0;
			st2_en <= 0;
			st3_en <= 0;
			skip_jump <= 1;
		end
		
		// For B type instructions, pipeline stops for 2 cycles
		else if (skip_branch) begin
			if (BEQ || BNE || BLT || BGE || BLTU || BGEU) begin
				st1_en <= 0;
				st2_en <= 0;
				st3_en <= 0;
				en_addr_builder <= 0;
				skip_branch <= 0;	
			end
			else begin
				skip_branch <= 0;
			end
		end
		else if (branch_en) begin
			skip_branch <= 1;
			instr_ready <= 1;
			st1_en <= 1;
			st2_en <= 1;
			st3_en <= 1;
			////en_regs <= 1;
			en_addr_builder <= 1;
		end

		// Load instructions
		else if (skip_load == 3 && !mem_busy && !mem_access) begin
			skip_load <= 0;
			instr_ready <= 1;
			st1_en <= 1;
			st2_en <= 1;
			st3_en <= 1;
		end
		else if (skip_load == 2) begin
			skip_load <= skip_load + 1;
		end
		else if (skip_load == 1 && !mem_access) begin
			skip_load <= skip_load + 1;
		end
		else if (en_load) begin
			if (mem_access) begin
				skip_store <= 1;
			end
			else begin
				skip_load <= 1;
				instr_ready <= 0;
				st1_en <= 0;
				st2_en <= 0;
				st3_en <= 0;
			end
		end
		
		// S type instructions
		else if (skip_store == 2 && !mem_busy) begin
			skip_store <= 0;
			st1_en <= 1;
			st2_en <= 1;
			st3_en <= 1;
			instr_ready <= 1;
		end
		else if (skip_store == 1) begin
			skip_store <= skip_store + 1;
		end
		else if (mem_access && !mem_busy) begin
			mem_access <= 0;
		end
		else if (en_store) begin
			if (mem_access) begin
				skip_store <= 1;
				instr_ready <= 0;
				st1_en <= 0;
				st2_en <= 0;
				st3_en <= 0;
				//////en_regs <= 1;
				en_addr_builder <= 1;
			end
			else begin
				mem_access <= 1;
			end
		end
		else begin
			instr_ready <= 1;
			st1_en <= 1;
			st2_en <= 1;
			st3_en <= 1;
			////en_regs <= 1;
			en_addr_builder <= 1;
		end
		
	end
end


endmodule