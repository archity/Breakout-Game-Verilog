`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.03.2017 23:22:41
// Design Name: 
// Module Name: VGA_Sync
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


module VGA_Sync(
    input clock, reset,
    output hSync, vSync, videoON, pTick,
    output [9:0] pixelX, pixelY //to get the coordintes of pixel during scanning.
    );
    /*------------------------------------*/
    /*-------------CONSTANTS--------------*/
    //parameters defining the screen.
    localparam HORIZONTAL_DISPLAY = 640;
    localparam HORIZONTAL_LEFT = 16;
    localparam HORIZONTAL_RIGHT = 48;
    localparam HORIZONTAL_RETRACE = 96;
    
    localparam VERTICAL_DISPLAY = 480;
    localparam VERTICAL_TOP = 11;
    localparam VERTICAL_BOTTOM = 31;
    localparam VERTICAL_RETRACE = 2;


    /*------------------------------------*/
   
    
    reg[9:0] horizontalCount, verticalCount;
    reg[9:0] horizontalCountNext, verticalCountNext;
    //to keep count of horizontal and vertical scanning.
    
    reg verticalSync, horizontalSync;
    wire verticalSyncNext, horizontalSyncNext;
    /*the reg ones are connected to the vSync & hSync and the wire
    ones are updated according to certain condition and are connected
    to the reg ones */
    
    wire verticalEnd, horizontalEnd;
    //indicate the end of horizontal or vertical screen reading.
    
    always@(posedge clock or posedge reset)
    begin
        if(reset)
        begin
            verticalSync = 0;
            horizontalSync = 0;
            horizontalCount = 0;
            verticalCount = 0;
        end
        else
        begin
            verticalSync <= verticalSyncNext;
            horizontalSync <= horizontalSyncNext;
            verticalCount <= verticalCountNext;
            horizontalCount <= horizontalCountNext;
        end
    end
    /*-----------------------------------------*/
    /*-----------------------------------------*/
    
    /*We need to convert the 100MHz clock to 65MHz
    in order to support the requirement of 60Hz VGA
    monitor to have a resolution of 1024X768 - (Not yet done)
    Right now it is 25MHz.
    
    Edit: the code is now working and the VGA does show up output,
    but it is happening only at a resolution of 640x480 with
    pixel frequency of 25MHz. clock25 wire contains the 25MHz clock
    (24.762, more precisely, generated using Clocking Wizard).
    */
    wire clock65;   //65MHz (unused)
    wire clock40;   //40MHz (unused)
    wire clock25;   //25MHz
    
    CustomClock mygate(.clk_in1(clock), .clk_out1(clock65), .clk_out2(clock40), .clk_out3(clock25)); 
    //CustomClock module automatically created using Clocking Wizard.
    
    /*-------------------------------------------*/
    /*-------------------------------------------*/
    //Signals detecting the end of the line/screen
    assign verticalEnd = (verticalCount==(VERTICAL_DISPLAY + VERTICAL_TOP + VERTICAL_BOTTOM + VERTICAL_RETRACE-1));
    
    assign horizontalEnd = (horizontalCount==(HORIZONTAL_DISPLAY + HORIZONTAL_LEFT + HORIZONTAL_RIGHT + HORIZONTAL_RETRACE-1));
    /*-------------------------------------------*/
    
    
    /*-------------------------------------------*/
    /*-------------------------------------------*/
    //always loop for keeping track of horizontal scanning
    always@(posedge clock25)
    begin
        //if(posedge clock65)
        begin
            if(horizontalEnd)
            horizontalCountNext = 0;
            else
            horizontalCountNext = horizontalCount + 1;
        end
        //else
        //horizontalCountNext = horizontalCount;//essentialy changes nothing.
    end
    /*-------------------------------------------*/
    
    /*-------------------------------------------*/
    /*-------------------------------------------*/
    //always loop for keeping track of vertical scanning
    always@(posedge clock25)    //25Mhz custom clock with the completetion of one horizontal line scanning.
    begin
        if(horizontalEnd)   
        begin
            if(verticalEnd)
            verticalCountNext = 0;
            else
            verticalCountNext = verticalCount + 1;
        end
        else
        verticalCountNext = verticalCount;
    end
    /*-------------------------------------------*/
        
    assign horizontalSyncNext = (horizontalCount>=(HORIZONTAL_DISPLAY+HORIZONTAL_RIGHT) && horizontalCount<=(HORIZONTAL_DISPLAY+HORIZONTAL_RIGHT+HORIZONTAL_RETRACE-1));
    assign verticalSyncNext = (verticalCount>=(VERTICAL_DISPLAY+VERTICAL_BOTTOM) && verticalCount<=(VERTICAL_DISPLAY+VERTICAL_BOTTOM+VERTICAL_RETRACE-1));
    
    
    /*-------------------------------------------*/
    /*connecting the outputs of this module with its local variables*/
    
    assign videoON = (verticalCount <= VERTICAL_DISPLAY && horizontalCount <= HORIZONTAL_DISPLAY);
    //as long as the scanning is in the intended area (640X480), keep the display ON
    
    assign hSync = horizontalSync;
    assign vSync = verticalSync;
    assign pixelX = horizontalCount;
    assign pixelY = verticalCount;
    assign pTick = clock25;
    
endmodule
