`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.04.2017 18:23:40
// Design Name: 
// Module Name: PaddleBallBricks
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


module PaddleBallBricks(
    input clock, reset,
    input[9:0] pixelX, pixelY,    
    
    output [3:0] objRed,
    output [3:0] objGreen,
    output [3:0] objBlue,
  
    input btnL,
    input btnR
    //output ballWire
    );
    
    wire brick1, brick2, brick3, brick4, brick5;
    reg brick1_ON = 1, brick2_ON = 1, brick3_ON = 1, brick4_ON = 1, brick5_ON = 1;
    /* The above parameters(registers) tell whether a brick is to be displayed or not.
    Their value becomes 0 when the ball hits the corresponding brick. */
     
    wire borderL, borderT, borderR, borderD;
    reg[3:0] redWire, greenWire, blueWire;
    
    //5 bricks
    parameter brickBottom = 62;
    
    parameter brick1_L=60, brick1_R=130;
    parameter brick2_L=180, brick2_R=250;
    parameter brick3_L=300, brick3_R=370;
    parameter brick4_L=420, brick4_R=490;
    parameter brick5_L=540, brick5_R=610;
    /* The left and right coordintes of all the 5 bricks. */
    
    assign brick1 = (pixelX>=60 && pixelX<=130 && pixelY>=52 && pixelY<=62);
    assign brick2 = (pixelX>=180 && pixelX<=250 && pixelY>=52 && pixelY<=62);
    assign brick3 = (pixelX>=300 && pixelX<=370 && pixelY>=52 && pixelY<=62);
    assign brick4 = (pixelX>=420 && pixelX<=490 && pixelY>=52 && pixelY<=62);
    assign brick5 = (pixelX>=540 && pixelX<=610 && pixelY>=52 && pixelY<=62);
    
    //4 borders
    assign borderL = (pixelX>=42 && pixelX<=51 && pixelY>=42 && pixelY<=471);
    assign borderT = (pixelX>=42 && pixelX<=631 && pixelY>=32 && pixelY<=42);
    assign borderR = (pixelX>=631 && pixelX<=640 && pixelY>=32 && pixelY<=480);
    assign borderD = (pixelX>=42 && pixelX<=631 && pixelY>=471 && pixelY<=480);
    
    reg gameOver;
    
    always@(posedge clock)
    begin
        if(borderL | borderT | borderR | borderD)//Border region detected while scanning.
        begin
            redWire <= 4'b0000;
            greenWire <= 4'b1111;
            blueWire <= 4'b0000;
        end
        else if(brick1 & brick1_ON & !gameOver)//if brick1 region detected while scanning AND brick1 has NOT been hit by the ball.
        begin
            redWire <= 4'b1101;
            greenWire <= 4'b1111;
            blueWire <= 4'b0100;
        end
        else if(brick2 & brick2_ON & !gameOver)
        begin
            redWire <= 4'b1101;
            greenWire <= 4'b0101;
            blueWire <= 4'b1100;
        end
        else if(brick3 & brick3_ON & !gameOver)
        begin
            redWire <= 4'b0101;
            greenWire <= 4'b1001;
            blueWire <= 4'b0001;
        end
        else if(brick4 & brick4_ON & !gameOver)
        begin
            redWire <= 4'b0110;
            greenWire <= 4'b1101;
            blueWire <= 4'b1001;
        end
        else if(brick5 & brick5_ON & !gameOver)
        begin
            redWire <= 4'b1110;
            greenWire <= 4'b1001;
            blueWire <= 4'b1001;
        end
        else if(ballWire & !gameOver)
        begin
            redWire <= 4'b1111;
            greenWire <= 4'b1111;
            blueWire <= 4'b0000;
        end
        else if(barWire & !gameOver)
        begin
            redWire <= 4'b1111;
            greenWire <= 4'b1100;
            blueWire <= 4'b0100;
        end
        else 
        begin
            redWire <= 4'b0000;
            greenWire <= 4'b0000;
            blueWire <= 4'b0000;
            //black background
        end
        
    end
        
    assign objRed = redWire;
    assign objGreen = greenWire;
    assign objBlue = blueWire;
    
    
    
    /*------------------------------------------------------------------------------*/
    /*----------------------------BALL LOGIC----------------------------------------*/
    /*------------------------------------------------------------------------------*/
    
    wire sixtyHzTick;   //to get the 60Hz refresh rate.
    localparam SPEED_POS = 1;
    localparam SPEED_NEG = -1;
    /* Used to change the DIRECTION of motion of the ball by adding the above in
    x as well as y coordinate */
    
    /*---------------------------------------*/
    /* Ball variables */
    reg [9:0] ballRegX, ballRegY;
    wire [9:0] ballWireX, ballWireY;
    /* To store the x and y coordintes of the moving object, more precisely, the top
    and the left sides of the moving square */
    
    /*---------------------------------------*/
    wire[9:0] left, right, top, bottom;//These are kinda coordinates of the square ball.
    /* left and top are same as ballRegX and ballRegY, respectively. right and bottom
    get the modified values from the same RegX variables. */
    
    /*---------------------------------------*/
    reg[9:0] incrementRegX, incrementRegY;
    reg[9:0] incrementWireX, incrementWireY;
    /* Change in x or y coordiates. Value determines the speed. Sign determines the
    direction...will either have SPEED_POS or SPEED_NEG as their value, depending
    on the current trajectory and place of deflection of the ball. */
    /*---------------------------------------*/
    
    /*---------------------------------------*/
    always@(posedge clock or posedge reset)
    begin
        if(reset)   //reset button was presed...
        begin
            ballRegX <= 0;
            ballRegY <= 0;
            gameOver <= 0;
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
    //assign ballWireX = (sixtyHzTick)? (ballRegX + incrementRegX) : (ballRegX);
    assign ballWireY = (sixtyHzTick)? (ballRegY + incrementRegY) : (ballRegY);
    
    wire brick1_Hit, brick2_Hit, brick3_Hit, brick4_Hit, brick5_Hit;//weather a brick was hit or not.
    assign brick1_Hit = (top<brickBottom && (left>brick1_L && right<brick1_R));
    assign brick2_Hit = (top<brickBottom && (left>brick2_L && right<brick2_R));
    assign brick3_Hit = (top<brickBottom && (left>brick3_L && right<brick3_R));
    assign brick4_Hit = (top<brickBottom && (left>brick4_L && right<brick4_R));
    assign brick5_Hit = (top<brickBottom && (left>brick5_L && right<brick5_R));
    //reg dummy;
    wire value;
    assign value = (brick1_Hit|brick2_Hit|brick3_Hit|brick4_Hit|brick5_Hit)?(0):(1);
    always@(*)
    begin
        
        if(brick1_Hit)
        begin
            brick1_ON <= value;
        end
        else if(brick2_Hit)
        begin
            brick2_ON <= value;
        end 
        else if(brick3_Hit)
        begin
            brick3_ON <= value;
        end
        else if(brick4_Hit)
        begin
            brick4_ON <= value;
        end
        else if(brick5_Hit)
        begin
            brick5_ON <= value;
        end
        else
        begin
            //dummy <= 1;
            brick1_ON <= 1;
            brick2_ON <= 1;
            brick3_ON <= 1;
            brick4_ON <= 1;
            brick5_ON <= 1;
        end
    end
    
    wire[9:0] leftWireBar, rightWireBar;//from the paddle logic(see them after lines below)
    always@(*)
    begin
        incrementWireX <= incrementRegX;
        incrementWireY <= incrementRegY;
        
        if(left<=52)
        incrementWireX <= SPEED_POS;
        else if(right>=630)
        incrementWireX <= SPEED_NEG;
        else if(top<=42)//
        incrementWireY <= SPEED_POS;
        else if(bottom>=460 && left>=leftWireBar && right<=rightWireBar)
        incrementWireY <=SPEED_NEG;
        else if(bottom>=470)
        gameOver <= 1;
    end
    
    assign ballWire = ball;
    
    
    
    /*------------------------------------------------------------------------------*/
    /*----------------------------PADDLE LOGIC----------------------------------------*/
    /*------------------------------------------------------------------------------*/
    
    localparam BAR_TOP = 460; //(top bundary)
    localparam BAR_BOTTOM = 465; //(bottom boundary)
    localparam BAR_SIZE = 64; //(Paddle Size)
    localparam BAR_STEP = 1; //Bar moving velocity when the button is pressed
    localparam MAX_X = 640;
    localparam MAX_Y = 480;

    // Paddle left and right boundary
    wire [9:0] LeftBar, rightBar;
    //Register to track the next x coordinate of the paddle
    reg[9:0] barRegX = 10'b0000000000;
    reg[9:0] barWireX;
    //Boundary of the paddle
    
    always@(posedge clock or posedge reset)
    begin
        if(reset)
        begin
            barRegX <= 10'b0000000000;
        end
        else
        begin
            barRegX <= barWireX;
        end
    end
    
    
    
    
    assign leftWireBar = barRegX;
    assign rightWireBar = barRegX + BAR_SIZE;
    /*Left and right coordintes of the paddle*/
    
    //wire barWire;   //wheather scanning cursor is within the bar area or not.
    
    assign barWire = (pixelX>=leftWireBar && pixelX<=rightWireBar && pixelY>=BAR_TOP && pixelY<=BAR_BOTTOM);
    
    //assign barWireX = (sixtyHzTick && btnL && leftWireBar>(0))? (barRegX - BAR_STEP):(barRegX);
    //assign barWireX = (sixtyHzTick && btnR && rightWireBar<(MAX_X - BAR_STEP))? (barRegX + BAR_STEP):(barRegX);
    always@(*)
    begin
        //barWireX = barRegX;
        if(sixtyHzTick)
        begin
            if(btnL & (leftWireBar > (0)))
            begin
                barWireX <= barRegX - BAR_STEP; 
            end
            else if(btnR & (rightWireBar < (MAX_X - BAR_STEP)))
            begin
                barWireX <= barRegX + BAR_STEP;
            end
            else barWireX <= barRegX;//No button pressed, drive the current value to the wire again.
        end
        
    end 
    
endmodule
