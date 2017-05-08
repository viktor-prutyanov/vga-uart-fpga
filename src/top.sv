module top
(
    input CLK,

    output DS_EN1, DS_EN2, DS_EN3, DS_EN4,
    output DS_A, DS_B, DS_C, DS_D, DS_E, DS_F, DS_G,

    output H_SYNC, V_SYNC,
    output [4:0]V_R, 
    output [5:0]V_G, 
    output [4:0]V_B,

   input TXD
);

ssd ssd_inst(
    .CLK(CLK),
    .SEN1(DS_EN1), .SEN2(DS_EN2), .SEN3(DS_EN3), .SEN4(DS_EN4),
    .SSA(DS_A), .SSB(DS_B), .SSC(DS_C), .SSD(DS_D), .SSE(DS_E), .SSF(DS_F), .SSG(DS_G),
    .WORD(vram_data)
);

reg [9:0]vram_wraddr = 10'b11_1111_1111;
reg [15:0]vram_data = 16'b0;
reg vram_active = 1'b0;
video_core video_core_inst(
    .CLK(CLK),
    .H_SYNC(H_SYNC), .V_SYNC(V_SYNC),
    .V_R(V_R), .V_G(V_G), .V_B(V_B),
    .VRAM_DATA(vram_data), .VRAM_WRADDR(vram_wraddr), .VRAM_WREN(uart_idle)
);

wire [7:0]uart_data;
wire uart_idle;
uart_tx uart_tx_inst(
    .CLK(CLK),
    .TXD(TXD),
    .DATA(uart_data),
    .IDLE(uart_idle)
);

reg uart_read_state = 1'b0;
always @(posedge uart_idle) begin
    case (uart_read_state)
    1'b0: begin
        vram_data[15:8] <= uart_data;
        uart_read_state <= 2'b1;
    end
    1'b1: begin
        vram_data[7:0] <= uart_data; 
        uart_read_state <= 2'b0;
        vram_wraddr <= vram_wraddr + 1'b1;
    end
    endcase 
end

endmodule