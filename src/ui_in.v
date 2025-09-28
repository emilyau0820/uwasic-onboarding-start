`default_nettype none

module ui_in (
    input clk,     // clock (10MHz)
    input rst_n,   // active low reset
    input nCS,     // SPI chip select (active low)
    input COPI,    // SPI write to peripherals
    input SCLK,    // SPI clock


    output [2:0] sync_out // SPI chip select (active low), write to peripherals, clock
);

    // 2 stage flip flop synchronization
    dff_synchronization dff_sync_nCS (.clk(clk), .rst_n(rst_n), .data_in(nCS), .data_out(sync_out[2]));
    dff_synchronization dff_sync_COPI (.clk(clk), .rst_n(rst_n), .data_in(COPI), .data_out(sync_out[1]));
    dff_synchronization dff_sync_SCLK (.clk(clk), .rst_n(rst_n), .data_in(SCLK), .data_out(sync_out[0]));

endmodule

module dff_synchronization (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);
    reg data_reg1, data_reg2;
    
    // d flip-flop
    always @(negedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_reg1 <= 1'b0;
            data_reg2 <= 1'b0;
        end
        else begin
            data_reg1 <= data_in;
            data_reg2 <= data_reg1;
        end
    end

    assign data_out = data_reg2;

endmodule