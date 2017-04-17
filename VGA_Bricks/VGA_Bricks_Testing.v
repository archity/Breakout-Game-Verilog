`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2017 23:42:06
// Design Name: 
// Module Name: VGA_Bricks_Testing
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


module VGA_Bricks_Testing(
    input clock, reset,
    //input switch, 
    output hSync, vSync,
    
    //4 bit color signals
    output[3:0] vgaRed,
    output[3:0] vgaGreen,
    output[3:0] vgaBlue
    );
    
    wire videoON;
    //reg videoON_reg;
    wire [9:0] pixelX, pixelY;
    wire clock25;   //25MHz clock from VGA_Sync
    wire[3:0] red, green, blue;
    
    
    reg[3:0] redWire, greenWire, blueWire;
    VGA_Sync syncGate(.clock(clock), .reset(reset), .hSync(hSync), .vSync(vSync),
    .videoON(videoON), .pTick(clock25), .pixelX(pixelX), .pixelY(pixelY));
    
    VGA_Bricks brickGate(.clock(clock), .reset(reset), .pixelX(pixelX), .pixelY(pixelY), .objRed(red), .objGreen(green), .objBlue(blue));
     
    
    assign vgaRed = (videoON)? red: 0;
    assign vgaGreen = (videoON)? green: 0;
    assign vgaBlue = (videoON)? blue: 0;
    
    
 
endmodule
