class monitor;
  scoreboard sb;
  virtual interface_1 intf;

  //logic [7:0] sb_value;
  int err_count;
  
          
  function new(virtual interface_1 intf, scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
          
  task check();
    err_count = 0;
    forever
      begin
        @ (negedge intf.mem_i_valid_w)
        $display("======================");
        $display("sb: %d", sb.i);
        $display("mem_i_inst_w: %b\n",intf.mem_i_inst_w);
        $display("mem_d_data_rd_w: %b\n",intf.mem_d_data_rd_w);
        $display("cpu.rs1_w: %b    ref_model.rs1_w: %b\n",intf.rs1_w, sb.result_ref_rs1[sb.i-1]);
        $display("rs2_w: %b\n      ref_model.rs2_w: %b\n",intf.rs2_w, sb.result_ref_rs2[sb.i-1]);
        $display("rd_w: %b\n       ref_model.rd_w: %b\n",intf.rd_w, sb.result_ref_rd[sb.i-1]);
        if (intf.rs1_w != intf.mem_i_inst_w[19:15]) begin
          $display("Error mem_i_inst_w[19:15]: %b\n",intf.mem_i_inst_w[19:15]);
        end
        $display("======================");
      end
  endtask
endclass

