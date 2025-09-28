`default_nettype none
`timescale 1ns / 1ps
// `include "src/project.v"

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

    wire SCLK;
    reg COPI, nCS;
    reg SCLK_freerun, SCLK_gate;
    assign SCLK = ~SCLK_gate | SCLK_freerun;
    // Clock generation
    initial begin
      clk = 0;
      forever #50 clk = ~clk;
    end
    
    initial begin
      SCLK_freerun = 1;
      forever #5000 SCLK_freerun = ~SCLK_freerun;
    end

    initial begin
      nCS=1'b1;
      COPI=1'b0;
      rst_n = 1'b0;
      SCLK_gate = 0;
      @(posedge clk); rst_n = 1'b1;    // de-assert reset

      // WRITE TO 0
      // reset
      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;
      
      // r/w bit (1b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      SCLK_gate = 1;

      // address (7b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;

      // data (8b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;

      // WRITE TO 1
      // reset
      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;

      // r/w bit (1b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      // address (7b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      // data (8b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      // WRITE TO 2
      // reset
      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;

      // r/w bit (1b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      // address (7b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;

      // data (8b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;

      // WRITE TO 3
      // reset
      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;

      // r/w bit (1b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      // address (7b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      // data (8b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      // WRITE TO 4
      // reset
      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;
      
      // r/w bit (1b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      // address (7b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;

      // data (8b)
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b1;

      @(posedge SCLK_freerun); nCS=1'b0; COPI=1'b0;

      SCLK_gate = 0;

      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;
      @(posedge SCLK_freerun); nCS=1'b1; COPI=1'b0;

      #1000000;

      $finish;
    end

  // Replace tt_um_example with your module name:
  tt_um_uwasic_onboarding_emily_au user_project(

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  ({5'b00000, nCS, COPI, SCLK}),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

endmodule