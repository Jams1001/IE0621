class test_basic2 extends test_basic;

  `uvm_component_utils(test_basic2)


  function new (string name="test_basic2", uvm_component parent=null);
    super.new (name, parent);
    t = 300;              // Tiempo de simulacion luego del reset
    init_reg_val = 32'b0; // Valores iniciales de los registros del cpu
  endfunction : new


  virtual function void build_phase(uvm_phase phase);
    // Get handle to the singleton factory instance
    uvm_factory factory = uvm_factory::get();
    super.build_phase(phase);
    // Factory to override 'base_agent' by 'child_agent' by name
    factory.set_type_override_by_name("gen_item_seq", "gen_item_seq2");
    factory.set_type_override_by_name("riscv_scoreboard", "riscv_scoreboard2");
    factory.print();
  endfunction
endclass


class gen_item_seq2 extends gen_item_seq;
  `uvm_object_utils(gen_item_seq2)


  function new(string name="gen_item_seq2");
    super.new(name);
  endfunction

  rand int num; // Config total number of items to be sent
  constraint c1 { num inside {[8:15]}; }


  virtual task body();
    riscv_item r_item = riscv_item::type_id::create("r_item");
    for (int i = 0; i < num; i ++) begin
      start_item(r_item);
      r_item.randomize();
      r_item.opcode = 7'b0010011;
      r_item.funct7 = 7'b0000000;
      r_item.funct3 = 3'b000;
      r_item.instr = {r_item.imm, r_item.rs1, r_item.funct3, r_item.rs2, r_item.opcode};
      `uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
      r_item.print();
      finish_item(r_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass


class riscv_scoreboard2 extends riscv_scoreboard;
  `uvm_component_utils (riscv_scoreboard2)

  function new (string name, uvm_component parent=null);
    super.new (name, parent);
    // valores iniciales de los registros del reference model
    init_reg_val = 32'b0;
	  ref_model = new(init_reg_val);
  endfunction


  virtual function void write_mon (riscv_item item);
    `uvm_info ("mon", $sformatf("Comparing cpu's values with reference model's one"), UVM_MEDIUM)
    verfy(intf.reg_file[intf.rd_q], ref_model.reg_file[ref_model.rd], "rd");
  endfunction


  function void verfy(logic [11:0] cpu, ref_val, string name);
    if (cpu==ref_val) begin
      `uvm_info(" * PASS * ", $sformatf("cpu.%s: %0h  ::  ref.%s: %0h\n", name, cpu, name, ref_val), UVM_MEDIUM);
    end
    else begin
      `uvm_error(" * ERROR * ", $sformatf("cpu.%s: %0h  ::  ref.%s: %0h\n", name, cpu, name, ref_val));
    end
  endfunction
  
endclass
