class scoreboard;
  logic [999:0][4:0] result_ref_rd;
  logic [999:0][4:0] result_ref_rs1;
  logic [999:0][4:0] result_ref_rs2;
  logic [999:0][6:0] result_ref_opcode;
  logic [999:0][2:0] result_ref_func_3;
  logic [999:0][6:0] result_ref_func_7;
  integer i = 0;
  function void get_result(logic [4:0] rs2, rs1, rd, [6:0] opcode, [2:0] func_3, [6:0] func_7);
    result_ref_rs2[i] = rs2;
    result_ref_rs1[i] = rs1;
    result_ref_rd[i] = rd;
    result_ref_opcode[i] = opcode;
    result_ref_func_3[i] = func_3;
    result_ref_func_7[i] = func_7;
    i=i+1;
  endfunction
endclass

