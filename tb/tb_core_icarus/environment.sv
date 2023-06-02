class riscv_env extends uvm_env;

  `uvm_component_utils(riscv_env)

  function new (string name = "riscv_env", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  virtual intf1 riscv_intf;
  riscv_agent_active riscv_ag_active;
  riscv_agent_passive riscv_ag_passive;
  riscv_scoreboard riscv_sb;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(uvm_config_db #(virtual intf1)::get(this, "", "VIRTUAL_INTERFACE", riscv_intf) == 0) begin
      `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    
    riscv_ag_active = riscv_agent_active::type_id::create ("riscv_ag_active", this);
    riscv_ag_passive = riscv_agent_passive::type_id::create ("riscv_ag_passive", this);
    riscv_sb = riscv_scoreboard::type_id::create ("riscv_sb", this); 
    
    //uvm_config_db #(virtual fifo_intf)::set (null, "uvm_test_top.*", "VIRTUAL_INTERFACE", intf);    
      
    uvm_report_info(get_full_name(),"End_of_build_phase", UVM_LOW);
    print();

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    riscv_ag_active.riscv_mntr_wr.mon_analysis_port.connect(riscv_sb.riscv_drv);
    riscv_ag_passive.riscv_mntr_rd.mon_analysis_port.connect(riscv_sb.riscv_mon);
  endfunction

endclass