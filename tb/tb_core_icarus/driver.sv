class driver;
  
  stimulus stim;
  //scoreboard sb;
  reference_model ref_m;
  virtual interface_1 intf_1;
  reg [3:0][7:0] instruction;
  logic [2:0][31:0]reg_ref_m;
  
  function new(virtual interface_1 intf_1, reference_model ref_m);
    this.intf_1 = intf_1;
    //this.sb = sb;
    this.ref_m = ref_m;
  endfunction

  task reset();
    reg [7:0] mem[65535:0];
    reg [72:0][7:0] initial_instrc;
    integer i, k, j, ind;
    ind=0;
    $display("Reset\n");
    intf_1.rst = 1;
    repeat (5) @(posedge intf_1.clk);
    intf_1.rst = 0;
    stim = new();
    instruction = stim.initialize();
    for(k=0; k<73; k=k+1) begin
      mem[ind] = initial_instrc[k];
      tb_top.u_mem.write(ind, mem[ind]);
      ind++;
    end
    //ref_m.get_sti({instruction[3], instruction[2], instruction[1], instruction[0]});

  endtask
  
  
  task write(input int iteration);
    
    reg [7:0] mem[65535:0];
  	integer i, k, j, ind;
    ind=4;
    $display("Writing in mem \n");
     // Load TCM memory
	for (i=0;i<65535;i=i+1) begin
        mem[i] = 0;
  	end
    repeat (iteration)begin
        stim = new();
      @(negedge intf_1.mem_i_valid_w);
      instruction =stim.assemble_R_type_instruction();
      for(k=0; k<4; k=k+1) begin
        mem[ind] = instruction[k];
        tb_top.u_mem.write(ind, mem[ind]);
        ind++;
      end
      ref_m.get_sti({instruction[3], instruction[2], instruction[1], 			instruction[0]});
    end
    //for(j=0; j<300; j=j+1) begin
      //instruction = {8'b01101111, 8'b0, 8'b0, 8'b00100110};
      
        //$display("%b", instruction[k]);

        
      //end
      
    //end
    //$readmemb("binario.txt", mem);
    //Guardar en la ram
    /*for (i=0;i<65535;i=i+1) begin
      tb_top.u_mem.write(i, mem[i]);
	end*/
  endtask
  
endclass
