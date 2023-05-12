class driver;

  virtual intf intf_0;
        
  function new(virtual intf intf_0);
    this.intf_0 = intf_0;
  endfunction

  task reset();  // Reset method
    $display("Executing Reset\n");
    // Reset
    //this.intf_0.clk = 0;
    //this.intf_0.rst = 1;
    //repeat (5) @(posedge this.intf_0.clk);
    //this.intf_0.rst = 0;

  endtask
    
endclass