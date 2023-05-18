class reference_model;
	
  	scoreboard sb;
  
	//virtual stimulus sti; //Añadir hasta que stimulo este completo
    logic [31:0]sti;
    logic [6:0]func_7;
    logic [4:0]rs2;
    logic [4:0]rs1;
    logic [2:0]func_3;
    logic [4:0]rd;
    logic [6:0]opcode;
    logic [11:0]immediate;
    logic [6:0]imm_11_5;
    logic [4:0]imm_4_0;
    logic [31:0] reg_file[0:31];

  function new(scoreboard sb);
      $display("-----------------iniciando reference model-------------------------");
      this.sb = sb;
      func_7 = 0;
      rs2 = 0;
      rs1 = 1;
      func_3 = 0;
      rd = 0;
      opcode = 0;
      immediate = 0;
      imm_11_5 = 0;
      imm_4_0 = 0;
      reg_file[0:31] = '{default: 32'b1};
    endfunction


  function void get_sti(logic [31:0]sti);
    	this.sti = sti;
    	this.decoder();
    endfunction
  
  function void decoder();
	//Extract the opcode to determinate the type of ins
    opcode = sti[6:0]; 
    $display("%b",opcode);
	
    case(opcode)
//Instruction R	
		7'b0110011: begin
      		func_7 = sti[31:25];
      		rs2 = sti[24:20];
      		rs1 = sti[19:15];
      		func_3 = sti[14:12];
      		rd = sti[11:7];

    		//$display("El valor en x%d es %b : ", rs1, reg_file[rs1]);
    		//$display("El valor en x%d es %b : ", rs2, reg_file[rs2]);

          if(func_3 == 3'b000 && func_7 == 7'b0) begin
            add();
          end else if(func_3 == 3'b000 & func_7 == 7'b0100000) begin
            sub();
          end
        end
//Instruction I
		7'b0000011, 7'b0010011, 7'b0011011, 7'b1100111: begin
          immediate = sti[31:20];
          rs1 = sti[19:15];
          func_3 = sti[14:12];
          rd = sti[11:7];
        end
//Instruction S
		7'b0100011: begin 
          imm_11_5 = sti[31:25];
          rs2 = sti[24:20];
          rs1 = sti[19:15];
          func_3 = sti[14:12];
          imm_4_0 = sti[11:7];
        end
    endcase
    
    //decoder = {reg_file[rd], reg_file[rs1], reg_file[rs2]};
    sb.get_result(rs2, rs1, rd, opcode, func_3, func_7);
    $display("%b   %b    %b",rd, rs1, rs2);
    endfunction

  function void add();
    //$display("Instruccion R: ADD");
    reg_file[rd] = reg_file[rs1] + reg_file[rs2];
    //$display("La suma guardada en x%d da %b : ", rd, reg_file[rd]);
  endfunction: add

  function void sub();
    //$display("Instruccion R: SUB");
    reg_file[rd] = reg_file[rs1] - reg_file[rs1];
    //$display("La resta guardada en x%d da %b : ", rd, reg_file[rd]);
  endfunction: sub

endclass: reference_model