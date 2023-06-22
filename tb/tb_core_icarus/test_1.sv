class test_basic extends uvm_test;

  `uvm_component_utils(test_basic)


  function new (string name="test_basic", uvm_component parent=null);
    super.new (name, parent);
  endfunction : new


  virtual interface_1 	intf;
  riscv_env 			env;  
  int 					t = 160;              // Tiempo de simulacion luego del reset
  int 					init_reg_val = 32'b1; // Valores iniciales de los registros del cpu
  gen_item_seq 			seq;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(uvm_config_db #(virtual interface_1)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
        `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
    end
    env  = riscv_env::type_id::create ("env", this);
    uvm_config_db #(virtual interface_1)::set (null, "uvm_test_top.*", "VIRTUAL_INTERFACE", intf);
  endfunction


  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW);
    print();
  endfunction : end_of_elaboration_phase
  

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection (this);
    seq = gen_item_seq::type_id::create("seq");
    seq.randomize();
    seq.start(env.riscv_ag_active.riscv_seqr);
    uvm_report_info(get_full_name(),"Init Start", UVM_LOW);
    env.riscv_ag_active.riscv_drv.riscv_reset();
    uvm_report_info(get_full_name(),"Init Done", UVM_LOW);
    top_hdl.u_dut.reg_file = '{default: init_reg_val};  //Inicializar registros en 1
    top_hdl.u_dut.reg_file[0] = 32'b0;
    #t;                                                 // (Cantidad de instrucciones + 1) por 20 (duracion de cada instrucción add)
    phase.drop_objection (this);
  endtask
endclass
