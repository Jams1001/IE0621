class environment;
	// Enviroment blocks
	driver drvr;
	scoreboard sb;
  	monitor mntr;
  	reference_model ref_model;

	// Interfaces
  	virtual interface_1 intf_1;
    

	// Constructor
  	function new(virtual interface_1 intf_1);
    	$display("Creating environment");
		// obtaining intf_1 from test
    	this.intf_1 = intf_1;
		
		// Initializing enviroment blocks
      	sb = new();	
      	ref_model = new(sb);
      	drvr = new(intf_1, ref_model);
      	mntr = new(intf_1, sb);

		// fork to check concurrently
    	fork 
    	  mntr.check();
    	join_none
  	endfunction
           
endclass
