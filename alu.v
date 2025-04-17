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
      `ALUOp_slt:C=(A<B)?{31'b0,1'b1}: 32'b0; //set less than
      `ALUOp_sltu: C = ($unsigned(A) < $unsigned(B)) ? {31'b0,1'b1}: 32'b0; // set less than unsigned
      `ALUOp_bne: C = (A != B) ? {31'b0,1'b1}: 32'b0; // not equal
      `ALUOp_blt: C = (A < B) ? {31'b0,1'b1}: 32'b0; // less than
      `ALUOp_bge: C = (A >= B) ? {31'b0,1'b1}: 32'b0; // greater than or equal
      `ALUOp_bltu: C = ($unsigned(A) < $unsigned(B)) ? {31'b0,1'b1}: 32'b0; // less than unsigned
      `ALUOp_bgeu: C = ($unsigned(A) >= $unsigned(B)) ? {31'b0,1'b1}: 32'b0; // greater than or equal unsigned
      default: C=A;
      endcase
      $write("A(hex) = %h  ", A);
      $write("B(hex) = %h ", B);
      $write("A(dec) = %d  ", A);
      $write("B(dec) = %d ", B);
      $write("C(dec) = %d ", C);
   end // end always
   
   assign Zero = (C == 32'b0);  

endmodule
    
