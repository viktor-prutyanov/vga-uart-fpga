module video_core(
    input CLK,

    output H_SYNC, V_SYNC,
    output [4:0]V_R, 
    output [5:0]V_G, 
    output [4:0]V_B,

    input [15:0]VRAM_DATA,
    input [9:0]VRAM_WRADDR,
    input VRAM_WREN
);

wire vga_clk;
pll pll_inst(
    .inclk0(CLK),
    .c0(vga_clk)
);

wire [9:0]x_num;
wire [8:0]y_num;
wire num_sync;
vga_sync vga_sync_inst(
    .CLK(vga_clk),
    .H_SYNC(H_SYNC), .V_SYNC(V_SYNC),
    .X_NUM(x_num), .Y_NUM(y_num)
);

/*
wire [15:0]ram_q;
wire [8:0]ram_addr = (x_cell >> 2) + y_cell * 10;
wire wren_b_sig = 1'b0;
wire [15:0]data_b_sig = 16'b0;
gpu_ram gpu_ram_inst(
    .address_a(ADDR),
    .address_b(ram_addr),
    .clock_a(~CLK),
    .clock_b(vga_clk),
    .data_a(DATA),
    .data_b(data_b_sig),
    .wren_a(WREN),
    .wren_b(wren_b_sig),
    .q_a(Q),
    .q_b(ram_q)
);
*/

wire [15:0]RGB;

assign V_R = RGB[15:11];
assign V_G = RGB[10:5];
assign V_B = RGB[4:0];

wire [6:0]x_cell = x_num >> 3;
wire [5:0]y_cell = y_num >> 3;

wire [9:0]vram_rdaddr = (x_cell >> 3) + y_cell * 10;
wire [15:0]vram_q;
vram vram_inst(
    .data(VRAM_DATA),
	.rdaddress(vram_rdaddr),
	.rdclock(vga_clk),
    .wraddress(VRAM_WRADDR),
	.wrclock(CLK),
	.wren(VRAM_WREN),
	.q(vram_q)
);

wire [1:0]color;
always_comb begin
    case (x_cell[2:0])
        3'b000: color = vram_q[15:14]; 
        3'b001: color = vram_q[13:12];
        3'b010: color = vram_q[11:10];
        3'b011: color = vram_q[9:8];
        3'b100: color = vram_q[7:6];
        3'b101: color = vram_q[5:4];
        3'b110: color = vram_q[3:2];
        3'b111: color = vram_q[1:0];
    endcase
end

always_comb begin
    if (&x_num || &y_num) begin
        RGB = 16'b0;
    end
    else begin
        case (color)
            2'b00: RGB = 16'b11111_111111_11111;
            2'b01: RGB = 16'b00000_111111_00000;
            2'b10: RGB = 16'b11111_000000_00000;
            2'b11: RGB = 16'b00000_000000_00000;
        endcase
    end
end

endmodule