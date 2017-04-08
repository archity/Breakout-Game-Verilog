`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2017 14:30:00
// Design Name: 
// Module Name: VGA_Ball
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


module VGA_Ball(
    input clock, reset,
    output hSync, vSync,
    
    //4 bit color signals
    output[3:0] vgaRed,
    output[3:0] vgaGreen,
    output[3:0] vgaBlue
    //output circleSignal
    );
    
    wire videoON;
    reg [9:0] pixelX, pixelY;
    wire clock25;   //25MHz clock from VGA_Sync
    wire[3:0] red, green, blue;
    
    reg[3:0] redWire, greenWire, blueWire;
    VGA_Sync syncGate(.clock(clock), .reset(reset), .hSync(hSync), .vSync(vSync),
    .videoON(videoON), .pTick(clock25), .pixelX(pixelX), .pixelY(pixelY));

    //integer x = pixelX;
    //integer r=50, x=100, y=100;
    //integer distance;
    wire circle;
    reg [9:0] x = 10'b0001100100;   //x coordinate of centre (100)
    reg [9:0] y = 10'b0001100100;   //y coordinate of centre (100)
    reg [9:0] r = 10'b0000110010;   //radius (10)
    
    assign circle = ( ((x-pixelX)^2 + (y-pixelY)^2) <= r^2 );
    /* Using the distance formulae for calculating the distance between the centre
    and scanning cursor's current coordinates. If it lies within the intended region
    (the circle), circle wire would be set to high. */
    
    always@(posedge clock)
    begin
        if(circle)
        begin
            redWire <= 4'b1111;
            greenWire <= 4'b0000;
            blueWire <= 4'b0000;
            //Red color for circle
        end
        else
        begin
            redWire <= 4'b0000;
            greenWire <= 4'b0000;
            blueWire <= 4'b0000;
        end
    end

    assign vgaRed = (videoON)? redWire: 0;
    assign vgaGreen = (videoON)? greenWire: 0;
    assign vgaBlue = (videoON)? blueWire: 0;
    
    //assign circleSignal = circle;
    
endmodule
