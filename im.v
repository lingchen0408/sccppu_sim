// instruction memory
// 给定一个地址（指令存储器按字对其，低2位总为0），返回对应地址处的指令
module im(input  [31:2]  addr, output [31:0] dout);
  reg  [31:0] RAM[127:0]; // 这里定义的是一个二维数组，每一个数组元素是一个32位的单元，共128个这样的单元（数组索引范围是0-127）

  assign dout = RAM[addr]; // word aligned
endmodule  
