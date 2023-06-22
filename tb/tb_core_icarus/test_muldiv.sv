class test_muldiv extends test_basic;

  `uvm_component_utils(test_muldiv)

  function new (string name="test_muldiv", uvm_component parent=null);
    super.new (name, parent);
    // tiempo de simulacion luego del reset
    t = 1960;
    // valores iniciales de los registros del cpu
    init_reg_val = 32'b1;
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
  	 
     // Get handle to the singleton factory instance
    uvm_factory factory = uvm_factory::get();
    
    super.build_phase(phase);
    
    //factory to override 'base_agent' by 'child_agent' by name
    factory.set_type_override_by_name("gen_item_seq", "gen_item_seq_muldiv");
	factory.set_type_override_by_name("riscv_scoreboard", "riscv_scoreboard_muldiv");
    factory.set_type_override_by_name("riscv_monitor_wr", "riscv_monitor_wr_muldiv");
    factory.set_type_override_by_name("riscv_monitor_rd", "riscv_monitor_rd_muldiv");
    // Print factory configuration
    factory.print();
  endfunction
 
endclass


// generador de item 

class gen_item_seq_muldiv extends gen_item_seq;
  `uvm_object_utils(gen_item_seq_muldiv)
  function new(string name="gen_item_seq_muldiv");
    super.new(name);
  endfunction

  rand int num; 	// Config total number of items to be sent

  constraint c1 { num inside {[25:32]}; 
                }

  virtual task body();
    riscv_item r_item = riscv_item::type_id::create("r_item");
    for (int i = 0; i < num; i ++) begin
    	start_item(r_item);
      	r_item.randomize();
    	r_item.opcode = 7'b0010011;  // opcode for I type
    	r_item.funct7 = 7'b0000000;
    	r_item.funct3 = 3'b000;
        //r_item.rs1 = 5'b00000;
        //r_item.rs2 = 5'b00000;
      r_item.instr = {r_item.imm, r_item.rs1, r_item.funct3, r_item.rd, r_item.opcode};
      	`uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
      	r_item.print();
      	finish_item(r_item);
    end
    for (int i = 0; i < num; i ++) begin
    	start_item(r_item);
      	r_item.randomize();
    	r_item.opcode = 7'b0110011;  // opcode for R type
    	r_item.funct7 = 7'b0000001;
    	r_item.funct3 = 3'b000;
        //r_item.rs1 = 5'b00000;
        //r_item.rs2 = 5'b00000;
      r_item.instr = {r_item.funct7, r_item.rs1, r_item.rs2, r_item.funct3, r_item.rd, r_item.opcode};
      	`uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
      	r_item.print();
      	finish_item(r_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
  
endclass


// scoreboard

class riscv_scoreboard_muldiv extends riscv_scoreboard;
   `uvm_component_utils (riscv_scoreboard_muldiv)

    function new (string name, uvm_component parent=null);
		super.new (name, parent);
      	// valores iniciales de los registros del reference model
      	init_reg_val = 32'b1;
 	 	ref_model = new(init_reg_val);
	endfunction
  
	virtual function void write_drv (riscv_item item);
      ref_model.get_sti(item.instr);
      `uvm_info ("drv", $sformatf("Data received = 0x%0h", item.instr), UVM_MEDIUM)
      //verfy(intf.reg_file[intf.rs1_w], ref_model.reg_file[ref_model.rs1], "rs1");
      //verfy(intf.reg_file[intf.rs2_w], ref_model.reg_file[ref_model.rs2], "rs2");
      //ref_model.push_back(item.instr);
      //verfy(intf.imm12_r, ref_model.immediate, "imm");
	endfunction
  	
  
    virtual function void write_mon (riscv_item item);
      `uvm_info ("mon", $sformatf("Comparing cpu's values with reference model's one"), UVM_MEDIUM)
      verfy(intf.reg_file[intf.rd_q], ref_model.reg_file[ref_model.rd], "rd");
    endfunction

  function void verfy(logic [31:0] cpu, ref_val, string name);
    if (cpu==ref_val) begin
      `uvm_info(" * PASS * ", $sformatf("cpu.%s: %0h  ::  ref.%s: %0h", name, cpu, name, ref_val), UVM_MEDIUM);
    end
    else begin
      `uvm_error(" * ERROR * ", $sformatf("cpu.%s: %0h  ::  ref.%s: %0h", name, cpu, name, ref_val));
    end
  endfunction
  
endclass

// monitor del agente activo

class riscv_monitor_wr_muldiv extends riscv_monitor_wr;
  `uvm_component_utils (riscv_monitor_wr_muldiv)
  
   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual task run_phase (uvm_phase phase);
      riscv_item  data_obj = riscv_item::type_id::create ("data_obj", this);
      forever begin
        @ (negedge intf.mem_i_valid_w && intf.rst==0);  
          data_obj.instr = intf.mem_i_inst_w;
          mon_analysis_port.write (data_obj);
      end
   endtask

endclass


// monitor del agente pasivo

class riscv_monitor_rd_muldiv extends riscv_monitor_rd;
  `uvm_component_utils (riscv_monitor_rd_muldiv)
   int ready = 0;
   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual task run_phase (uvm_phase phase);
      riscv_item  data_obj = riscv_item::type_id::create ("data_obj", this);
     
      forever begin
        @ (negedge intf.rd_writeen_w && intf.rst==0);  
        if(ready) begin
          ready=0;
          data_obj.instr = intf.mem_i_inst_w;
          mon_analysis_port.write (data_obj);
        end
        ready++;
      end
   endtask

endclass