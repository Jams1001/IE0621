`include "intf.sv"

module tb_top;

reg clk;
reg rst;

reg [7:0] mem[65535:0];
integer i;
integer f;

initial
begin
    $display("Starting bench");

    if (`TRACE)
    begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_top);
    end

    // Reset
    clk = 0;
    rst = 1;
    repeat (5) @(posedge clk);
    rst = 0;

    // Load TCM memory
    for (i=0;i<65535;i=i+1)
        mem[i] = 0;

    f = $fopenr("./build/tcm.bin");
    i = $fread(mem, f);
    for (i=0;i<65535;i=i+1)
        u_mem.write(i, mem[i]);
end

initial
begin
    forever
    begin 
        clk = #5 ~clk;
    end
end

/*
wire          mem_i_rd_w;
wire          mem_i_flush_w;
wire          mem_i_invalidate_w;
wire [ 31:0]  mem_i_pc_w;
wire [ 31:0]  mem_d_addr_w;
wire [ 31:0]  mem_d_data_wr_w;
wire          mem_d_rd_w;
wire [  3:0]  mem_d_wr_w;
wire          mem_d_cacheable_w;
wire [ 10:0]  mem_d_req_tag_w;
wire          mem_d_invalidate_w;
wire          mem_d_writeback_w;
wire          mem_d_flush_w;
wire          mem_i_accept_w;
wire          mem_i_valid_w;
wire          mem_i_error_w;
wire [ 31:0]  mem_i_inst_w;
wire [ 31:0]  mem_d_data_rd_w;
wire          mem_d_accept_w;
wire          mem_d_ack_w;
wire          mem_d_error_w;
wire [ 10:0]  mem_d_resp_tag_w;
*/

intf intf_0(clk, rst);

riscv_core
u_dut
//-----------------------------------------------------------------
// Ports
//-----------------------------------------------------------------
(
    // Inputs
     .clk_i(clk)
    ,.rst_i(rst)
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
    ,.rst_i(rst)
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

endmodule