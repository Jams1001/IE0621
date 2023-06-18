class driver;
  
  stimulus stim;
  reference_model ref_m;
  virtual interface_1 intf_1;
  logic [3:0][7:0] instruction;
  logic [3:0][7:0] initial_instrc;
  logic [2:0][31:0]reg_ref_m;
  integer ind = 0;
  reg [7:0] mem [65535:0];
  
  
  function new(virtual interface_1 intf_1, reference_model ref_m);
    this.intf_1 = intf_1;
    this.ref_m = ref_m;
  endfunction

  task reset();
    $display("Reset\n");
    intf_1.rst = 1;
    repeat (5) @(posedge intf_1.clk);
    intf_1.rst = 0;
 
  endtask
 
 
  task write(input int iteration);//sequence
    integer k;

    $display("Writing in mem \n");
    
    repeat (iteration)begin//sequence
      stim = new();
      @(negedge intf_1.mem_i_valid_w);
      instruction = stim //sequence_item assemble_R_type_instruction();
      for(k=0; k<4; k=k+1) begin
        mem[ind] = instruction[k];
        tb_top.u_mem.write(ind, mem[ind]);
        ind++;
      end
      ref_m.get_sti({instruction[3], instruction[2], instruction[1], instruction[0]});
    end
    
    
  endtask
  
endclass














