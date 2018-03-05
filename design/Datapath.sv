`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Datapath #(
    parameter PC_W = 9, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite ,     // Register file writing enable   // Memory or ALU MUX
    input logic [1:0] MemtoReg,
    input logic ALUsrc , MemWrite ,       // Register file or Immediate MUX // Memroy Writing Enable                 (should these be defined outside the declaration?)
    MemRead,                 // Memroy Reading Enable
    Branch,		     // Control flow flags	
    ControlJAL, ControlJALR,   
    ControlLUI,
    
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,
    output logic [DATA_W-1:0] WB_Data //ALU_Result
    );

logic [PC_W-1:0] PC, PCPlus4, PCPlusImm, ALUPC, newPC;
logic [INS_W-1:0] Instr;
logic [DATA_W-1:0] Result;
logic [DATA_W-1:0] Reg1, Reg2;
logic [DATA_W-1:0] ReadData, SelectedReadData;
logic [DATA_W-1:0] SrcB, SrcA, ALUResult;
logic [DATA_W-1:0] ExtImm;
logic [DATA_W-1:0] dPCPlusIMM, dPCPlus4;
logic [DATA_W-1:0] SW, SH, SB, StoreData;
logic [DATA_W-1:0] LW, LH, LHU, LB, LBU;
logic TakeBranch;

logic [1:0] PCSel;
logic [1:0] ALUop;
logic [1:0] Store_Type;
logic [2:0] Load_Type;

// next PC
    adder #(9) pcadd (PC, 9'b100, PCPlus4);
    flopr #(9) pcreg(clk, reset, newPC, PC);

 //Instruction memory
    instructionmemory instr_mem (PC, Instr);
    
    assign opcode = Instr[6:0];
    assign Funct7 = Instr[31:25];
    assign Funct3 = Instr[14:12];

//Controller
   Controller controller(opcode, ALUsrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ControlJAL, ControlJALR, ControlLUI, ALUop);
      
////Register File
    RegFile rf(clk, reset, RegWrite, Instr[11:7], Instr[19:15], Instr[24:20],
            Result, Reg1, Reg2);
                 
//// generate immediate and sign extend
    imm_Gen Ext_Imm (Instr,ExtImm);

////ALUController
     ALUController aluc(ALUop, Funct7, Funct3, MemWrite, MemRead, ALU_CC,  Store_Type, Load_Type);

//// ALU
    mux2 #(32) srcamux(Reg1, 32'b0, ControlLUI, SrcA);
    mux2 #(32) srcbmux(Reg2, ExtImm, ALUsrc, SrcB);
    alu alu_module(SrcA, SrcB, ALU_CC, ALUResult, TakeBranch);
    assign WB_Data = ALUResult;

//// Write Data Type Mux
    assign SW = Reg2;
    assign SH = {Reg2[15]? 16'b1:16'b0, Reg2[15:0]};
    assign SB = {Reg2[7]? 24'b1:24'b0, Reg2[7:0]};
    mux4 #(32) DataTypeMux(SW, SH, SB, SW, Store_Type, StoreData);
    
////// Data memory 
    datamemory data_mem (clk, MemRead, MemWrite, ALUResult[DM_ADDRESS-1:0], StoreData, ReadData);


//// Read Data Type Mux
    assign LW = ReadData;
    assign LH = {ReadData[15]? 16'b1:16'b0, ReadData[15:0]};
    assign LHU = {16'b0, ReadData[15:0]};
    assign LB = {ReadData[7]? 24'b1:24'b0, ReadData[7:0]};
    assign LBU = {24'b0, ReadData[7:0]};
    mux8 #(32) ReadTypeMux(LW, LH, LHU, LB, LBU, LW, LW, LW, Load_Type, SelectedReadData);

//// new pc values
    adder #(9) PcAddWithImm(PC, ExtImm[8:0], PCPlusImm);
    assign ALUPC = {ALUResult[8:1], 1'b0};

//// PCmux
    assign PCSel[0] = ((Branch && TakeBranch) || ControlJAL);
    assign PCSel[1] = ControlJALR;
    mux4 #(9) PCMux(PCPlus4, PCPlusImm, ALUPC, PCPlus4, PCSel, newPC);

/// Result mux
    adder #(32) AUIPCAdder({23'b0,PC}, ExtImm, dPCPlusIMM);
    assign dPCPlus4 = {23'b0, PCPlus4}; 
    mux4 #(32) resmux(ALUResult, SelectedReadData, dPCPlusIMM, dPCPlus4, MemtoReg, Result);


     
endmodule
