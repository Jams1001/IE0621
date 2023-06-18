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
        @ (negedge intf.clk);  
        if( intf.wr_en == 1) begin
          data_obj.data = intf.data_in;
          mon_analysis_port.write (data_obj);
        end
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
        @ (negedge intf.clk);  
        if( intf.rd_en == 1) begin
          data_obj.data = intf.data_out;
          mon_analysis_port.write (data_obj);
        end
      end
   endtask

endclass

class monitor;
  // monitor blocks
  scoreboard sb;
  // monitor interface
  virtual interface_1 intf;

  // monitor variables
  int err_count;
  
  // monitor constructor
  function new(virtual interface_1 intf, scoreboard sb);
    this.intf = intf;
    this.sb = sb;
  endfunction
          
  // function to not repeat code
  function void verfy(logic [6:0] cpu, ref_val, string name);
    if (cpu==ref_val) begin
      $display(" * PASS * cpu.%s: %b  ::  ref.%s: %b\n", name, cpu, name, ref_val);
    end
    else begin
      $display(" * ERROR * cpu.%s: %b  ::  ref.%s: %b\n", name, cpu, name, ref_val);
      err_count++;
    end
  endfunction
  
  task check_decode();
    err_count = 0;
    forever
      begin
        // check whenever this happends
        @ (negedge intf.mem_i_valid_w && intf.rst==0)
        // Decode Checking
        $display("======================");
        $display("Time: %d", $time);
        $display("sb: %d", sb.i);
        $display("errors: %d", err_count);
        $display("cpu.mem_i_inst_w: %b\n",intf.mem_i_inst_w);
        $display("cpu.mem_d_data_rd_w: %b\n",intf.mem_d_data_rd_w);
        // Checking rs1, rs2, func7, func3, and rd
        // rs1
        verfy(intf.rs1_w, sb.result_ref_rs1[sb.i-1], "rs1");
        // rs2
        verfy(intf.rs2_w, sb.result_ref_rs2[sb.i-1], "rs2");
        // rd
        verfy(intf.rd_w, sb.result_ref_rd[sb.i-1], "rd");
        // func7
        verfy(intf.func7_w, sb.result_ref_func_7[sb.i-1], "func7");
        // func3
        verfy(intf.func3_w, sb.result_ref_func_3[sb.i-1], "func3");
        $display("======================");
      end
  endtask
  
  task check_initial();
    forever
      begin
        @ (negedge intf.rd_writeen_w)
        $display("Time: %d", $time);
        if (intf.reg_file[intf.rd_q]==0)
          $display(" *PASS* Register value : %b register id: %d\n", intf.reg_file[intf.rd_q], intf.rd_q); 
        else
          $display(" *FAIL* Register value : %b register id: %d\n", intf.reg_file[intf.rd_q], intf.rd_q); 
      end
  endtask
 
  
endclass

