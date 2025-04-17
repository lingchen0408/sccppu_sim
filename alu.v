`include "ctrl_encode_def.v"

module alu(A, B, ALUOp, C, Zero);
   input  signed [31:0] A, B;
   input         [4:0]  ALUOp;
   output signed [31:0] C;
   output Zero;  //condition flag: set if condition is true for B-type instruction
   
   reg [31:0] C;
   integer    i;
       
   always @( * ) begin
      case ( ALUOp )
      `ALUOp_lui:C=B;
      `ALUOp_add:C=A+B;
      `ALUOp_sub:C=A-B;  //and beq
      `ALUOp_xor:C=A^B;
      `ALUOp_or:C=A|B;
      `ALUOp_and:C=A&B;
      `ALUOp_sll:C=A<<B;
      `ALUOp_srl:C=A>>B;
      `ALUOp_sra:C=A>>>B;
      // 注意C是一个32位的输出，所以赋值的时候也要按照32位来赋值
      `ALUOp_slt:C=(A<B)?{31'b0,1'b1}: 32'b0;
      `ALUOp_sltu: C = ($unsigned(A) < $unsigned(B)) ? {31'b0,1'b1}: 32'b0;
      `ALUOp_bne: C = (A != B) ? {31'b0,1'b1}: 32'b0;
      `ALUOp_blt: C = (A < B) ? {31'b0,1'b1}: 32'b0;
      `ALUOp_bge: C = (A >= B) ? {31'b0,1'b1}: 32'b0;
      `ALUOp_bltu: C = ($unsigned(A) < $unsigned(B)) ? {31'b0,1'b1}: 32'b0;
      `ALUOp_bgeu: C = ($unsigned(A) >= $unsigned(B)) ? {31'b0,1'b1}: 32'b0;
      default: C=A;
      endcase

   end // end always
   
   // 这里卡了很久，原因是没搞清楚Branch指令的alu运算结果的作用
   // Branch类型指令的本质是，满足xxx条件跳转，在这里是满足xxx条件时，Zero信号为1（其实我觉得这个Zero信号的命名也很有迷惑性）
   // 它的名字叫Zero也就导致你的代码必须在满足跳转条件时，C == 32'b0
   // 但是实际上，Zero信号的作用是判断是否满足跳转条件，所以我觉得应该叫做Condition更合理些，这里就不改了，，，
   assign Zero = (C == {31'b0,1'b1});  

endmodule
    
