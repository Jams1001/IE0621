class inst_base_item extends uvm_sequence_item;

  logic [6:0] funct7;
  rand logic [4:0] rs2;
  rand logic [4:0] rs1;
  rand logic [2:0] funct3;
  rand logic [4:0] rd;
  rand logic [6:0] opcode;
  rand logic [11:0] imm;
  rand logic [31:0] instr;
  rand logic [3:0][7:0] init_instr;
  reg [7:0] mem [65535:0];

  `uvm_object_utils_begin(inst_base_item)
    `uvm_field_int (funct7, UVM_DEFAULT)
    `uvm_field_int (rs1, UVM_DEFAULT)
    `uvm_field_int (rs2, UVM_DEFAULT)
    `uvm_field_int (funct3, UVM_DEFAULT)
    `uvm_field_int (rd, UVM_DEFAULT)
    `uvm_field_int (opcode, UVM_DEFAULT)
    `uvm_field_int (imm, UVM_DEFAULT)
    `uvm_field_int (instr, UVM_DEFAULT)
    `uvm_field_int (init_instr, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "riscv_item");
    super.new(name);
  endfunction
endclass



class r_item extends inst_base_item;
  function new(string name = "r_item");
    super.new(name);
    opcode; = 7'b0110011;  // opcode for R type
    instr = {imm, rs1, funct3, rd, opcode};
  endfunction
endclass


class i_item extends inst_base_item;
  function new(string name = "r_item");
    super.new(name);
    opcode = 7'b0010011;  // opcode for I type
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
    r_item r_item = r_item::type_id::create("r_item");
    i_item i_item = i_item::type_id::create("i_item");
    
    for (int i = 0; i < num; i ++) begin
      start_item(r_item);
      start_item(i_item);
      if ($random()%2 == 0) begin
    	  r_item.randomize();
        `uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
    	  r_item.print();
      finish_item(r_item);
      end else begin
        i_item.randomize();
      `uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
    	i_item.print();
      finish_item(r_item);
      end
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
      riscv_item i_item;

      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(r_item);

      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(i_item);

      write_riscv(r_item.instr);
      write_riscv(i_item.instr);
      seq_item_port.item_done();
    end
  endtask  


  virtual task write_riscv(riscv_item r_item);
  
    for(k=0; k<4; k=k+1) begin
      mem[ind] = instruction[k];
      tb_top.u_mem.write(ind, mem[ind]);
      ind++;
    end
  endtask
       




  virtual task riscv_reset();  // Reset method
    display("Reset\n");
    riscv_intf.rst = 1;
    repeat (5) @(posedge riscv_intf.clk);
    riscv_intf.rst = 0;
  endtask
        
  
endclass

