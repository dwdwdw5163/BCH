//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  All of the general DFF and Latch modules
//
// ====================================================================

//


//
// ===========================================================================
//
// Description:
//  Verilog module sirv_gnrl DFF with Load-enable and Reset
//  Default reset value is 1
//
// ===========================================================================

module dfflrs #(
    parameter DW = 32
) (

    input           lden,
    input  [DW-1:0] dnxt,
    output [DW-1:0] qout,

    input clk,
    input rst_n
);

   reg [DW-1:0] qout_r;

   always @(posedge clk or negedge rst_n) begin : DFFLRS_PROC
      if (rst_n == 1'b0) qout_r <= {DW{1'b1}};
      else if (lden == 1'b1) qout_r <= #1 dnxt;
   end

   assign qout = qout_r;

endmodule
// ===========================================================================
//
// Description:
//  Verilog module sirv_gnrl DFF with Load-enable and Reset
//  Default reset value is 0
//
// ===========================================================================

module dfflr #(
    parameter DW = 32
) (

    input           lden,
    input  [DW-1:0] dnxt,
    output [DW-1:0] qout,

    input clk,
    input rst_n
);

   reg [DW-1:0] qout_r;

   always @(posedge clk or negedge rst_n) begin : DFFLR_PROC
      if (rst_n == 1'b0) qout_r <= {DW{1'b0}};
      else if (lden == 1'b1) qout_r <= #1 dnxt;
   end

   assign qout = qout_r;

endmodule
// ===========================================================================
//
// Description:
//  Verilog module sirv_gnrl DFF with Load-enable, no reset
//
// ===========================================================================

module dffl #(
    parameter DW = 32
) (

    input           lden,
    input  [DW-1:0] dnxt,
    output [DW-1:0] qout,

    input clk
);

   reg [DW-1:0] qout_r;

   always @(posedge clk) begin : DFFL_PROC
      if (lden == 1'b1) qout_r <= #1 dnxt;
   end

   assign qout = qout_r;

endmodule
// ===========================================================================
//
// Description:
//  Verilog module sirv_gnrl DFF with Reset, no load-enable
//  Default reset value is 1
//
// ===========================================================================

module dffrs #(
    parameter DW = 32
) (

    input  [DW-1:0] dnxt,
    output [DW-1:0] qout,

    input clk,
    input rst_n
);

   reg [DW-1:0] qout_r;

   always @(posedge clk or negedge rst_n) begin : DFFRS_PROC
      if (rst_n == 1'b0) qout_r <= {DW{1'b1}};
      else qout_r <= #1 dnxt;
   end

   assign qout = qout_r;

endmodule
// ===========================================================================
//
// Description:
//  Verilog module sirv_gnrl DFF with Reset, no load-enable
//  Default reset value is 0
//
// ===========================================================================

module dffr #(
    parameter DW = 32
) (

    input  [DW-1:0] dnxt,
    output [DW-1:0] qout,

    input clk,
    input rst_n
);

   reg [DW-1:0] qout_r;

   always @(posedge clk or negedge rst_n) begin : DFFR_PROC
      if (rst_n == 1'b0) qout_r <= {DW{1'b0}};
      else qout_r <= #1 dnxt;
   end

   assign qout = qout_r;

endmodule
