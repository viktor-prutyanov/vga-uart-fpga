module vga_sync(
    input CLK, //25.175 MHz
    output reg V_SYNC,
    output reg H_SYNC,
    output [9:0]X_NUM, 
    output [8:0]Y_NUM
);

parameter H_front_t = 16;
parameter H_sync_t = 96;
parameter H_back_t = 48;
parameter H_active_t = 640;
parameter H_blank_t = H_front_t + H_sync_t + H_back_t;
parameter H_total_t = H_blank_t + H_active_t;

parameter V_front_t = 8; //10
parameter V_sync_t = 2;
parameter V_back_t = 15; //33
parameter V_active_t = 480;
parameter V_blank_t = V_front_t + V_sync_t + V_back_t;
parameter V_total_t = V_blank_t + V_active_t;

reg [9:0]h_cnt = 10'b1111111111;
reg [8:0]v_cnt = 9'b111111111;

initial H_SYNC = 1;
initial V_SYNC = 1;

assign X_NUM = (h_cnt >= H_blank_t) ? (h_cnt - H_blank_t) : 10'b1111111111;
assign Y_NUM = (v_cnt >= V_blank_t) ? (v_cnt - V_blank_t) : 9'b111111111;

always @(posedge CLK) begin
    h_cnt = h_cnt + 1;
    if (h_cnt == H_total_t) begin
        h_cnt = 0;
    end
    else if (h_cnt == H_front_t) begin
        H_SYNC = 0;
    end
    else if (h_cnt == H_front_t + H_sync_t) begin
        H_SYNC = 1;
    end
end

always @(posedge H_SYNC) begin
    v_cnt = v_cnt + 1;
    if (v_cnt == V_total_t) begin
        v_cnt = 0;
    end
    else if (v_cnt == V_front_t) begin
        V_SYNC = 0;
    end
    else if (v_cnt == V_front_t + V_sync_t) begin
        V_SYNC = 1;
    end
end

endmodule