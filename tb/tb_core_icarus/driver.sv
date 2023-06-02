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
 
 
  task write(input int iteration);
    integer k;

    $display("Writing in mem \n");
    
    repeat (iteration)begin
      stim = new();
      @(negedge intf_1.mem_i_valid_w);
      instruction = stim.assemble_R_type_instruction();
      for(k=0; k<4; k=k+1) begin
        mem[ind] = instruction[k];
        tb_top.u_mem.write(ind, mem[ind]);
        ind++;
      end
      ref_m.get_sti({instruction[3], instruction[2], instruction[1], instruction[0]});
    end
    
    
  endtask
  
endclass

class riscv_item extends uvm_sequence_item;

  rand logic [7:0] data;
  rand bit   rd;

  // Use utility macros to implement standard functions
  // like print, copy, clone, etc
  `uvm_object_utils_begin(riscv_item)
    `uvm_field_int (data, UVM_DEFAULT)
    `uvm_field_int (rd, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "riscv_item");
    super.new(name);
  endfunction
endclass

class gen_item_seq extends uvm_sequence;
  `uvm_object_utils(gen_item_seq)
  function new(string name="gen_item_seq");
    super.new(name);
  endfunction

  rand int num; 	// Config total number of items to be sent

  constraint c1 { num inside {[2:5]}; }

  virtual task body();
    riscv_item r_item = riscv_item::type_id::create("r_item");
    for (int i = 0; i < num; i ++) begin
        start_item(r_item);
    	r_item.randomize();
    	`uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
    	r_item.print();
        finish_item(r_item);
        //`uvm_do(r_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass


class riscv_driver extends uvm_driver #(riscv_item);

  `uvm_component_utils (riscv_driver)
   function new (string name = "riscv_driver", uvm_component parent = null);
     super.new (name, parent);
   endfunction

   virtual intf1 riscv_intf;

   virtual function void build_phase (uvm_phase phase);
     super.build_phase (phase);
     if(uvm_config_db #(virtual intf1)::get(this, "", "VIRTUAL_INTERFACE", riscv_intf) == 0) begin
       `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
     end
   endfunction
   
   virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      riscv_item r_item;
      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(r_item);
      fork
        drive_riscv(r_item);
        read_riscv(r_item);
      join
      seq_item_port.item_done();
    end
  endtask  

  virtual task drive_riscv(riscv_item r_item);
    if(r_item.rd ==0)   
      begin
        @ (negedge riscv_intf.clk);
        $display("Driving 0x%h value in the DUT\n", r_item.data);
        riscv_intf.data_in = r_item.data; // Drive to DUT
        riscv_intf.wr_en = 1;
        @ (negedge riscv_intf.clk);
        riscv_intf.wr_en = 0;
      end
  endtask
  
  virtual task read_riscv(riscv_item r_item);
    if(r_item.rd ==1)
      begin
        @ (negedge riscv_intf.clk);
        riscv_intf.rd_en = 1;
        @ (negedge riscv_intf.clk);
        riscv_intf.rd_en = 0;
      end
  endtask
       
  virtual task riscv_reset();  // Reset method
    display("Reset\n");
    riscv_intf.rst = 1;
    repeat (5) @(posedge riscv_intf.clk);
    riscv_intf.rst = 0;

  endtask
        
  
endclass

