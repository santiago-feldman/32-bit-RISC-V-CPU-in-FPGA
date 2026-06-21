module fetch(
    input wire clk,
    input wire stop,
    input wire rst,

    input wire [31:0] q_a,
    input wire instr_ready,
    input wire [31:0] new_pc,
    input wire jump,
    
    output reg [15:0] fetch_addr = 16'b1111111111111111,
    output wire [31:0] pc,
    output wire [31:0] instr
);

 reg [15:0] last_valid_addr;     // Última dirección válida leída

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            fetch_addr <= 16'd0;
            last_valid_addr <= 16'd0;
        end else begin
            if (jump) begin
                fetch_addr <= new_pc[15:0];
                last_valid_addr <= new_pc[15:0];
            end else if (stop) begin
                fetch_addr <= 16'd0;
                // last_valid_addr no se actualiza durante stop
            end else begin
                fetch_addr <= last_valid_addr + 16'd4;
                last_valid_addr <= last_valid_addr + 16'd4;
            end
        end
    end



assign pc = {16'b0, fetch_addr};
assign instr = q_a;

endmodule