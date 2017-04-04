`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.03.2017 16:44:30
// Design Name: 
// Module Name: VGA_TestingObjects
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


module VGA_TestingObjects(
    input clock, reset,
    //input switch, 
    output hSync, vSync,
    //output [2:0] RGB,
    
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
    
    VGA_Object objectGate(.pixelX(pixelX), .pixelY(pixelY), .videoON(videoON),
    .objRed(red), .objGreen(green), .objBlue(blue), .clock(clock), .clock25(clock25));
    
    assign vgaRed = (videoON)? red: 0;
    assign vgaGreen = (videoON)? green: 0;
    assign vgaBlue = (videoON)? blue: 0;
    
endmodule
