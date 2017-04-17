`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2017 23:48:11
// Design Name: 
// Module Name: VGA_Bricks
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


module VGA_Bricks(
    input clock, reset,
    input[9:0] pixelX, pixelY,    
    
    output [3:0] objRed,
    output [3:0] objGreen,
    output [3:0] objBlue
    
    );
    
    
    wire brick1, brick2, brick3, brick4;
    reg[3:0] redWire, greenWire, blueWire;
    
    //4 bricks
    assign brick1 = (pixelX>=10 && pixelX<=90 && pixelY>=10&& pixelY<=50);
    assign brick2 = (pixelX>=140 && pixelX<=220 && pixelY>=10&& pixelY<=50);
    assign brick3 = (pixelX>=270 && pixelX<=350 && pixelY>=10&& pixelY<=50);
    assign brick4 = (pixelX>=400 && pixelX<=480 && pixelY>=10&& pixelY<=50);
    
    always@(posedge clock)
    begin
        if(brick1)
        begin
            redWire <= 4'b1101;
            greenWire <= 4'b1111;
            blueWire <= 4'b0100;
        end
        else if(brick2)
        begin
            redWire <= 4'b1101;
            greenWire <= 4'b0101;
            blueWire <= 4'b1100;
        end
        else if(brick3)
        begin
            redWire <= 4'b0101;
            greenWire <= 4'b1001;
            blueWire <= 4'b0001;
        end
        else if(brick4)
        begin
            redWire <= 4'b0110;
            greenWire <= 4'b1101;
            blueWire <= 4'b1001;
        end
        else 
        begin
            redWire <= 4'b0000;
            greenWire <= 4'b0000;
            blueWire <= 4'b0000;
            //black background
        end
        
    end
        
    assign objRed = redWire;
    assign objGreen = greenWire;
    assign objBlue = blueWire;
    
endmodule
