class monitor;
  // monitor blocks
  scoreboard sb;
  // monitor interface
  virtual interface_1 intf;

  // monitor variables
  int err_count;
  
  // monitor constructor
  function new(virtual interface_1 intf, scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
          
  // function to not repeat code
  function void verfy(logic [6:0] cpu, ref_val, string name);
    if (cpu==ref_val) begin
      $display(" * PASS * cpu.%s: %b  ::  ref.%s: %b\n", name, cpu, name, ref_val);
    end
    else begin
      $display(" * ERROR * cpu.%s: %b  ::  ref.%s: %b\n", name, cpu, name, ref_val);
      err_count++;
    end
  endfunction
  
  task check_decode();
    err_count = 0;
    forever
      begin
        // check whenever this happends
        @ (negedge intf.mem_i_valid_w && intf.rst==0)
        // Decode Checking
        $display("======================");
        $display("Time: %d", $time);
        $display("sb: %d", sb.i);
        $display("errors: %d", err_count);
        $display("cpu.mem_i_inst_w: %b\n",intf.mem_i_inst_w);
        $display("cpu.mem_d_data_rd_w: %b\n",intf.mem_d_data_rd_w);
        // Checking rs1, rs2, func7, func3, and rd
        // rs1
        verfy(intf.rs1_w, sb.result_ref_rs1[sb.i-1], "rs1");
        // rs2
        verfy(intf.rs2_w, sb.result_ref_rs2[sb.i-1], "rs2");
        // rd
        verfy(intf.rd_w, sb.result_ref_rd[sb.i-1], "rd");
        // func7
        verfy(intf.func7_w, sb.result_ref_func_7[sb.i-1], "func7");
        // func3
        verfy(intf.func3_w, sb.result_ref_func_3[sb.i-1], "func3");
        $display("======================");
      end
  endtask
  
  task check_initial();
    forever
      begin
        @ (negedge intf.rd_writeen_w)
        $display("Time: %d", $time);
        if (intf.reg_file[intf.rd_q]==0)
          $display(" *PASS* Register value : %b register id: %d\n", intf.reg_file[intf.rd_q], intf.rd_q); 
        else
          $display(" *FAIL* Register value : %b register id: %d\n", intf.reg_file[intf.rd_q], intf.rd_q); 
      end
  endtask
 
  
endclass

