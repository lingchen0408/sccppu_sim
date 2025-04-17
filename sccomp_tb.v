`timescale 1ns/1ns 
// 测试模块 Single-Cycle Computer Testbench
// 将测试文件的指令（机器码）加载到指令存储器中，模拟指令执行，从而测试单周期CPU
module sccomp_tb();
   reg    clk, rstn;
   reg  [4:0] reg_sel;
   wire [31:0] reg_data;

   // instantiation of sccomp
   sccomp sccomp(.clk(clk), .rstn(rstn), .reg_sel(reg_sel), .reg_data(reg_data));

   // initialization of inputs
   initial begin
     // input instructions for simulation, rv32_sc_sim
      $readmemh("rv32_sc_sim.dat", sccomp.U_imem.RAM);

      clk = 1;
      rstn = 1; // 将PC初始化为0？
      #10 ;
      rstn = 0;
      reg_sel = 7;// ??
   end
   
   always begin
      #(5) clk = ~clk;
   end
   
endmodule
