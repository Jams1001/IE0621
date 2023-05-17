class stimulus;
  rand logic [6:0] funct7;
  rand logic [4:0] rs2;
  rand logic [4:0] rs1;
  rand logic [2:0] funct3;
  rand logic [4:0] rd;
  rand logic [6:0] opcode;
  rand logic [11:0] imm;
  logic [31:0] instr;
  logic [72:0][7:0] init_instr;

  constraint legal_values {
    rs1 inside {[0:31]};
    rs2 inside {[0:31]};
    rd  inside {[0:31]};
    imm inside {[0:2047]};
  }

  function logic [3:0][7:0] assemble_R_type_instruction();
    opcode = 7'b0110011;  // opcode for R type
    if ($random()%2 == 0) begin
      funct7 = 7'b0000000; // add
      funct3 = 3'b000;
    end else begin
      funct7 = 7'b0100000; // sub
      funct3 = 3'b000;
    end
    rs1 = $random % 32;
    rs2 = $random % 32;
    rd = $random % 32;
    instr = {funct7, rs2, rs1, funct3, rd, opcode};
    return {instr[31:24], instr[23:16], instr[15:8], instr[7:0]};
  endfunction

  function logic [3:0][7:0] assemble_I_type_instruction();
    opcode = 7'b0010011;  // opcode for I type
    if ($random()%2 == 0) begin
      funct3 = 3'b000; // addi
      imm = $random % 2048;
      rs1 = $random % 32;
      rd = $random % 32;
    end else begin
      opcode = 7'b0000011;  // opcode for load type
      funct3 = 3'b010; // lw
      imm = $random % 2048;
      rs1 = $random % 32;
      rd = $random % 32;
    end
    instr = {imm, rs1, funct3, rd, opcode};
    return {instr[31:24], instr[23:16], instr[15:8], instr[7:0]};
  endfunction
  
  function logic [72:0][7:0] initialize();
    init_instr[0] = 8'b01101111;
    init_instr[1] = 8'b00000000;
    init_instr[2] = 8'b00000000;
    init_instr[3] = 8'b00100110;
    
    init_instr[4] = 8'b00000000;
    init_instr[5] = 8'b00000000;
    init_instr[6] = 8'b00000000;
    init_instr[7] = 8'b00000000;
    
    init_instr[8] = 8'b00000000;
    init_instr[9] = 8'b00000000;
    init_instr[10] = 8'b00000000;
    init_instr[11] = 8'b00000000;
    
    init_instr[12] = 8'b00000000;
    init_instr[13] = 8'b00000000;
    init_instr[14] = 8'b00000000;
    init_instr[15] = 8'b00000000;
    
    init_instr[16] = 8'b01101111;
    init_instr[17] = 8'b00000000;
    init_instr[18] = 8'b01000000;
    init_instr[19] = 8'b00010001;
    
    for (int i = 20; i < 73; i = i + 4) begin
      init_instr[i]   = 8'b00000000;
      init_instr[i+1] = 8'b00000000;
      init_instr[i+2] = 8'b00000000;
      init_instr[i+3] = 8'b00000000;
    end
    return init_instr;
  endfunction

  
endclass