`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2017 08:41:26
// Design Name: 
// Module Name: VGA_Testing
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


module VGA_Testing(
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
    reg videoON_reg;
    
    reg[3:0] redWire, greenWire, blueWire;
    VGA_Sync mygate(.clock(clock), .reset(reset), .hSync(hSync), .vSync(vSync), .videoON(videoON), .pTick(), .pixelX(), .pixelY());
    //assign videoON_reg = videoON;
    always@(posedge clock or posedge reset)
    begin
        if(reset)
        begin
            redWire <= 0;
            greenWire <= 0;
            blueWire <= 0;
        end
        else
        begin
            redWire <= 4'b0000;
            greenWire <= 4'b1111;
            blueWire <= 4'b0000;
        end
    end
    
    assign vgaRed = (videoON)? redWire: 0;
    assign vgaGreen = (videoON)? greenWire: 0;
    assign vgaBlue = (videoON)? blueWire: 0;
    /*assign vgaRed = redWire;
    assign vgaGreen = greenWire;
    assign vgaBlue = blueWire;*/
    
    
endmodule
