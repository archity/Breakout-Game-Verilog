`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2017 16:39:01
// Design Name: 
// Module Name: Ball_Bricks_Testing
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


module Ball_Bricks_Testing(
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
    reg[3:0] red, green, blue;
    //wire squareBall;
    
    reg[3:0] redWire, greenWire, blueWire;
    VGA_Sync syncGate(.clock(clock), .reset(reset), .hSync(hSync), .vSync(vSync),
    .videoON(videoON), .pTick(clock25), .pixelX(pixelX), .pixelY(pixelY));
    
    Ball_Bricks ballBricksGate(.clock(clock), .reset(reset), .pixelX(pixelX), .pixelY(pixelY), 
    .objRed(vgaRed), .objGreen(vgaGreen), .objBlue(vgaBlue));
    
endmodule
