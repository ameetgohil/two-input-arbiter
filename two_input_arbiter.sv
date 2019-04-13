module two_input_arbiter
  #(parameter DWIDTH=32)
   (input wire[DWIDTH-1:0] t0_data,
    input wire              t0_valid,
    output reg              t0_ready,
    input wire [DWIDTH-1:0] t1_data,
    input wire              t1_valid,
    output reg              t1_ready,
    output reg [DWIDTH-1:0] i0_data,
    output reg              i0_valid,
    input wire              i0_ready,
    input wire              clk, rstf
    );

   wire                     target_active;
   reg                      rr; // round robing priority

   assign target_active = (rr == 0 && t0_valid) ? 0:
                          (rr == 1 && t0_valid) ? 1:
                          t0_valid ? 0:
                          t1_valid ? 1:
                          0;

   assign i0_data = (target_active) ? t1_data:t0_data;

   assign i0_valid = (target_active) ? t1_valid:t0_valid;
   
   assign t0_ready = (target_active) ? 0:i0_ready;
   assign t1_ready = (target_active) ? i0_ready:0;

   always @(posedge clk or negedge rstf)
     if(~rstf) begin
        rr <= 0;
     end
     else begin
        if(t0_valid && t0_ready)
          rr <= 1;
        else(t1_valid && t0_ready)
          rr <= 0;
     end
end

endmodule
