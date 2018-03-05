`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Controller
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

module Controller(
    
    //Input
    input logic [6:0] Opcode, //7-bit opcode field from the instruction
    
    //Outputs
    output logic ALUSrc,//0: The second ALU operand comes from the second register file output (Read data 2); 
                  //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic [1:0] MemtoReg, //0: The value fed to the register Write data input comes from the ALU.
                     //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic Branch,  //0: not a branch instruction; 1: is a branch instruction
    output logic ControlJAL,      //0 not JAL, 1 JAL also going to use to control AUIPC because both share Pc + IMM as target destination
    output logic ControlJALR,     //0 not JALR, 1 JALR
    output logic ControLUI,    //Will be used to determine source A. 0 for rs1 1 for 0
    output logic [1:0] ALUOp
);

//    localparam R_TYPE = 7'b0110011;
//    localparam LW     = 7'b0000011;
//    localparam SW     = 7'b0100011;
//    localparam BR     = 7'b1100011;
//    localparam RTypeI = 7'b0010011; //addi,ori,andi
    
    logic [6:0] R_TYPE, LW, SW, RTypeI;
    
    assign R_TYPE = 7'b0110011;
   
    assign LW = 7'b0000011; //lw,lh,lb
    assign RTypeI = 7'b0010011; //addi,ori,andi
    assign JALR = 7'b1100111;

    assign SW = 7'b0100011; //sw,sh,sb

    assign J_TYPE = 7'b1101111; //JAL

    assign LUI = 7'b0110111;
    assign AUIPC = 7'b0010111;

	assign  B_TYPE = 7'b1100011; //BEQ,BNE,BLT,BGE,BLTU,BGEU




    assign ALUSrc   = (Opcode==LW || Opcode==SW || Opcode ==RTypeI || Opcode ==JALR || Opcode ==LUI || Opcode ==AUIPC || Opcode ==B_TYPE);
    assign MemtoReg[0] = (Opcode==LW || Opcode==JALR);
    assign MemtoReg[1] = (Opcode==AUIPC|| Opcode==JALR);
    assign RegWrite = (Opcode==R_TYPE || Opcode==LW || Opcode ==RTypeI || Opcode ==JALR || Opcode ==LUI || Opcode ==AUIPC);
    assign MemRead  = (Opcode==LW);
    assign MemWrite = (Opcode==SW);
    assign Branch   = (Opcode==B_TYPE);
    assign ControlJAL = (Opcode==J_TYPE || Opcode==AUIPC);
    assign ControlJALR = (Opcode==JALR);
    assign ControlLUI = (Opcode==LUI);
    assign ALUOp[0] = (Opcode==RTypeI || Opcode==B_TYPE);
    assign ALUOp[1] = (Opcode==R_TYPE || Opcode==B_TYPE);
  

endmodule
