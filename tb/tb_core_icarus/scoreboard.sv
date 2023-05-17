class scoreboard;
  logic [999:0][4:0] result_ref_rd;
  logic [999:0][4:0] result_ref_rs1;
  logic [999:0][4:0] result_ref_rs2;
  integer i = 0;
  function void get_result(logic [4:0] rs2, rs1, rd);
    result_ref_rs2[i] = rs2;
    result_ref_rs1[i] = rs1;
    result_ref_rd[i] = rd;
    $display(rd);
    i=i+1;
  endfunction
endclass

