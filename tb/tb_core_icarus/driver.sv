class riscv_item extends uvm_sequence_item;

  logic       [6:0]   funct7 = 7'b0;
  rand logic  [4:0]   rs2;
  rand logic  [4:0]   rs1;
  logic       [2:0]   funct3;
  rand logic  [4:0]   rd;
  logic       [6:0]   opcode;
  rand logic  [11:0]  imm;
  logic       [31:0]  instr;
  
  constraint c1 { rs2 inside {[1:31]}; rs1 inside {[1:31]}; rd inside {[1:31]}; }
  
  `uvm_object_utils_begin(riscv_item)
    `uvm_field_int (funct7, UVM_DEFAULT)
    `uvm_field_int (rs1, UVM_DEFAULT)
    `uvm_field_int (rs2, UVM_DEFAULT)
    `uvm_field_int (funct3, UVM_DEFAULT)
    `uvm_field_int (rd, UVM_DEFAULT)
    `uvm_field_int (opcode, UVM_DEFAULT)
    `uvm_field_int (imm, UVM_DEFAULT)
    `uvm_field_int (instr, UVM_DEFAULT)
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


  // Config total number of items to be sent
  rand int num;

  constraint c1 { num inside {[6:7]}; }


  virtual task body();
    riscv_item r_item = riscv_item::type_id::create("r_item");

    for (int i = 0; i < num; i ++) begin
      start_item(r_item);
      r_item.randomize();
      r_item.opcode = 7'b0110011;  // opcode for R type defalt
      r_item.funct7 = 7'b0000000;
      r_item.funct3 = 3'b000;
      r_item.instr = {r_item.funct7, r_item.rs2, r_item.rs1, r_item.funct3, r_item.rd, r_item.opcode};
      `uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
      r_item.print();
      finish_item(r_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass



class riscv_driver extends uvm_driver #(riscv_item);

  `uvm_component_utils (riscv_driver)
  virtual interface_1 riscv_intf;
  logic [65535:0][7:0] mem;
  int ind = 0;


  function new (string name = "riscv_driver", uvm_component parent = null);
    super.new (name, parent);
  endfunction
	

  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(uvm_config_db #(virtual interface_1)::get(this, "", "VIRTUAL_INTERFACE", riscv_intf) == 0) begin
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
      write_riscv(r_item.instr);
      seq_item_port.item_done();
    end
  endtask  


  virtual task write_riscv(logic [31:0] instr);
    for(int k=0; k<4; k=k+1) begin
      mem[ind] = instr[k*8 +: 8];
      top_hdl.u_mem.write(ind, mem[ind]);
      //`uvm_info ("write_riscv", $sformatf("Data received = 0x%7h", mem[ind]), UVM_MEDIUM);
      ind++;
    end 
  endtask


  virtual task riscv_reset();
    $display("Reset\n");
    riscv_intf.rst = 1;
    repeat (5) @(posedge riscv_intf.clk);
    riscv_intf.rst = 0;
  endtask
endclass

