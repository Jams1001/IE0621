class monitor;
  //scoreboard sb;
  virtual interface_1 intf;

  //logic [7:0] sb_value;
  int err_count;
          
  function new(virtual interface_1 intf/*,scoreboard sb*/);
    this.intf = intf;
    //this.sb = sb;
  endfunction
          
  task check();
    err_count = 0;
    forever
      begin
        @ (posedge intf.clk)
        $display("======================");
        $display("mem_i_inst_w: %b\n",intf.mem_i_inst_w);
        $display("mem_d_data_rd_w: %b\n",intf.mem_d_data_rd_w);
        $display("rs1_w: %b\n",intf.rs1_w);
        $display("rs2_w: %b\n",intf.rs2_w);
        $display("rd_w: %b\n",intf.rd_w);
        if (intf.rs1_w != intf.mem_i_inst_w[19:15]) begin
          $display("Error mem_i_inst_w[19:15]: %b\n",intf.mem_i_inst_w[19:15]);
        end
        $display("======================");
      end
  endtask
endclass

