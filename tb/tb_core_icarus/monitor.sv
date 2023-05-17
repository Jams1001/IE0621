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
        if (intf.rs1_w != intf.mem_i_inst_w[19:15]) begin
          $display("Error mem_i_inst_w[19:15]: %b\n",intf.mem_i_inst_w[19:15]);
        end
      end
  endtask
endclass

