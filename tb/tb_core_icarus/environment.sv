class environment;
	driver drvr;
	//scoreboard sb;
  	monitor mntr;
  	virtual interface_1 intf_1;
           
  	function new(virtual interface_1 intf_1);
    	$display("Creating environment");
    	this.intf_1 = intf_1;
    	drvr = new(intf_1);
      	mntr = new(intf_1);
        //sb = new();
    	fork 
    	  mntr.check();
    	join_none
  	endfunction
           
endclass
