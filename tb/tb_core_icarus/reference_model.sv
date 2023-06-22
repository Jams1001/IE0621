class reference_model;

  logic [31:0]  sti;
  logic [6:0]   func_7;
  logic [4:0]   rs2;
  logic [4:0]   rs1;
  logic [2:0]   func_3;
  logic [4:0]   rd;
  logic [6:0]   opcode;
  logic [11:0]  immediate;
  logic [6:0]   imm_11_5;
  logic [4:0]   imm_4_0;
  logic [31:0]  reg_file[0:31];
  logic [4:0]   shamt;


  function new(int init_reg_val);
    $display("-----------------Iniciando reference model-------------------------");
    //this.sb = sb;
    func_7          = 0;
    rs2             = 0;
    rs1             = 1;
    func_3          = 0;
    rd              = 0;
    opcode          = 0;
    immediate       = 0;
    imm_11_5        = 0;
    imm_4_0         = 0;
    reg_file[1:31]  = '{default: init_reg_val};
    reg_file[0]     = 32'b0;
    endfunction


  function void get_sti(logic [31:0]sti);
    	this.sti = sti;
    	this.decoder();
    endfunction


  function void decoder();
	  //Extract the opcode to determinate the type of ins
    opcode = sti[6:0]; 
    //$display("%b",opcode);
    case(opcode)
//Instruction R	
		7'b0110011: begin
      		func_7 = sti[31:25];
      		rs2 = sti[24:20];
      		rs1 = sti[19:15];
      		func_3 = sti[14:12];
      		rd = sti[11:7];
          $display("Instruccion tipo R");
    		  //$display("El valor en x%d es %b : ", rs1, reg_file[rs1]);
    		  //$display("El valor en x%d es %b : ", rs2, reg_file[rs2]);

          if(func_7 == 7'b0) begin
            case(func_3) 
              3'b000: begin
                $display("ADD");
              add(); end
              3'b001: begin
                $display("SLL");
              sll(); end
              3'b010: begin
                $display("SLT");
              slt(); end
              3'b011: begin
                $display("SLTU");
              sltu(); end
              3'b100: begin
                $display("XOR");
              x_or(); end
              3'b101: begin
                $display("SRL");
              srl(); end
              3'b110: begin
                $display("OR");
              o_r(); end
              3'b111: begin
                $display("AND");
                a_nd();end
            endcase
          end 
          else if(func_7 == 7'b0100000) begin
            case(func_3)
              3'b000: begin
                $display("SUB");
                sub(); end
              3'b101: begin
                $display("SRA");
                sra(); end
            endcase
          end 
          else if(func_7 == 7'b0000001) begin
            case(func_3)
              3'b000: begin
                $display("Multiplicacion");
                mult();
              end
              3'b100: div();
            endcase
          end
        end
//Instruction I
		7'b0000011, 7'b0010011, 7'b0011011, 7'b1100111: begin
          $display("Instucccion tipo I");
          immediate = sti[31:20];
          rs1 = sti[19:15];
          func_3 = sti[14:12];
          rd = sti[11:7];

          if (opcode == 7'b0010011) begin
            case(func_3)
              3'b000: begin 
                $display("ADDI");
                addi(); end
              3'b001: begin 
                logic imm = immediate[31:25];
                logic shamt = immediate[24:20];
                slli(); end
              3'b010: slti();
              3'b011: sltiu();
              3'b100: xori();
            endcase
          end else begin
            $display("Instruccion no encontrada");
        end 
    end
        
    
//Instruction S
		7'b0100011: begin 
          $display("Instucccion tipo S");
          imm_11_5 = sti[31:25];
          rs2 = sti[24:20];
          rs1 = sti[19:15];
          func_3 = sti[14:12];
          imm_4_0 = sti[11:7];
          
          if(func_3 == 3'b010) begin
            load();
          end else begin
            store();
        end
        end
    endcase
    
    //decoder = {reg_file[rd], reg_file[rs1], reg_file[rs2]};
    //sb.get_result(rs2, rs1, rd, opcode, func_3, func_7);
    //$display("%b   %b    %b", reg_file[rs1], reg_file[rs2], reg_file[rd]);
endfunction

    function void add();
    //$display("Instruccion R: ADD");
    reg_file[rd] = reg_file[rs1] + reg_file[rs2];
    //$display("La suma guardada en x%d da %b : ", rd, reg_file[rd]);
    endfunction: add
	
    function void sll();
        reg_file[rd] = reg_file[rs1] << reg_file[rs2];
    endfunction: sll

    function void slt();
        if(reg_file[rs1] < reg_file[rs2]) begin
            reg_file[rd] = 1;
        end else begin 
            reg_file[rd] = 0;
        end
    endfunction: slt
    function void sltu();
        logic unsigned urs1= reg_file[rs1];
        logic unsigned urs2= reg_file[rs2];

      if (urs1 < urs2) begin
          reg_file[rd] = 1;
        end else begin
          reg_file[rd] = 0;
        end
    endfunction: sltu

    function void x_or();
      reg_file[rd] = reg_file[rs1] ^ reg_file[rs2];
    endfunction: x_or

    function void srl();
      logic unsigned urs1= reg_file[rs1];
      logic unsigned urs2= reg_file[rs2];
      reg_file[rd] = urs1 >> urs2;
    endfunction: srl

    function void o_r();
      reg_file[rd] = reg_file[rs1] | reg_file[rs2];
    endfunction: o_r

    function void a_nd();
      reg_file[rd] = reg_file[rs1] & reg_file[rs2];
    endfunction: a_nd


    function void sub();
        //$display("Instruccion R: SUB");
        reg_file[rd] = reg_file[rs1] - reg_file[rs1];
        //$display("La resta guardada en x%d da %b : ", rd, reg_file[rd]);
    endfunction: sub

    function void sra(); 
      logic unsigned urs2= reg_file[rs2];
      reg_file[rd] = reg_file[rs1] >> urs2;
    endfunction
            
    function void addi();
      reg_file[rd] = {{20{immediate[11]}}, immediate} + reg_file[rs1];
    endfunction: addi

    function void slli();
      logic unsigned ushamt = shamt;
      logic unsigned urs1 = reg_file[rs1];
      reg_file[rd] = urs1 << ushamt;
    endfunction: slli

    function void slti();
      if (reg_file[rs1] < immediate) begin
        reg_file[rd] = 1;
      end else begin
        reg_file[rd] = 0; end
    endfunction: slti

    function void sltiu();
      logic unsigned urs1= reg_file[rs1];
      logic unsigned uimm= immediate;
      if (urs1 < uimm) begin
        reg_file[rd] = 1;
      end else begin
        reg_file[rd] = 0; end
    endfunction: sltiu

    function void xori();
      reg_file[rd] = reg_file[rs1] ^ immediate;
    endfunction: xori
            
  function void mult();
      reg_file[rd] = reg_file[rs1]*reg_file[rs2];
    endfunction: mult
            
  function void div();
      reg_file[rd] = reg_file[rs1]/reg_file[rs2];
    endfunction: div
         
  function void load();
      reg_file[rs1] = reg_file[rs2+{imm_11_5, imm_4_0}];
    endfunction

  function void store();
      reg_file[rs2] = reg_file[rs1+{imm_11_5, imm_4_0}];
    endfunction
          

endclass: reference_model