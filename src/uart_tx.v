module uart_tx
(
    input CLK,
    
    input TXD,
    output reg [7:0]DATA,
    output IDLE
);

initial DATA[7:0] = 8'b0;
assign IDLE = (bit_num == 4'b1010);

reg [12:0]cnt = 13'b0;
reg uart_clk = 1'b0;
reg [3:0]bit_num = 4'b1010;

always @(posedge CLK) begin
    if (cnt == 5000) begin //48000000 = 5000 * 9600
        cnt <= 13'b0;
        uart_clk <= 1'b1;
    end
    else begin
        cnt <= cnt + 13'b1;
        uart_clk <= 1'b0;
    end
end

always @(posedge uart_clk) begin
    if (TXD == 1'b0 & (bit_num == 4'b1010)) begin
        bit_num = 4'b0;
    end
    case (bit_num)
        4'b0000: begin 
            bit_num = 4'b1;  
        end
        4'b0001: begin DATA[0] = TXD; bit_num = 2;  end
        4'b0010: begin DATA[1] = TXD; bit_num = 3;  end
        4'b0011: begin DATA[2] = TXD; bit_num = 4;  end
        4'b0100: begin DATA[3] = TXD; bit_num = 5;  end
        4'b0101: begin DATA[4] = TXD; bit_num = 6;  end
        4'b0110: begin DATA[5] = TXD; bit_num = 7;  end
        4'b0111: begin DATA[6] = TXD; bit_num = 8;  end
        4'b1000: begin DATA[7] = TXD; bit_num = 9;  end
        4'b1001: begin 
            bit_num = 4'b1010;
        end
    endcase
end

endmodule