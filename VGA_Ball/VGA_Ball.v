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
    input[9:0] pixelX, pixelY,    
    output ballWire
    
    //output circleSignal
    );
    
    
    wire sixtyHzTick;
    localparam SPEED_POS = 1;
    localparam SPEED_NEG = -1;
    
    
    /*---------------------------------------*/
    /* Ball variables */
    reg [9:0] ballRegX, ballRegY;
    wire [9:0] ballWireX, ballWireY;
    
    wire[9:0] left, right, top, bottom;//These are kinda coordinates of the square ball.
    
    /*---------------------------------------*/
    reg[9:0] incrementRegX, incrementRegY;
    reg[9:0] incrementWireX, incrementWireY;
    /* Change in x or y coordiates. Value determines the speed. Sign determines the
    direction. */
    /*---------------------------------------*/
    
    
    /*---------------------------------------*/
    
    /*---------------------------------------*/
    always@(posedge clock or posedge reset)
    begin
        if(reset)
        begin
            ballRegX <= 0;
            ballRegY <= 0;
            incrementRegX<=10'h004;
            incrementRegY<=10'h004;
        end
        else
        begin
            ballRegX <= ballWireX;
            ballRegY <= ballWireY;
            incrementRegX <= incrementWireX;
            incrementRegY <= incrementWireY;
        end
    end 
    
    /*---------------------------------------*/
    assign sixtyHzTick = (pixelY==481) && (pixelX==0);
    /* Scanning had reached the end of screen...To get the refresh rate of 60Hz. */
    /*---------------------------------------*/
    
    assign left = ballRegX;
    assign right = left + 10 - 1;   //10 is the size of the ball;
    assign top = ballRegY;
    assign bottom = top + 10 - 1;
    
    wire ball;   //will hold the signal for when the ball is to be displayed.
    
    assign ball = ( (pixelX >= left) && (pixelX <=right) && (pixelY >= top) && (pixelY <= bottom) );
    
    assign ballWireX = (sixtyHzTick)? (ballRegX + incrementRegX) : (ballRegX);
    assign ballWireY = (sixtyHzTick)? (ballRegY + incrementRegY) : (ballRegY);
    
    always@(*)
    begin
        incrementWireX <= incrementRegX;
        incrementWireY <= incrementRegY;
        
        if(left<=32)
        incrementWireX <= SPEED_POS;
        else if(right>=630)
        incrementWireX <= SPEED_NEG;
        else if(top<=22)
        incrementWireY <= SPEED_POS;
        else if(bottom>=470)
        incrementWireY <=SPEED_NEG;
        
    end
    
    assign ballWire = ball;
    
endmodule
