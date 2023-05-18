module tb_top;

// tb_top clock
reg clk;

// initializing interface
interface_1 intf_0(
  clk,
  u_dut.rs1_w,
  u_dut.rs2_w, 
  u_dut.rd_w
);

// dumpfile, dumpvars, and initialazing clk = 0
initial
begin
	$display("Starting bench");
  	$dumpfile("dump.vcd");
    $dumpvars;
    // Reset
    clk = 0;

end

// loop for clk
initial
begin
    forever
    begin 
        clk = #1 ~clk;
    end
end

 
  

riscv_core
u_dut
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     .clk_i(clk)
  ,.rst_i(intf_0.rst)
    ,.mem_d_data_rd_i(intf_0.mem_d_data_rd_w)
    ,.mem_d_accept_i(intf_0.mem_d_accept_w)
    ,.mem_d_ack_i(intf_0.mem_d_ack_w)
    ,.mem_d_error_i(intf_0.mem_d_error_w)
    ,.mem_d_resp_tag_i(intf_0.mem_d_resp_tag_w)
    ,.mem_i_accept_i(intf_0.mem_i_accept_w)
    ,.mem_i_valid_i(intf_0.mem_i_valid_w)
    ,.mem_i_error_i(intf_0.mem_i_error_w)
    ,.mem_i_inst_i(intf_0.mem_i_inst_w)
    ,.intr_i(1'b0)
    ,.reset_vector_i(32'h80000000)
    ,.cpu_id_i('b0)

    // Outputs
    ,.mem_d_addr_o(intf_0.mem_d_addr_w)
    ,.mem_d_data_wr_o(intf_0.mem_d_data_wr_w)
    ,.mem_d_rd_o(intf_0.mem_d_rd_w)
    ,.mem_d_wr_o(intf_0.mem_d_wr_w)
    ,.mem_d_cacheable_o(intf_0.mem_d_cacheable_w)
    ,.mem_d_req_tag_o(intf_0.mem_d_req_tag_w)
    ,.mem_d_invalidate_o(intf_0.mem_d_invalidate_w)
    ,.mem_d_writeback_o(intf_0.mem_d_writeback_w)
    ,.mem_d_flush_o(intf_0.mem_d_flush_w)
    ,.mem_i_rd_o(intf_0.mem_i_rd_w)
    ,.mem_i_flush_o(intf_0.mem_i_flush_w)
    ,.mem_i_invalidate_o(intf_0.mem_i_invalidate_w)
    ,.mem_i_pc_o(intf_0.mem_i_pc_w)
);

tcm_mem
u_mem
(
    // Inputs
     .clk_i(clk)
  	,.rst_i(intf_0.rst)
    ,.mem_i_rd_i(intf_0.mem_i_rd_w)
    ,.mem_i_flush_i(intf_0.mem_i_flush_w)
    ,.mem_i_invalidate_i(intf_0.mem_i_invalidate_w)
    ,.mem_i_pc_i(intf_0.mem_i_pc_w)
    ,.mem_d_addr_i(intf_0.mem_d_addr_w)
    ,.mem_d_data_wr_i(intf_0.mem_d_data_wr_w)
    ,.mem_d_rd_i(intf_0.mem_d_rd_w)
    ,.mem_d_wr_i(intf_0.mem_d_wr_w)
    ,.mem_d_cacheable_i(intf_0.mem_d_cacheable_w)
    ,.mem_d_req_tag_i(intf_0.mem_d_req_tag_w)
    ,.mem_d_invalidate_i(intf_0.mem_d_invalidate_w)
    ,.mem_d_writeback_i(intf_0.mem_d_writeback_w)
    ,.mem_d_flush_i(intf_0.mem_d_flush_w)

    // Outputs
    ,.mem_i_accept_o(intf_0.mem_i_accept_w)
    ,.mem_i_valid_o(intf_0.mem_i_valid_w)
    ,.mem_i_error_o(intf_0.mem_i_error_w)
    ,.mem_i_inst_o(intf_0.mem_i_inst_w)
    ,.mem_d_data_rd_o(intf_0.mem_d_data_rd_w)
    ,.mem_d_accept_o(intf_0.mem_d_accept_w)
    ,.mem_d_ack_o(intf_0.mem_d_ack_w)
    ,.mem_d_error_o(intf_0.mem_d_error_w)
    ,.mem_d_resp_tag_o(intf_0.mem_d_resp_tag_w)
);

  // creating testcase 
  testcase test(intf_0);
  
endmodule