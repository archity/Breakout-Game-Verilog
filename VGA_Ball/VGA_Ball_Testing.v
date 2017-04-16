`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.04.2017 22:26:00
// Design Name: 
// Module Name: VGA_Ball_Testing
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


module VGA_Ball_Testing(
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
    wire squareBall;
    
    reg[3:0] redWire, greenWire, blueWire;
    VGA_Sync syncGate(.clock(clock), .reset(reset), .hSync(hSync), .vSync(vSync),
    .videoON(videoON), .pTick(clock25), .pixelX(pixelX), .pixelY(pixelY));
    
    VGA_Ball ballObjectGate(.pixelX(pixelX), .pixelY(pixelY), .clock(clock),
     .squareBall(squareBall));
     
    always@(posedge clock)
    begin
        if(squareBall)
        begin
            red <= 4'b1111;
            green <= 4'b0000;
            blue <= 4'b0000;
        end
        else
        begin
            red <= 4'b0000;
            green <= 4'b1111;
            blue <= 4'b0000;
        end
    end
    
    assign vgaRed = (videoON)? red: 0;
    assign vgaGreen = (videoON)? green: 0;
    assign vgaBlue = (videoON)? blue: 0;
    
 
endmodule
