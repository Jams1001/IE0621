`uvm_analysis_imp_decl( _drv )
`uvm_analysis_imp_decl( _mon ) 

class riscv_scoreboard extends uvm_scoreboard;
  `uvm_component_utils (riscv_scoreboard)

  virtual interface_1 intf;

  function new (string name, uvm_component parent=null);
    super.new (name, parent);
  endfunction

  uvm_analysis_imp_drv #(riscv_item, riscv_scoreboard) riscv_drv;
  uvm_analysis_imp_mon #(riscv_item, riscv_scoreboard) riscv_mon;

  int init_reg_val = 32'b1; // Logic [31:0] ref_model [$];  
  reference_model ref_model = new(init_reg_val);


  function void build_phase (uvm_phase phase);
    riscv_drv = new ("riscv_drv", this);
    riscv_mon = new ("riscv_mon", this);
    // Get virtual interface handle from the configuration DB
    if(uvm_config_db #(virtual interface_1)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
  endfunction


  virtual function void write_drv (riscv_item item);
    `uvm_info ("drv", $sformatf("Data received = 0x%0h", item.instr), UVM_MEDIUM)
    ref_model.get_sti(item.instr);
  endfunction
  

  virtual function void write_mon (riscv_item item);
    //`uvm_info ("mon", $sformatf("Data received = 0x%0h", item.instr), UVM_MEDIUM)
    `uvm_info ("mon", $sformatf("Comparing cpu's values with reference model's one"), UVM_MEDIUM)
    /*if (item.instr !== ref_model.pop_front()) begin
      `uvm_error("SB error", "Data mismatch");
    end
    else begin
      `uvm_info("SB PASS", $sformatf("Data received = 0x%0h", item.instr), UVM_MEDIUM);
    end*/
    verfy(intf.reg_file[intf.rd_q], ref_model.reg_file[ref_model.rd], "rd");
    endfunction


	virtual task run_phase (uvm_phase phase);
	endtask


	virtual function void check_phase (uvm_phase phase);
    //if(ref_model.size() > 0)
    //`uvm_warning("SB Warn", $sformatf("riscv not empty at check phase. riscv still has 0x%0h data items allocated", ref_model.size()));
	endfunction


   // Function to not repeat code
  function void verfy(logic [6:0] cpu, ref_val, string name);
    if (cpu==ref_val) begin
      `uvm_info(" * PASS * ", $sformatf("cpu.%s: %0h  ::  ref.%s: %0h\n", name, cpu, name, ref_val), UVM_MEDIUM);
    end
    else begin
      `uvm_error(" * ERROR * ", $sformatf("cpu.%s: %0h  ::  ref.%s: %0h\n", name, cpu, name, ref_val));
    end
  endfunction
endclass