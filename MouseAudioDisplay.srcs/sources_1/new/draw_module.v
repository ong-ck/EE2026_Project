`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2023 01:02:10 AM
// Design Name: 
// Module Name: draw_module
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


module draw_module(
    input basys_clock,
    input sw0,
    output [12:0] curr_display,
    input [12:0] output_display,
    input [6:0] cursor_x_pos,
    input [5:0] cursor_y_pos,
    output [7:0] JC
    );
    
    parameter GREEN = 16'h07E0;
    parameter WHITE = 16'hFFFF;
    parameter RED = 16'hF800;
    
    wire clk25mhz;
    clk_divider my_clk25mhz(.basys_clk(basys_clock), .m(1), .new_clk(clk25mhz));
    
    reg [15:0] oled_data = 0;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    
    reg [12:0] display = 13'b0;
    assign curr_display = display;
    
    always @ (posedge basys_clock) begin
        display <= display ^ output_display;
    end
    
    Oled_Display oled_unit_one(
        .clk(clk25mhz), 
        .reset(0), 
        .frame_begin(frame_begin), 
        .sending_pixels(sending_pixels), 
        .sample_pixel(sample_pixel), 
        .pixel_index(pixel_index), 
        .pixel_data(oled_data), 
        .cs(JC[0]), 
        .sdin(JC[1]), 
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
    
    wire [6:0] x;
    wire [5:0] y;
        
    assign x = (pixel_index % 96); // from 0 to 95
    assign y = (pixel_index / 96); // from 0 to 63
    
    always @ (posedge clk25mhz) begin
    if ((x == cursor_x_pos && y == cursor_y_pos) || 
        (x == cursor_x_pos + 1 && y == cursor_y_pos)||
        (x == cursor_x_pos && y == cursor_y_pos + 1) ||
        (x == cursor_x_pos + 1 && y == cursor_y_pos + 1)) begin
        oled_data <= RED;
    end
    // Green border
    else if ((sw0) &&
        ((x == 56 && y <= 56) || 
         (x <= 56 && y == 56) ||
         (x == 57 && y <= 57) || 
         (x <= 57 && y == 57) ||
         (x == 58 && y <= 58) ||
         (x <= 58 && y == 58))) begin
        oled_data <= GREEN;
    end   
    // 7-segment OLED template
    else if ((x >= 10 && x <= 45 && y == 6) ||
        (x >= 10 && x <= 45 && y == 12) ||
        (x >= 10 && x <= 45 && y == 25) ||
        (x >= 10 && x <= 45 && y == 31) ||
        (x >= 10 && x <= 45 && y == 43) ||
        (x >= 10 && x <= 45 && y == 49) ||
        (x == 10 && y >= 6 && y <= 49) ||
        (x == 16 && y >= 6 && y <= 49) ||
        (x == 39 && y >= 6 && y <= 49) ||
        (x == 45 && y >= 6 && y <= 49)) begin
        oled_data <= WHITE;
    end
    else if (display[0] == 1 &&
             (x >= 11 && x <= 15 && y >= 7 && y <= 11)) begin
        oled_data <= WHITE;
    end
    else if (display[1] == 1 &&
             (x >= 17 && x <= 38 && y >= 7 && y <= 11)) begin
        oled_data <= WHITE;
    end
    else if (display[2] == 1 &&
             (x >= 40 && x <= 44 && y >= 7 && y <= 11)) begin
        oled_data <= WHITE;
    end
    else if (display[3] == 1 &&
             (x >= 40 && x <= 44 && y >= 13 && y <= 24)) begin
        oled_data <= WHITE;
    end
    else if (display[4] == 1 &&
             (x >= 40 && x <= 44 && y >= 26 && y <= 30)) begin
        oled_data <= WHITE;
    end
    else if (display[5] == 1 &&
             (x >= 40 && x <= 44 && y >= 32 && y <= 42)) begin
        oled_data <= WHITE;
    end
    else if (display[6] == 1 &&
             (x >= 40 && x <= 44 && y >= 44 && y <= 48)) begin
        oled_data <= WHITE;
    end
    else if (display[7] == 1 &&
             (x >= 17 && x <= 38 && y >= 44 && y <= 48)) begin
        oled_data <= WHITE;
    end
    else if (display[8] == 1 &&
             (x >= 11 && x <= 15 && y >= 44 && y <= 48)) begin
        oled_data <= WHITE;
    end
    else if (display[9] == 1 &&
             (x >= 11 && x <= 15 && y >= 32 && y <= 42)) begin
        oled_data <= WHITE;
    end
    else if (display[10] == 1 &&
             (x >= 11 && x <= 15 && y >= 26 && y <= 30)) begin
        oled_data <= WHITE;
    end
    else if (display[11] == 1 &&
             (x >= 11 && x <= 15 && y >= 13 && y <= 24)) begin
        oled_data <= WHITE;
    end
    else if (display[12] == 1 &&
             (x >= 17 && x <= 38 && y >= 26 && y <= 30)) begin
        oled_data <= WHITE;
    end
    else begin
        oled_data <= 0;
    end
    end
    
endmodule