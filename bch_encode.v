`timescale 1ns / 1ps

module bch_encode #(
    parameter N = 63,
    parameter K = 24,
    parameter WIDTH = 1
) (
    input  clk,
    input  rst_n,
    input  data_in,
    input  data_valid,
    output ecc_out,
    output ecc_valid
);
  wire [WIDTH-1:0] reg_d[0:N-K-1];
  wire [WIDTH-1:0] reg_q[0:N-K-1];



  // Synthesizable ROM for BCH generator polynomial coefficients (g_0 to g_{n-k})
  // Example polynomial: x^39 + x^36 + x^34 + x^33 + x^30 + x^27 + x^25 + x^24 + x^22 + x^20 + x^19 + x^18 + x^16 + x^15 + x^14 + x^13 + x^11 + x^7 + x^4 + x^2 + 1
  wire g_coeff[0:N-K];

  // Hard-coded coefficients (synthesizable constant array)
  assign g_coeff[0]  = 1;
  assign g_coeff[1]  = 0;
  assign g_coeff[2]  = 0;
  assign g_coeff[3]  = 0;
  assign g_coeff[4]  = 0;
  assign g_coeff[5]  = 1;
  assign g_coeff[6]  = 0;
  assign g_coeff[7]  = 0;
  assign g_coeff[8]  = 1;
  assign g_coeff[9]  = 0;
  assign g_coeff[10] = 0;
  assign g_coeff[11] = 1;
  assign g_coeff[12] = 0;
  assign g_coeff[13] = 0;
  assign g_coeff[14] = 0;
  assign g_coeff[15] = 0;
  assign g_coeff[16] = 0;
  assign g_coeff[17] = 1;
  assign g_coeff[18] = 0;
  assign g_coeff[19] = 0;
  assign g_coeff[20] = 0;
  assign g_coeff[21] = 0;
  assign g_coeff[22] = 1;
  assign g_coeff[23] = 1;
  assign g_coeff[24] = 0;
  assign g_coeff[25] = 1;
  assign g_coeff[26] = 0;
  assign g_coeff[27] = 1;
  assign g_coeff[28] = 1;
  assign g_coeff[29] = 0;
  assign g_coeff[30] = 0;
  assign g_coeff[31] = 1;
  assign g_coeff[32] = 0;
  assign g_coeff[33] = 1;
  assign g_coeff[34] = 1;
  assign g_coeff[35] = 0;
  assign g_coeff[36] = 1;
  assign g_coeff[37] = 1;
  assign g_coeff[38] = 1;
  assign g_coeff[39] = 1;

  wire [31:0] lfsr_count_r;
  wire [31:0] lfsr_count_n;

  assign lfsr_count_n = lfsr_count_r == K - 1 ? lfsr_count_r : lfsr_count_r + 1;
  dfflr #(32) lfsr_count (
      data_valid,
      lfsr_count_n,
      lfsr_count_r,
      clk,
      rst_n
  );

  // Feedback calculation using ROM coefficients
  wire feedback = lfsr_count_r == K - 1 ? 0 : reg_q[N-K-1] ^ (data_in & g_coeff[0]);

  // Generate LFSR
  genvar i;
  generate
    for (i = 0; i < N - K; i = i + 1) begin : shift_register
      wire [WIDTH-1:0] d_in;
      // If g_{i+1} is 1, include feedback in the input
      if (i == 0) begin
        assign d_in = feedback;
      end else begin
        assign d_in = g_coeff[i] ? (reg_q[i-1] ^ feedback) : reg_q[i-1];
      end

      dfflr #(WIDTH) dff_inst (
          .lden (data_valid),
          .dnxt (d_in),
          .qout (reg_q[i]),
          .clk  (clk),
          .rst_n(rst_n)
      );
    end
  endgenerate

  assign ecc_out   = reg_q[N-K-1];
  assign ecc_valid = lfsr_count_r == K - 1;
endmodule
