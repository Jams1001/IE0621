`uvm_analysis_imp_decl( _drv )
`uvm_analysis_imp_decl( _mon ) 

class riscv_scoreboard extends uvm_scoreboard;
    `uvm_component_utils (riscv_scoreboard)

    function new (string name, uvm_component parent=null);
		super.new (name, parent);
	endfunction

    uvm_analysis_imp_drv #(riscv_item, riscv_scoreboard) riscv_drv;
    uvm_analysis_imp_mon #(riscv_item, riscv_scoreboard) riscv_mon;

    logic [7:0] ref_model [$];  
  
	function void build_phase (uvm_phase phase);
      riscv_drv = new ("riscv_drv", this);
      riscv_mon = new ("riscv_mon", this);
	endfunction

    virtual function void write_drv (riscv_item item);
      `uvm_info ("drv", $sformatf("Data received = 0x%0h", item.data), UVM_MEDIUM)
      ref_model.push_back(item.data);
	endfunction
  
    virtual function void write_mon (riscv_item item);
      `uvm_info ("mon", $sformatf("Data received = 0x%0h", item.data), UVM_MEDIUM)
      if (item.data !== ref_model.pop_front()) begin
        `uvm_error("SB error", "Data mismatch");
      end
      else begin
        `uvm_info("SB PASS", $sformatf("Data received = 0x%0h", item.data), UVM_MEDIUM);
      end
    endfunction

	virtual task run_phase (uvm_phase phase);
		
	endtask

	virtual function void check_phase (uvm_phase phase);
      if(ref_model.size() > 0)
        `uvm_warning("SB Warn", $sformatf("riscv not empty at check phase. riscv still has 0x%0h data items allocated", ref_model.size()));
	endfunction
endclass