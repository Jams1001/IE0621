interface interface_1(
  input   logic clk,
  [4:0]   rs1_w,
  [4:0]   rs2_w,
  [4:0]   rd_w,
  [31:0]  opcode_w,
  [2:0]   func3_w,
  [6:0]   func7_w,
  [31:0]  reg_file[0:31],
  bit     rd_writeen_w,
  [4:0]   rd_q,
  [31:0]  imm12_r
);

    // Declaring the signals
    logic	 	       rst;
    logic          mem_i_rd_w;
    logic          mem_i_flush_w;
    logic          mem_i_invalidate_w;
    logic [31:0]   mem_i_pc_w;
    logic [31:0]   mem_d_addr_w;
    logic [31:0]   mem_d_data_wr_w;
    logic          mem_d_rd_w;
    logic [3:0]    mem_d_wr_w;
    logic          mem_d_cacheable_w;
    logic [10:0]   mem_d_req_tag_w;
    logic          mem_d_invalidate_w;
    logic          mem_d_writeback_w;
    logic          mem_d_flush_w;
    logic          mem_i_accept_w;
    logic          mem_i_valid_w;
    logic          mem_i_error_w;
    logic [31:0]   mem_i_inst_w;
    logic [31:0]   mem_d_data_rd_w;
    logic          mem_d_accept_w;
    logic          mem_d_ack_w;
    logic          mem_d_error_w;
    logic [10:0]   mem_d_resp_tag_w;

endinterface : interface_1