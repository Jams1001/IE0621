program testcase(interface_1 intf_1);

  // creating enviroment
  environment env = new(intf_1);

  // calling task from driver
  initial begin
    env.drvr.reset();
    
    env.drvr.write(40);
    
    $finish;
	end
  
endprogram