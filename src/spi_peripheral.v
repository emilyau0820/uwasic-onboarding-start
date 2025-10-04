`default_nettype none
`timescale 1ns / 1ps

module spi_peripheral (
    input clk,     // clock (10MHz)
    input rst_n,   // active low reset
    input [2:0] in,  // SPI chip select (active low), write to peripherals, clock

    output reg [7:0] en_reg_out_7_0, // data to write
    output reg [7:0] en_reg_out_15_8, // read/write (1b), address (7b)
    output reg [7:0] en_reg_pwm_7_0,
    output reg [7:0] en_reg_pwm_15_8,
    output reg [7:0] pwm_duty_cycle
);

    wire [2:0] in_synced;
    input_sync input_sync_inst (
        .clk(clk),
        .rst_n(rst_n),
        .nCS(in[2]),
        .COPI(in[1]),
        .SCLK(in[0]),

    .sync_out(in_synced[2:0])
    );

    // sample rising & falling edge
    reg prev_SCLK, prev_nCS, transaction_active;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            prev_SCLK <= 1'b0;
            prev_nCS <= 1'b0;
            transaction_active <= 1'b0;
        end
        else begin
            prev_SCLK <= in_synced[0];
            prev_nCS <= in_synced[2];
            if (nCS_negedge) begin
                transaction_active <= 1'b1;
            end
            else if (nCS_posedge) begin
                transaction_active <= 1'b0;
            end
        end
    end

    wire sample_now, nCS_posedge, nCS_negedge;
    assign sample_now = ~prev_SCLK && in_synced[0];
    assign nCS_posedge = ~prev_nCS && in_synced[2];
    assign nCS_negedge = prev_nCS && ~in_synced[2];

    // receiving data
    reg [15:0] shift_reg; // 16-bit transaction (r/w (15), address (14-8), data (7-0))
    reg [15:0] bit_counter;
    reg [15:0] sclk_edge_counter;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            shift_reg <= 16'b0;
            bit_counter <= 16'b0;
        end
        else begin
            if (transaction_active) begin // valid transaction
                if (sample_now) begin 
                    shift_reg[15:0] <= {shift_reg[14:0], in_synced[1]}; // dark magic
                    bit_counter <= bit_counter + 1;
                end
            end
            else begin // reset between transactions
                bit_counter <= 16'b0;
            end
        end
    end

    // write data to registers
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            en_reg_out_7_0 <= 8'b0;
            en_reg_out_15_8 <= 8'b0;
            en_reg_pwm_7_0 <= 8'b0;
            en_reg_pwm_15_8 <= 8'b0;
            pwm_duty_cycle <= 8'b0;
        end
        else begin
            if (nCS_posedge && shift_reg[15] && bit_counter == 16'd16) begin
                case (shift_reg[14:8])
                    7'd0: en_reg_out_7_0 <= shift_reg[7:0];
                    7'd1: en_reg_out_15_8 <= shift_reg[7:0];
                    7'd2: en_reg_pwm_7_0 <= shift_reg[7:0];
                    7'd3: en_reg_pwm_15_8 <= shift_reg[7:0];
                    7'd4: pwm_duty_cycle <= shift_reg[7:0];
                    default:;
                endcase
            end
        end
    end

endmodule

module input_sync (
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