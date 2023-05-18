program testcase(interface_1 intf_1);

  // creating enviroment
  environment env = new(intf_1);

  // calling task from driver
  initial begin
    env.drvr.reset();
    
    env.drvr.write(20);
    
    // limit the time simulation because of EDA max 1 min
    #100$finish;
	end
  
endprogram


