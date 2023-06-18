interface interface_1(input logic clk, input logic rst);
    
  //tb_top.u_dut.state_q  
    
  // riscv_core 
  // Registers  
  //logic  [STATE_W-1:0] state_q;
  //logic  [PC_W-1:0]    pc_q;
  logic  [4:0]         rd_q;
  logic                rd_wr_en_q;
  logic  [31:0]        alu_a_q;
  logic  [31:0]        alu_b_q;
  logic  [3:0]         alu_func_q;
  logic  [31:0]        csr_data_w;
  logic                invalid_inst_r;
  logic  [4:0]         rd_w;
  logic  [4:0]         rs1_w;
  logic  [4:0]         rs2_w;
  logic  [31:0]        rs1_val_w;
  logic  [31:0]        rs2_val_w;
  logic  [31:0]        opcode_w;
  logic                opcode_valid_w;
  logic                opcode_fetch_w;
  logic                exception_w;
  logic  [5:0]         exception_type_w;
  logic  [31:0]        exception_target_w;
  logic  [31:0]        csr_mepc_w;
  logic  [31:0]        load_result_r;
  logic                rd_writeen_w;
  logic  [31:0]        rd_val_w;
  logic                mem_misaligned_w;
  //logic  [ADDR_W-1:0]  mem_addr_q;
  logic  [31:0]        mem_data_q;
  logic  [3:0]         mem_wr_q;
  logic                mem_rd_q;
  logic  [1:0]         load_offset_q;
  logic                load_signed_q;
  logic                load_byte_q;
  logic                load_half_q;
  logic                enable_w;
  logic  [31:0]        muldiv_result_w;
  logic                muldiv_ready_w;
  logic                muldiv_inst_w;
    
  // Register file
  logic  [31:0]        reg_file[0:31];
  logic  [31:0]        rs1_val_gpr_w;
  logic  [31:0]        rs2_val_gpr_w;
  logic  [31:0]        rs1_val_gpr_q;
  logic  [31:0]        rs2_val_gpr_q;


  logic [31:0] x0_zero_w;
  logic [31:0] x1_ra_w;   
  logic [31:0] x2_sp_w;   
  logic [31:0] x3_gp_w;   
  logic [31:0] x4_tp_w;   
  logic [31:0] x5_t0_w;   
  logic [31:0] x6_t1_w;   
  logic [31:0] x7_t2_w;   
  logic [31:0] x8_s0_w;   
  logic [31:0] x9_s1_w;   
  logic [31:0] x10_a0_w; 
  logic [31:0] x11_a1_w; 
  logic [31:0] x12_a2_w; 
  logic [31:0] x13_a3_w; 
  logic [31:0] x14_a4_w; 
  logic [31:0] x15_a5_w; 
  logic [31:0] x16_a6_w; 
  logic [31:0] x17_a7_w; 
  logic [31:0] x18_s2_w; 
  logic [31:0] x19_s3_w; 
  logic [31:0] x20_s4_w; 
  logic [31:0] x21_s5_w; 
  logic [31:0] x22_s6_w; 
  logic [31:0] x23_s7_w; 
  logic [31:0] x24_s8_w; 
  logic [31:0] x25_s9_w; 
  logic [31:0] x26_s10_w;
  logic [31:0] x27_s11_w;
  logic [31:0] x28_t3_w; 
  logic [31:0] x29_t4_w; 
  logic [31:0] x30_t5_w; 
  logic [31:0] x31_t6_w; 

  logic type_rvc_w;

  logic type_load_w  ;
  logic type_opimm_w ;
  logic type_auipc_w ;
  logic type_store_w ;
  logic type_op_w    ;
  logic type_lui_w   ;
  logic type_branch_w;
  logic type_jalr_w  ;
  logic type_jal_w   ;
  logic type_system_w;
  logic type_miscm_w ;

// Next State Logic
  //logic [STATE_W-1:0] next_state_r;

// Instruction Decode
  logic [31:0] opcode_q;
  logic [2:0] func3_w; 
  logic [6:0] func7_w; 

  logic type_alu_op_w;;

  logic inst_lb_w ;
  logic inst_lh_w ;
  logic inst_lbu_w;
  logic inst_lhu_w;

  logic inst_ecall_w ;
  logic inst_ebreak_w;
  logic inst_mret_w  ;

  logic inst_csr_w;

  logic mul_inst_w;
  logic div_inst_w;
  logic inst_mul_w   ;
  logic inst_mulh_w  ;
  logic inst_mulhsu_w;
  logic inst_mulhu_w ;
  logic inst_div_w   ;
  logic inst_divu_w  ;
  logic inst_rem_w   ;
  logic inst_remu_w  ;
  logic inst_nop_w;  

  logic [31:0]  imm20_r;
  logic [31:0]  imm12_r;

// ALU inputs
  logic [3:0]  alu_func_r;

  logic [31:0] alu_input_a_r;
  logic [31:0] alu_input_b_r;
  logic        write_rd_r;

// Branches
  logic        branch_w;
  logic [31:0] branch_target_w;
  logic [31:0] pc_ext_w;

  logic [31:0] boot_vector_w;

// Execute: Memory operations
  logic  mem_rd_w;
  logic [3:0] mem_wr_w;
  logic [31:0] mem_addr_w;
  logic [31:0] mem_data_w;

// Hooks for debug
  logic        v_dbg_valid_q;
  logic [31:0] v_dbg_pc_q;




  //uriscv_alu
  // Registers
  logic [31:0]      result_r;
  logic [31:16]     shift_right_fill_r;
  logic [31:0]      shift_right_1_r;
  logic [31:0]      shift_right_2_r;
  logic [31:0]      shift_right_4_r;
  logic [31:0]      shift_right_8_r;
  logic [31:0]      shift_left_1_r;
  logic [31:0]      shift_left_2_r;
  logic [31:0]      shift_left_4_r;
  logic [31:0]      shift_left_8_r;

  logic [31:0]     sub_res_w;





  // uriscv_branch
  // Branch Decode
  logic type_branch_w;
  logic type_jalr_w  ;
  logic type_jal_w   ;
  logic [2:0] func3_w  ; 
  logic [6:0] func7_w  ; 
  logic branch_beq_w ;
  logic branch_bne_w ;
  logic branch_blt_w ;
  logic branch_bge_w ;
  logic branch_bltu_w;
  logic branch_bgeu_w;

  logic         branch_r;
  logic [31:0]  branch_target_r;
  logic [31:0]  imm12_r;
  logic [31:0]  bimm_r;
  logic [31:0]  jimm20_r;




  // uriscv_csr
  // Includes

  logic take_interrupt_w;
  logic exception_w;

  // Instruction Decode
  logic [2:0] func3_w;
  logic [4:0] rs1_w;
  logic [4:0] rs2_w;
  logic [4:0] rd_w;
  logic type_system_w;
  logic type_store_w;

  logic inst_csr_w;
  logic inst_csrrw_w ;
  logic inst_csrrs_w ;
  logic inst_csrrc_w ;
  logic inst_csrrwi_w;
  logic inst_csrrsi_w;
  logic inst_csrrci_w;

  logic inst_ecall_w ;
  logic inst_ebreak_w;
  logic inst_mret_w  ;

  logic [11:0] csr_addr_w ;
  logic [31:0] csr_data_w;
  logic        csr_set_w;
  logic        csr_clr_w;


  // Execute: CSR Access
  logic [31:0] csr_mepc_q;
  logic [31:0] csr_mepc_r;
  logic [31:0] csr_mcause_q;
  logic [31:0] csr_mcause_r;
  logic [31:0] csr_sr_q;
  logic [31:0] csr_sr_r;
  logic [31:0] csr_mcycle_q;
  logic [31:0] csr_mcycle_r;
  logic [31:0] csr_mtimecmp_q;
  logic [31:0] csr_mtimecmp_r;
  logic [31:0] csr_mscratch_q;
  logic [31:0] csr_mscratch_r;
  logic [31:0] csr_mip_q;
  logic [31:0] csr_mip_r;
  logic [31:0] csr_mie_q;
  logic [31:0] csr_mie_r;
  logic [31:0] csr_mtvec_q;
  logic [31:0] csr_mtvec_r;
  logic [31:0] csr_mtval_q;
  logic [31:0] csr_mtval_r;


  // CSR Read Data MUX
  logic [31:0] csr_data_r;


  // Debug - exception type (checker use only)
  logic [5:0] v_etype_r;


  //uriscv_lsu
  // Instruction Decode
  logic type_load_w   ;
  logic type_store_w  ;
  logic [2:0] func3_w;
  logic inst_lb_w  ;
  logic inst_lh_w  ;
  logic inst_lw_w  ;
  logic inst_lbu_w ;
  logic inst_lhu_w ;
  logic inst_sb_w  ;
  logic inst_sh_w  ;
  logic inst_sw_w  ;

  // Decode LSU operation
  logic [31:0]  imm12_r;
  logic [31:0]  storeimm_r;
  logic [31:0]  mem_addr_r;
  logic [31:0]  mem_data_r;
  logic [3:0]   mem_wr_r;
  logic         mem_rd_r;
  logic         mem_misaligned_r;


  //uriscv_muldiv
  // Multiplier
  logic [32:0]   mul_operand_a_q;
  logic [32:0]   mul_operand_b_q;
  logic          mulhi_sel_q;

  logic [64:0]  mult_result_w;
  logic  [32:0]  operand_b_r;
  logic  [32:0]  operand_a_r;
  logic  [31:0]  mul_result_r;
  logic mult_inst_w;

  logic mul_busy_q;

  // Divider
  logic div_rem_inst_w;
  logic signed_operation_w;
  logic div_operation_w;

  logic [31:0] dividend_q;
  logic [62:0] divisor_q;
  logic [31:0] quotient_q;
  logic [31:0] q_mask_q;
  logic        div_inst_q;
  logic        div_busy_q;
  logic        invert_res_q;

  logic div_start_w;
  logic div_complete_w;
  logic [31:0] div_result_r;  


  // Shared logic

  logic  [31:0]  result_q;
  logic          ready_q;


    
    
endinterface : interface_1