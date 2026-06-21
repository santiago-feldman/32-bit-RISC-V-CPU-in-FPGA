module reg_bank (
    input wire clk,               // Clock signal
    input wire reset,             // Asynchronous reset (active low)
    input wire [4:0] rs1_addr,    // rs1 select (from stage 1)
    input wire [4:0] rs2_addr,    // rs2 select (from stage 1)
    input wire [4:0] rd_addr,     // rd select
    input wire [31:0] rd,         // Result from ALU
    input wire en_rd,
    output wire [31:0] rs1_data,  // rs1 data
    output wire [31:0] rs2_data,   // rs2 data
	 //eliminar
	 output reg [7:0] reg3_aux
);

    reg [31:0] reg_bank [0:31]; 	 // 32 register bank (x0-x31, 32-bit registers)
	 
    initial 
		begin
			reg_bank[0] = 32'b0;  	 // x0 set to 0
		end

    // Read rs1 and rs2
    assign rs1_data = reg_bank[rs1_addr];
    assign rs2_data = reg_bank[rs2_addr];

    // Write register
    always @(posedge clk or negedge reset) 
		begin
			if (!reset) 
				begin
					reg_bank[0] <= 32'b0;
					reg_bank[1] <= 32'b0;
					reg_bank[2] <= 32'b0;
					reg_bank[3] <= 32'b0;
					reg_bank[4] <= 32'b0;
					reg_bank[5] <= 32'b0;
					reg_bank[6] <= 32'b0;
					reg_bank[7] <= 32'b0;
					reg_bank[8] <= 32'b0;
					reg_bank[9] <= 32'b0;
					reg_bank[10] <= 32'b0;
					reg_bank[11] <= 32'b0;
					reg_bank[12] <= 32'b0;
					reg_bank[13] <= 32'b0;
					reg_bank[14] <= 32'b0;
					reg_bank[15] <= 32'b0;
					reg_bank[16] <= 32'b0;
					reg_bank[17] <= 32'b0;
					reg_bank[18] <= 32'b0;
					reg_bank[19] <= 32'b0;
					reg_bank[20] <= 32'b0;
					reg_bank[21] <= 32'b0;
					reg_bank[22] <= 32'b0;
					reg_bank[23] <= 32'b0;
					reg_bank[24] <= 32'b0;
					reg_bank[25] <= 32'b0;
					reg_bank[26] <= 32'b0;
					reg_bank[27] <= 32'b0;
					reg_bank[28] <= 32'b0;
					reg_bank[29] <= 32'b0;
					reg_bank[30] <= 32'b0;
					reg_bank[31] <= 32'b0;
				end
			else if (en_rd && (rd_addr != 5'b0)) 
				begin
					reg_bank[rd_addr] <= rd;  								// xi = data
				end
			reg3_aux <= reg_bank[3][7:0];
		end
		

endmodule