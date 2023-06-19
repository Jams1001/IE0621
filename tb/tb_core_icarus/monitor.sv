class riscv_monitor extends uvm_monitor;
  `uvm_component_utils (riscv_monitor)

   virtual interface_1 intf;
   bit     enable_check = 0; //Turned OFF by default
   bit     enable_coverage = 0; //Turned OFF by default
  
   uvm_analysis_port #(riscv_item)   mon_analysis_port;

   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      // Create an instance of the analysis port
      mon_analysis_port = new ("mon_analysis_port", this);

      // Get virtual interface handle from the configuration DB
      if(uvm_config_db #(virtual interface_1)::get(this, "", "VIRTUAL_INTERFACE", intf) == 0) begin
       `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
      end
   endfunction

   virtual task run_phase (uvm_phase phase);
      super.run_phase(phase);
   endtask

   virtual function void check_protocol ();
      // Function to check basic protocol specs
   endfunction

endclass

class riscv_monitor_wr extends riscv_monitor;
  `uvm_component_utils (riscv_monitor_wr)

   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
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

class riscv_monitor_rd extends riscv_monitor;
  `uvm_component_utils (riscv_monitor_rd)

   function new (string name, uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
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



