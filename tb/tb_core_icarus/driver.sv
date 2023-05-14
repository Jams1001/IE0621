class driver;
  
  //stimulus sti;
  //scoreboard sb;
  virtual interface_1 intf_1;
 
  
  function new(virtual interface_1 intf_1);
    this.intf_1 = intf_1;
    //this.sb = sb;
  endfunction

  task reset();
    $display("Reset\n");
    intf_1.rst = 1;
    repeat (5) @(posedge intf_1.clk);
    intf_1.rst = 0;

  endtask
  
  task write(string str);
    reg [7:0] mem[65535:0];
  	integer i;
    
    $display("Writing in mem \n");
     // Load TCM memory
	for (i=0;i<10000;i=i+1) begin
        mem[i] = 0;
  	end
    $readmemb(str, mem);
    for (i=0;i<10000;i=i+1) begin
      tb_top.u_mem.write(i, mem[i]);
	end
  endtask
  
endclass
