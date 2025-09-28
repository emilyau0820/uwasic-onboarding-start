`default_nettype none

module spi_peripheral (
    input clk,     // clock (10MHz)
    input rst_n,   // active low reset
    input [2:0] ui_in_synced,  // SPI chip select (active low), write to peripherals, clock

    output reg [7:0] en_reg_out_7_0, // data to write
    output reg [7:0] en_reg_out_15_8, // read/write (1b), address (7b)
    output reg [7:0] en_reg_pwm_7_0,
    output reg [7:0] en_reg_pwm_15_8,
    output reg [7:0] pwm_duty_cycle
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
            prev_SCLK <= ui_in_synced[0];
            prev_nCS <= ui_in_synced[2];
            if (nCS_negedge) begin
                transaction_active <= 1'b1;
            end
            else if (nCS_posedge) begin
                transaction_active <= 1'b0;
            end
        end
    end

    wire sample_now, nCS_posedge, nCS_negedge;
    assign sample_now = prev_SCLK && ~ui_in_synced[0];
    assign nCS_posedge = ~prev_nCS && ui_in_synced[2];
    assign nCS_negedge = prev_nCS && ~ui_in_synced[2];

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
                    shift_reg[15:0] <= {shift_reg[14:0], ui_in_synced[1]}; // dark magic
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