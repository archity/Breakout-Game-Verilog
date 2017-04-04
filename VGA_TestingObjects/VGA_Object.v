`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2017 15:59:23
// Design Name: 
// Module Name: VGA_Object
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


module VGA_Object(
    input [9:0] pixelX, pixelY,
    input videoON,
    input clock, input clock25,
    
    output [3:0] objRed,
    output [3:0] objGreen,
    output [3:0] objBlue
    );
    
    wire videoON;
    reg[3:0] redWire, greenWire, blueWire;
    wire square1, square2;
    /*RECTANGLE PARAMETERS*/
    
    assign square1 = ((pixelX>=100 && pixelX<=200) && (pixelY>=100 && pixelY<=200));
    assign square2 = ((pixelX>=300 && pixelX<=400) && (pixelY>=100 && pixelY<=200));
    
    always@(posedge clock)
    begin
        if(square1)
        begin
            redWire <= 4'b1101;
            greenWire <= 4'b1111;
            blueWire <= 4'b0100;
        end
        else if(square2)
        begin
            redWire <= 4'b0000;
            greenWire <= 4'b0000;
            blueWire <= 4'b1111;
        end
        else
        begin
            redWire <= 4'b1111;
            greenWire <= 4'b0000;
            blueWire <= 4'b0000;
        end
    end
    
    assign objRed = redWire;
    assign objGreen = greenWire;
    assign objBlue = blueWire;
            
    
endmodule
