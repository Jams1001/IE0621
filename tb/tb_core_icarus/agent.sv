class riscv_agent_active extends uvm_agent;
  `uvm_component_utils(riscv_agent_active)
  function new(string name="riscv_agent_active", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual interface_1 intf;
  riscv_driver riscv_drv;
  uvm_sequencer #(riscv_item)	riscv_seqr;

  riscv_monitor_wr riscv_mntr_wr;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(uvm_config_db #(virtual interface_1)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    
    riscv_drv = riscv_driver::type_id::create ("riscv_drv", this); 
    
    riscv_seqr = uvm_sequencer#(riscv_item)::type_id::create("riscv_seqr", this);
    
    riscv_mntr_wr = riscv_monitor_wr::type_id::create ("riscv_mntr_wr", this);
    
    //uvm_config_db #(virtual interface_1)::set (null, "uvm_test_top.env.riscv_ag.riscv_drv", "VIRTUAL_INTERFACE", intf);    

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    riscv_drv.seq_item_port.connect(riscv_seqr.seq_item_export);
  endfunction

endclass

class riscv_agent_passive extends uvm_agent;
  `uvm_component_utils(riscv_agent_passive)
  function new(string name="riscv_agent_passive", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual interface_1 intf;
  
  riscv_monitor_rd riscv_mntr_rd;
  
 virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(uvm_config_db #(virtual interface_1)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    
    riscv_mntr_rd = riscv_monitor_rd::type_id::create ("riscv_mntr_rd", this);

    //uvm_config_db #(virtual interface_1)::set (null, "uvm_test_top.env.riscv_ag.riscv_drv", "VIRTUAL_INTERFACE", intf);    

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
endclass