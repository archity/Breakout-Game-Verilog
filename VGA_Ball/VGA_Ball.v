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
    input pixelX, pixelY,    
    output squareBall
    
    //output circleSignal
    );
    
    wire[9:0] pixelX, pixelY;
    wire sixtyhzTick;
    localparam SPEED_POS = 1;
    localparam SPEED_NEG = -1;
    
    
    /*---------------------------------------*/
    /* Ball variables */
    reg [9:0] ballRegX, ballRegY;
    wire [9:0] ballWireX, ballWireY;
    
    wire[9:0] left, right, top, bottom;//These are kinda coordinates of the square ball.
    
    /*---------------------------------------*/
    reg[9:0] incrementRegX, incrementRegY;
    wire[9:0] incrementWireX, incrementWireY;
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
    assign sixtyHzTick = (pixelY==480) && (pixelX==0);
    /* Scanning had reached the end of screen...To get the refresh rate of 60Hz. */
    /*---------------------------------------*/
    
    assign left = ballRegX;
    assign right = left + 10 - 1;   //10 is the size of the ball;
    assign top = ballRegY;
    assign bottom = top + 10 - 1;
    
    wire ballWire;   //will hold the signal for when the ball is to be displayed.
    
    assign ballWire = ( (pixelX >= left) && (pixelX <=right) && (pixelY >= top) && (pixelY <= bottom) );
    
    assign ballWireX = (sixtyHzTick)? (ballRegX + incrementRegX) : (ballRegX);
    assign ballWireY = (sixtyHzTick)? (ballRegY + incrementRegY) : (ballRegY);
    
    always@(*)
    begin
        incrementRegX <= incrementWireX;
        incrementRegY <= incrementWireY;
        
        if(left<=2)
        incrementRegX <= SPEED_POS;
        else if(right>=630)
        incrementRegX <= SPEED_NEG;
        else if(top<=2)
        incrementRegY <= SPEED_POS;
        else if(bottom>=470)
        incrementRegY <=SPEED_NEG;
        
    end
    
endmodule
