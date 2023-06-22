class test_basic4 extends test_basic;

  `uvm_component_utils(test_basic4)


  function new (string name="test_basic4", uvm_component parent=null);
    super.new (name, parent);
    t = 300;
    init_reg_val = 32'b1;
  endfunction : new


  virtual function void build_phase(uvm_phase phase); 
    uvm_factory factory = uvm_factory::get();                           // Get handle to the singleton factory instance
    super.build_phase(phase);
    factory.set_type_override_by_name("gen_item_seq", "gen_item_seq4"); // Factory to override 'base_agent' by 'child_agent' by name
    factory.set_type_override_by_name("riscv_scoreboard", "riscv_scoreboard4");
    factory.print();
  endfunction
endclass


class gen_item_seq4 extends gen_item_seq;
  `uvm_object_utils(gen_item_seq4)


  function new(string name="gen_item_seq2");
    super.new(name);
  endfunction

  rand int num;			  // Config total number of items to be sent
  rand int operation;	// Config operation to be sent
  constraint c1 { num inside {[8:15]}; }


virtual task body();
    riscv_item r_item = riscv_item::type_id::create("r_item");

    for (int i = 0; i < num; i ++) begin
      start_item(r_item);
      r_item.randomize();

      operation = $random() % 10; // Randomize operation

      case(operation)
        0: // RV_ALU_SHIFTL
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0000000;
          r_item.funct3 = 3'b001;
        end
        1: // RV_ALU_SHIFTR
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0000000;
          r_item.funct3 = 3'b101;
        end
        2: // RV_ALU_SHIFTR_ARITH
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0100000;
          r_item.funct3 = 3'b101;
        end
        3: // RV_ALU_ADD
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0000000;
          r_item.funct3 = 3'b000;
        end
        4: // RV_ALU_SUB
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0100000;
          r_item.funct3 = 3'b000;
        end
        5: // RV_ALU_AND
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0000000;
          r_item.funct3 = 3'b111;
        end
        6: // RV_ALU_OR
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0000000;
          r_item.funct3 = 3'b110;
        end
        7: // RV_ALU_XOR
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0000000;
          r_item.funct3 = 3'b100;
        end
        8: // RV_ALU_LESS_THAN
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0000000;
          r_item.funct3 = 3'b011;
        end
        9: // RV_ALU_LESS_THAN_SIGNED
        begin
          r_item.opcode = 7'b0110011;
          r_item.funct7 = 7'b0000000;
          r_item.funct3 = 3'b010;
        end
      endcase

      r_item.instr = {r_item.funct7, r_item.rs2, r_item.rs1, r_item.funct3, r_item.rd, r_item.opcode};
      `uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
      r_item.print();
      finish_item(r_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
  
endclass


class riscv_scoreboard4 extends riscv_scoreboard;
  `uvm_component_utils (riscv_scoreboard4)


  function new (string name, uvm_component parent=null);
    super.new (name, parent);
    init_reg_val = 32'b1;
    ref_model = new(init_reg_val);
  endfunction


  virtual function void write_mon (riscv_item item);
    `uvm_info ("mon", $sformatf("Data received = 0x%0h", item.instr), UVM_MEDIUM)
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
