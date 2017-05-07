`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2017 18:21:03
// Design Name: 
// Module Name: All_Combined
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


module All_Combined(
    input clock, reset,
    //input switch, 
    output hSync, vSync,
    
    //4 bit color signals
    output[3:0] vgaRed,
    output[3:0] vgaGreen,
    output[3:0] vgaBlue,
    
    input btnL, //left button
    input btnR  //right button
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
    
    PaddleBallBricks mygate(.clock(clock), .reset(reset), .pixelX(pixelX), .pixelY(pixelY), 
        .objRed(vgaRed), .objGreen(vgaGreen), .objBlue(vgaBlue), .btnL(btnL), .btnR(btnR));
    
endmodule
