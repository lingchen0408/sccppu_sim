`include "ctrl_encode_def.v"
// 单周期CPU计算机模块
// 执行流程：取指->译码->执行->访存->写回
module sccomp(clk, rstn, reg_sel, reg_data);
   input          clk, rstn; 
   input [4:0]    reg_sel;
   output [31:0]  reg_data;
   
   wire [31:0]    instr; // 读入的指令
   wire [31:0]    PC; // 程序计数器
   wire           MemWrite;
   wire [31:0]    dm_addr, dm_din, dm_dout;
   
   wire reset;
   assign reset = rstn; // 连续赋值，复位信号会实时更新
   
   // instantiation of single-cycle CPU   
   // 包含单周期CPU、数据存储器、指令存储器
   // 记录一个小小的疑问，这个模块用了SCCPU dm im模块，以instr为例，显然是im计算出之后，SCCPU再用，那么程序运行的时候是如何保证先计算再使用的呢？
   // 单周期CPU的行为是基于时钟信号进行同步的，我们只关心时钟上升沿到来时的行为，由于im 模块的输出 instr 是组合逻辑的结果。
   // 所以只要 PC[31:2] 的值发生变化，instr 会立即更新为对应的指令值，那这就保证了在上升沿到来的时刻，得到的instr是没有问题的
   SCCPU U_SCCPU(
         .clk(clk),                   // input:  cpu clock
         .reset(reset),               // input:  reset
         .inst_in(instr),             // input:  instruction
         .Data_in(dm_dout),           // input:  data to cpu  
         .mem_w(MemWrite),            // output: memory write signal
         .PC_out(PC),                 // output: PC to im
         .Addr_out(dm_addr),          // output: address from cpu to memory/dm
         .Data_out(dm_din),           // output: data from cpu to memory/dm
         .reg_sel(reg_sel),         // input:  register selection
         .reg_data(reg_data)        // output: register data
         );
   
   dm    U_DM(
         .clk(clk),           // input:  cpu clock
         .DMWr(MemWrite),     // input:  ram write
         .addr(dm_addr),      // input:  ram address
         .din(dm_din),         // input:  data to ram
         .dout(dm_dout)        // output: data from ram
         );
         
  // instantiation of intruction memory (used for simulation)
   im    U_imem ( 
         .addr(PC[31:2]),     // input:  rom address
         .dout(instr)        // output: instruction
         );
  
endmodule





















