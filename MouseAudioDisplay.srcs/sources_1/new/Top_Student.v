`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: 
//  STUDENT B NAME:
//  STUDENT C NAME: 
//  STUDENT D NAME:  
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (
    input basys_clk,
    input btn_C,
    inout ps2_clk,  
    inout ps2_data,
    input [4:0] sw,
    output [7:0] JC,
    output [7:0] JA,
    output reg [15:0] led
    );
    // Mouse 
    wire mouse_left_btn, mouse_middle_btn, mouse_right_btn;
    wire [6:0] cursor_x_pos;
    wire [5:0] cursor_y_pos;
    
    wire frame_begin_2, sending_pixels_2, sample_pixel_2;
    wire [12:0] pixel_index_2;
    reg [15:0] oled_cursor_data = 0;
    wire [15:0] oled_cursor_1_data;
    wire [15:0] oled_cursor_2_data;
    wire [15:0] oled_cursor_team_data;
    
    parameter [6:0] bound_x = 94;
    parameter [6:0] bound_y = 62;
    reg [1:0] set_max_x = 0;
    reg [1:0] set_max_y = 1;
    reg [6:0] bound;
    
    reg toggle = 1;
    
    MouseCtl mouse_control(
        .clk(basys_clk), 
        .rst(btn_C), 
        .value(bound), 
        .setx(0), 
        .sety(0),
        .setmax_x(set_max_x), 
        .setmax_y(set_max_y),
        .left(mouse_left_btn), 
        .middle(mouse_middle_btn), 
        .right(mouse_right_btn),
        .ps2_clk(ps2_clk), 
        .ps2_data(ps2_data),
        .xpos(cursor_x_pos),
        .ypos(cursor_y_pos)
    );
    
    reg change = 0;
    
    // Display

    wire [15:0] oled_data;
    wire frame_begin_1, sending_pixels_1, sample_pixel_1;
    wire [12:0] pixel_index_1;
    
    create_oled_7seg(.basys_clock(basys_clk),.sw(sw),.pixel_index(pixel_index_1), .oled_data(oled_data), .cursor_x_pos(cursor_x_pos), .cursor_y_pos(cursor_y_pos));
    
    wire clk6p25m;
    clk_divider my_clk6p25m(.basys_clk(basys_clk), .m(7), .new_clk(clk6p25m));
    
    wire [14:0] toXOR;
    get_segment(.cursor_x_pos(cursor_x_pos), .cursor_y_pos(cursor_y_pos), .mouse_left_btn(mouse_left_btn), .change(toXOR));       

    Oled_Display oled_unit_one(
        .clk(clk6p25m), 
        .reset(0), 
        .frame_begin(frame_begin_1), 
        .sending_pixels(sending_pixels_1), 
        .sample_pixel(sample_pixel_1), 
        .pixel_index(pixel_index_1), 
        .pixel_data(oled_data), 
        .cs(JC[0]), 
        .sdin(JC[1]), 
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
   
    
    Oled_Display oled_unit_two(
        .clk(clk6p25m), 
        .reset(btn_C), 
        .frame_begin(frame_begin_2), 
        .sending_pixels(sending_pixels_2), 
        .sample_pixel(sample_pixel_2), 
        .pixel_index(pixel_index_2), 
        .pixel_data(oled_cursor_data), 
        .cs(JA[0]), 
        .sdin(JA[1]), 
        .sclk(JA[3]), 
        .d_cn(JA[4]), 
        .resn(JA[5]), 
        .vccen(JA[6]),
        .pmoden(JA[7])
    );
        
    mouse_task cursor_1 (
        .basys_clk(basys_clk),
        .clk6p25m(clk6p25m),
        .btn_C(btn_C),
        .cursor_x_pos(cursor_x_pos),
        .cursor_y_pos(cursor_y_pos),
        .pixel_index_2(pixel_index_2),
        .oled_cursor_data(oled_cursor_1_data)
    );
    
    mouse_task_larger cursor_2 (
        .basys_clk(basys_clk),
        .clk6p25m(clk6p25m),
        .btn_C(btn_C),
        .cursor_x_pos(cursor_x_pos),
        .cursor_y_pos(cursor_y_pos),
        .pixel_index_2(pixel_index_2),
        .oled_cursor_data(oled_cursor_2_data)
    );
      
    always @ (posedge basys_clk) begin
        led[14:0] <= led[14:0] ^ toXOR;  
        set_max_x <= 1 - set_max_x;
        set_max_y <= 1 - set_max_y;
        if (set_max_x == 1) begin
            bound <= bound_y;
        end
        else if (set_max_y == 1) begin
            bound <= bound_x;
        end       
        if (mouse_middle_btn) begin
            toggle <= toggle + 1;
        end         
        if (toggle == 1) begin
            oled_cursor_data <= oled_cursor_1_data;
        end
        else begin
            oled_cursor_data <= oled_cursor_2_data;
        end    
    end   
endmodule