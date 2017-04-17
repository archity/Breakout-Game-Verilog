`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2017 01:11:29
// Design Name: 
// Module Name: VGA_Paddle
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


module VGA_Paddle(
    input clock,
    input reset,
    input[9:0] pixelX,
    input[9:0] pixelY,
    
    input btnL, 
    input btnR,
    /* The left and right button of Nexys */
    
    output barWire
    );
    
    localparam BAR_TOP = 470; //(top bundary)
    localparam BAR_BOTTOM = 475; //(bottom boundary)
    localparam BAR_SIZE = 64; //(Paddle Size)
    localparam BAR_STEP = 4; //Bar moving velocity when the button is pressed
    localparam MAX_X = 640;
    localparam MAX_Y = 480;

    // Paddle left and right boundary
    wire [9:0] LeftBar, rightBar;
    //Register to track the next x coordinate of the paddle
    reg[9:0] barRegX;
    reg[9:0] barWireX;
    //Boundary of the paddle
    
    always@(posedge clock or posedge reset)
    begin
        if(reset)
        begin
            barRegX <= 0;
        end
        else
        begin
            barRegX <= barWireX;
        end
    end
    
    wire sixtyHzTick;
    /*---------------------------------------*/
    assign sixtyHzTick = (pixelY==481) && (pixelX==0);
    /* Scanning had reached the end of screen...To get the refresh rate of 60Hz. */
    /*---------------------------------------*/
    
    wire[9:0] leftWireBar, rightWireBar;
    
    assign leftWireBar = barRegX;
    assign rightWireBar = barRegX + BAR_SIZE -1;
    
    wire barWire;   //wheather scanning cursor is within the bar area or not.
    
    assign barWire = (pixelX>=leftWireBar && pixelX<=rightWireBar && pixelY>=BAR_TOP && pixelY<=BAR_BOTTOM);
    
    always@(*)
    begin
        if(sixtyHzTick)
        begin
            if(~btnL && (leftWireBar>(0+BAR_STEP)))
            begin
                barWireX <= barRegX - BAR_STEP; 
            end
            else if(~btnR && (rightWireBar < (MAX_X - BAR_STEP)))
            begin
                barWireX <= barRegX + BAR_STEP;
            end
        end
        else barWireX = barRegX; 
        
    end 
    
    
endmodule
