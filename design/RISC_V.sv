`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32)
    (input logic clk, reset, // clock and reset signals
    output logic [31:0] WB_Data// The ALU_Result
    );

logic [6:0] opcode;
logic ALUSrc, RegWrite, MemRead, MemWrite;
logic [1:0] MemtoReg;
logic Branch, ControlJAL, ControlJALR, ControlLUI;

logic [1:0] ALUop;
logic [6:0] Funct7;
logic [2:0] Funct3;
logic [3:0] Operation;
logic [1:0] Store_Type;
logic [2:0] Load_Type;

    Controller c(opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ControlJAL, ControlJALR, ControlLUI,  ALUop);
    
    ALUController ac(ALUop, Funct7, Funct3, MemWrite, MemRead, Operation, Store_Type, Load_Type);

    Datapath dp(clk, reset, RegWrite , MemtoReg, ALUSrc , MemWrite, MemRead, Branch, ControlJAL, ControlJALR, ControlLUI, Operation, opcode, Funct7, Funct3, WB_Data);
        
endmodule
