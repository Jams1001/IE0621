class stimulus;
  rand logic [6:0] funct7;
  rand logic [4:0] rs2;
  rand logic [4:0] rs1;
  rand logic [2:0] funct3;
  rand logic [4:0] rd;
  rand logic [6:0] opcode;

  function new();
    // Inicializa los valores de funct7 y opcode
    opcode = 7'b0110011;  // opcode is always 0110011
    // Suma
    if($random()%4 == 0) begin
      funct7 = 7'b0000000;
      rs1 = $random % 32;
      rs2 = $random % 32;
    end
    // Resta
    else if($random()%4 == 1) begin
      funct7 = 7'b0100000;
      rs1 = $random % 32;
      rs2 = $random % 32;
    end
    // Suma inmediata
    else if($random()%4 == 2) begin
      funct7 = 7'b0000000;
      rs1 = $random % 32;
      rs2 = rs1;
    end
    // Resta inmediata // no tiene sentido pero ajá
    else begin
      funct7 = 7'b0100000;
      rs1 = $random % 32;
      rs2 = rs1;
    end
    funct3 = 3'b000;
    rd = $random % 32;
  endfunction

  constraint legal_values {
    // Los valores de rs1, rs2 y rd deben estar entre 0 y 31
    rs1 inside {[0:31]};
    rs2 inside {[0:31]};
    rd  inside {[0:31]};
  }

  function logic [3:0][7:0] assemble_instruction();
    logic [31:0] instr;
    instr = {funct7, rs2, rs1, funct3, rd, opcode};
    return {instr[31:24], instr[23:16], instr[15:8], instr[7:0]};
  endfunction

endclass
