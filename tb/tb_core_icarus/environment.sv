class environment;
	driver drvr;
	scoreboard sb;
  	monitor mntr;
  	reference_model ref_model;
  	virtual interface_1 intf_1;
           
  	function new(virtual interface_1 intf_1);
    	$display("Creating environment");
    	this.intf_1 = intf_1;
      	sb = new();	
      	ref_model = new(sb);
      	drvr = new(intf_1, ref_model);
      	mntr = new(intf_1, sb);
    	fork 
    	  mntr.check();
    	join_none
  	endfunction
           
endclass
