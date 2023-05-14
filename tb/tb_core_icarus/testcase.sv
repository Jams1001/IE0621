program testcase(interface_1 intf_1);

  environment env = new(intf_1);
  initial begin
    env.drvr.reset();
    
    env.drvr.write("./binario.txt");
    
    #50$finish;
	end
  
endprogram


