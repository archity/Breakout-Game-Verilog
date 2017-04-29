`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2017 01:09:16
// Design Name: 
// Module Name: VGA_Paddle_Testing
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


module VGA_Paddle_Testing(
    input clock, reset,
    //input switch, 
    output hSync, vSync,
    
    //4 bit color signals
    output[3:0] vgaRed,
    output[3:0] vgaGreen,
    output[3:0] vgaBlue,
    
    input btnL, btnR
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
    
    VGA_Paddle paddleGate(.clock(clock), .reset(reset), .pixelX(pixelX), .pixelY(pixelY), .barWire(barWire), .btnL(btnL), .btnR(btnR));
     
    always@(posedge clock)
    begin
        if(barWire)
        begin
            red <= 4'b1111;
            green <= 4'b1111;
            blue <= 4'b0000;
            //yellow
        end
        else
        begin
            red <= 4'b0000;
            green <= 4'b0000;
            blue <= 4'b0000;
            //black
        end
    end
    
    assign vgaRed = (videoON)? red: 0;
    assign vgaGreen = (videoON)? green: 0;
    assign vgaBlue = (videoON)? blue: 0;
    
endmodule
