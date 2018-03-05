`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:23:43 PM
// Design Name: 
// Module Name: alu
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


module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )(
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult,
	output logic		TakeBranch
        );
    
        always_comb
        begin
            ALUResult = 'd0;
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0001:        //OR
                    ALUResult = SrcA | SrcB;
            4'b0010:        //ADD
                    ALUResult = SrcA + SrcB;
            4'b0011:        //Subtract
                    ALUResult = $signed(SrcA) - $signed(SrcB);
            4'b0100:        //XOR
                    ALUResult = SrcA ^ SrcB;
            4'b0101:        //Shift Left Logical
                    ALUResult = SrcA << SrcB[4:0];
            4'b0110:        //Shift Right Logical
                    ALUResult = SrcA >> SrcB[4:0];
            4'b0111:        //Shift Right Arithmetic
                    ALUResult = SrcA >>> SrcB[4:0];
            4'b1000:        //Less Than Signed
                   ALUResult =  ($signed(SrcA) < $signed(SrcB)) ? 32'b1 : 32'b0;
            4'b1001:        //Less Than Unsigned
                   ALUResult =  (SrcA < SrcB) ? 32'b1 : 32'b0; 
            default:
                    ALUResult = 'b0;
            endcase
        end

        always_comb
        begin
            TakeBranch = 1'b0;
            case(Operation)
             4'b1000:        //Less Than Signed
                TakeBranch = ($signed(SrcA) < $signed(SrcB)) ? 1'b1 : 1'b0;
             4'b1001:        //Less Than Unsigned
                TakeBranch = (SrcA < SrcB) ? 1'b1 : 1'b0;
             4'b1010:        //BEQ
                    TakeBranch = (SrcA == SrcB) ? 1'b1 : 1'b0;
             4'b1011:        //BNE
                    TakeBranch = (SrcA != SrcB) ? 1'b1 : 1'b0;
             4'b1100:        //Greater Than or Equal Signed
                   TakeBranch = ($signed(SrcA) >= $signed(SrcB)) ? 1'b1 : 1'b0;
             4'b1101:        //Greater Than or Equal Unsigned
                   TakeBranch = (SrcA >= SrcB) ? 1'b1 : 1'b0;
            default:
                TakeBranch = 1'b0;
            endcase

        end

endmodule

