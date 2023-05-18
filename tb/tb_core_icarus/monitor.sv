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
        // check whenever this happends
        @ (negedge intf.mem_i_valid_w)
        // Decode Checking
        $display("======================");
        $display("sb: %d", sb.i);
        $display("cpu.mem_i_inst_w: %b\n",intf.mem_i_inst_w);
        $display("cpu.mem_d_data_rd_w: %b\n",intf.mem_d_data_rd_w);
        // Checking rs1, rs2, and rd
        // rs1
        if (intf.rs1_w==sb.result_ref_rs1[sb.i-1]) begin
          $display(" * PASS * cpu.rs1_w: %b  ::  ref_model.rs1_w: %b\n",intf.rs1_w, sb.result_ref_rs1[sb.i-1]);
        end
        else begin
          $display(" * ERROR * cpu.rs1_w: %b  ::  ref_model.rs1_w: %b\n",intf.rs1_w, sb.result_ref_rs1[sb.i-1]);
          err_count++;
        end
        // rs2
        if (intf.rs2_w==sb.result_ref_rs2[sb.i-1]) begin
          $display(" * PASS * rs2_w: %b  ::    ref_model.rs2_w: %b\n",intf.rs2_w, sb.result_ref_rs2[sb.i-1]);
        end
        else begin
          $display(" * ERROR * rs2_w: %b  ::    ref_model.rs2_w: %b\n",intf.rs2_w, sb.result_ref_rs2[sb.i-1]);
          err_count++;
        end
        // rd
        if (intf.rd_w==sb.result_ref_rd[sb.i-1]) begin
          $display(" * PASS * rd_w: %b   ::    ref_model.rd_w: %b\n",intf.rd_w, sb.result_ref_rd[sb.i-1]);
        end
        else begin
          $display(" * ERROR * rd_w: %b   ::    ref_model.rd_w: %b\n",intf.rd_w, sb.result_ref_rd[sb.i-1]);
          err_count++;
        end
        $display("======================");
      end
  endtask
endclass

