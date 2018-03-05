`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: ALUController
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


module ALUController(
    
    //Inputs
    input logic [1:0] ALUOp,  //7-bit opcode field from the instruction
    input logic [6:0] Funct7, // bits 25 to 31 of the instruction
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    input logic MemWrite,     //used to determine store type
    input logic MemRead,      //used to determine load type
    
    //Output
    output logic [3:0] Operation, //operation selection for ALU
    output logic [1:0] Store_Type, //determine amount of data to store
    output logic [2:0] Load_Type   //determine amount of data to load
);
 
 assign Operation[0]= ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b110)) || //r-or
                      ((ALUOp[0]==1'b1) && (Funct3==3'b110)) || //i-or
                      ((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b000)) || //sub
                      ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b001)) || //r-sll
                      ((ALUOp[0]==1'b1) && (Funct3==3'b001)) || //i-sll
                      ((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //r-sra
                      ((ALUOp[0]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //i-sra
                      ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b011)) || //r-sltu
                      ((ALUOp[0]==1'b1) && (Funct3==3'b011)) || //i-sltu
                      ((ALUOp==2'b11) && (Funct3==3'b110)) || //bltu
                      ((ALUOp==2'b11) && (Funct3==3'b001)) || //bne
                      ((ALUOp==2'b11) && (Funct3==3'b111)); //bgeu
                     
 assign Operation[1]= (ALUOp==2'b00) || //general adds
                     ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b000)) || //r-add
                     ((ALUOp[0]==1'b1) && (Funct3==3'b000)) || //i-add
                     ((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b000)) || //sub
                     ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b101)) || //r-srl
                     ((ALUOp[0]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b101)) || //i-srl
                     ((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //r-sra
                     ((ALUOp[0]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //i-sra
                     ((ALUOp==2'b11) && (Funct3==3'b000)) || //beq
                     ((ALUOp==2'b11) && (Funct3==3'b001)); //bne
               
 assign Operation[2]= ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b100)) || //r-xor
                      ((ALUOp[0]==1'b1) && (Funct3==3'b100)) || //i-xor 
                      ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b001)) || //r-sll
                      ((ALUOp[0]==1'b1) && (Funct3==3'b001)) || //i-sll
                      ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b101)) || //r-srl
                      ((ALUOp[0]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b101)) || //i-srl
                      ((ALUOp[1]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //r-sra
                      ((ALUOp[0]==1'b1) && (Funct7==7'b0100000) && (Funct3==3'b101)) || //i-sra
                      ((ALUOp==2'b11) && (Funct3==3'b101)) || //bge
                      ((ALUOp==2'b11) && (Funct3==3'b111)); //bgeu
 
 assign Operation[3]=  ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b010)) || //r-slt
                       ((ALUOp[0]==1'b1) && (Funct3==3'b010)) || //i-slt
                       (ALUOp==2'b11) && (Funct3==3'b100) || //blt
                       ((ALUOp[1]==1'b1) && (Funct7==7'b0000000) && (Funct3==3'b011)) || //r-sltu
                       ((ALUOp[0]==1'b1) && (Funct3==3'b011)) || //i-sltu
                       ((ALUOp==2'b11) && (Funct3==3'b110)) || //bltu
                       ((ALUOp==2'b11) && (Funct3==3'b000)) || //beq
                       ((ALUOp==2'b11) && (Funct3==3'b001)) || //bne
                       ((ALUOp==2'b11) && (Funct3==3'b101)) || //bge
                       ((ALUOp==2'b11) && (Funct3==3'b111)); //bgeu


 assign Store_Type[0] = ((MemWrite == 1'b1) && (Funct3 == 3'b001)); //SH

 assign Store_Type[1] = ((MemWrite == 1'b1) && (Funct3 == 3'b000)); //SB


 assign Load_Type[0] = ((MemRead == 1'b1) && (Funct3 == 3'b001)) || //LH
                       ((MemRead == 1'b1) && (Funct3 == 3'b000)); //LB

assign Load_Type[1] = ((MemRead == 1'b1) && (Funct3 == 3'b101)) || //LHU
                       ((MemRead == 1'b1) && (Funct3 == 3'b000)); //LB

assign Load_Type[2] = ((MemRead == 1'b1) && (Funct3 == 3'b100)); //LBU


                       
                

endmodule
