module signalcontrol(
	input[11:0] flags,
	input zero,
  output reg [4:0] s1, // IF,REG [IRwrite, PCsave, immsrc, regbdst]
	output reg [8:0] s2, // ALU [ALUsrcA, ALUsrcB, ALUop, NZCV]
	output reg [1:0] s3, // MEM [Mwrite, Mread]
	output reg [4:0] s4); // WB [regwrite, regdst, regsrc]

 always @ (*) begin
  if(flags==12'b000000000000) begin // bubble
    s1=5'b10xxx;
    s2=20'bxxxxxxxxx;
    s3=20'b00;
    s4=20'b0xxxx;
  end
  else if((flags[11]&flags[10]&flags[9])||(flags[8]^zero)) begin
    if(flags[7]) begin //B, BL
      if(~flags[4]) begin //B
        s1=5'b00100;
      end
      else begin //BL
        s1=5'b01100;
      end
      s2=9'b001001000;
      s3=2'b00;
      s4=5'b0xxxx;
    end
    else if(flags[6]) begin //LDR, STR
      s1={4'b1001, (flags[0]==1 ? 1'b0 : 1'b1)};
      s2={2'b01,(flags[5]==1 ? 2'b11 : 2'b10),(flags[3]==1 ? 4'b0100 : 4'b0010),1'b0};
      if(~flags[0]) begin //STR
        s3=2'b10;
        s4=5'b0xxxx;
      end
      else begin //LDR
        s3=2'b01;
        s4=5'b10000;
      end 
    end
    else //Else
    case(flags[4:1])/*
        0 : //AND
        1 : //EOR
        2 : //SUB
        4 : //ADD
        5 : //ADC
        6 : //SBC
        12 : //ORR*/
      10 : begin //CMP
        s1=5'b10000;
        s2={2'b01, (flags[5]==1 ? 2'b10 : 2'b11), 5'b00101};
        s3=2'b00;
        s4=5'b0xxxx;
      end
      13 : begin //MOV
        s1=5'b10000;
        s2={2'b10, (flags[5]==1 ? 2'b10 : 2'b11), 4'b0100 ,flags[0]};
        s3=2'b00;
        s4=5'b10001;
      end
      default : begin //ALU
        s1=5'b10000;
        s2={2'b01, (flags[5]==1 ? 2'b10 : 2'b11), flags[4:0]};
        s3=2'b00;
        s4=5'b10001;
      end
    endcase
  end
  else begin //Recovery
    s1=5'b10xxx;
    s2=20'bxxxxxxxxx;
    s3=20'b00;
    s4=20'b0xxxx;
  end
 end
endmodule 

module oneStep(
	input clk,
	input reset,
	input [11:0] new_flag,
	output reg[11:0] step1,
  output reg[11:0] step2,
  output reg[11:0] step3,
  output reg[11:0] step4);
	
  wire [11:0] stepB[3:0];
  assign stepB[3] = step3;
  assign stepB[2] = step2;
  assign stepB[1] = step1;
  assign stepB[0] = new_flag;

	always @ (posedge clk, posedge reset) begin
    if(reset) begin
      step1<=12'b000000000000;
      step2<=12'b000000000000;
      step3<=12'b000000000000;
      step4<=12'b000000000000;
    end
    else begin
      step4=stepB[3];
      step3=stepB[2];
      step2=stepB[1];
      step1=stepB[0];
    end
  end
endmodule

module signalunit
	(input clk,
	 input reset,
	 input[11:0] flags,
	 input zero,
	 output Mwrite,
	 output IRwrite,
   output PCsave,
	 output Mread,
	 output regwrite,
	 output[1:0] regdst,
	 output[1:0] regsrc,
	 output[1:0] ALUsrcA,
	 output[1:0] ALUsrcB,
	 output[3:0] ALUop,
	 output NZCVwrite,
	 output [1:0] immsrc,
	 output regbdst);
  
  wire [4:0] s_if;
  wire [8:0] s_alu;
  wire [1:0] s_mem;
  wire [4:0] s_wb;
  
  wire [11:0] stege1,stage2,stage3,stage4;


  oneStep Next_step(.clk (clk), .reset (reset), .new_flag (flags), .step1 (stege1), .step2(stage2), .step3(stage3), .step4(stage4));
  
  signalcontrol bring_if(.flags (stage1), .zero (zero), .s1 (s_if), .s2 (), .s3 (),.s4 ());
  signalcontrol bring_alu(.flags (stage2), .zero (zero), .s1 (), .s2 (s_alu), .s3 (),.s4 ()); 
  signalcontrol bring_mem(.flags (stage3), .zero (zero), .s1 (), .s2 (), .s3 (s_mem),.s4 ()); 
  signalcontrol bring_wb(.flags (stage4), .zero (zero), .s1 (), .s2 (), .s3 (),.s4 (s_wb)); 
  
  assign IRwrite=s_if[4];
  assign PCsave=s_if[3];
  assign immsrc=s_if[2:1];
  assign regbdst=s_if[0];

  assign ALUsrcA=s_alu[8:7];
  assign ALUsrcB=s_alu[6:5];
  assign ALUop=s_alu[4:1];
  assign NZCVwrite=s_alu[0];

  assign Mwrite=s_mem[1];
  assign Mread=s_mem[0];

  assign regwrite=s_wb[4];
  assign regdst=s_wb[3:2];
  assign regsrc=s_wb[1:0];
  
endmodule