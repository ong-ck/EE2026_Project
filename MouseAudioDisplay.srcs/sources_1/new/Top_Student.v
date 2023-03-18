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
    input basys_clock,
    input btnC,
    inout ps2_clk,  
    inout ps2_data,
    input sw0, sw15,
    output led15,
    output [7:0] JC,
    output [3:0] an,
    output [7:0] seg,
    output [3:0] JB
    );
    
//////////////////////////////////////////////////////////////////////////////////
// Set up mouse
//////////////////////////////////////////////////////////////////////////////////  
    parameter [6:0] bound_x = 94;
    parameter [6:0] bound_y = 62;
    reg setmax_x = 0;
    reg setmax_y = 1;
    reg [6:0] bound;
    
    wire left, middle, right;
    wire [6:0] cursor_x_pos;
    wire [5:0] cursor_y_pos;
    
    MouseCtl mouse_control(
        .clk(basys_clock), 
        .rst(btnC), 
        .value(bound), 
        .setx(0), 
        .sety(0), 
        .setmax_x(setmax_x), 
        .setmax_y(setmax_y),
        .left(left), 
        .middle(middle),
        .right(right),
        .ps2_clk(ps2_clk), 
        .ps2_data(ps2_data),
        .xpos(cursor_x_pos),
        .ypos(cursor_y_pos)
    );
    wire debounced_left;
    debounce debounce_mouse_left_btn (.clock(basys_clock), .input_signal(left), .output_signal(debounced_left));
    
    always @ (posedge basys_clock) begin
        setmax_x <= 1 - setmax_x;
        setmax_y <= 1 - setmax_y;
        if (setmax_x == 1) begin
            bound <= bound_y;
        end
        else if (setmax_y == 1) begin
            bound <= bound_x;
        end
    end
//////////////////////////////////////////////////////////////////////////////////
// OLED
////////////////////////////////////////////////////////////////////////////////// 
    wire clk25mhz;
    clk_divider my_clk25mhz(.basys_clk(basys_clock), .m(1), .new_clk(clk25mhz));
    
    reg [15:0] oled_data = 0;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    
    Oled_Display oled_unit_one(
        .clk(clk25mhz), 
        .reset(0), 
        .frame_begin(frame_begin), 
        .sending_pixels(sending_pixels), 
        .sample_pixel(sample_pixel), 
        .pixel_index(pixel_index), 
        .pixel_data(oled_data_GT), 
        .cs(JC[0]), 
        .sdin(JC[1]), 
        .sclk(JC[3]), 
        .d_cn(JC[4]), 
        .resn(JC[5]), 
        .vccen(JC[6]),
        .pmoden(JC[7])
    );
//////////////////////////////////////////////////////////////////////////////////
    parameter [31:0] MAIN_MENU = 1;
    parameter [31:0] GROUP_TASK = 2;
    
    wire [7:0] JC_GT, JC_MM;
    wire [3:0] JB_GT;
    wire [3:0] an_GT;
    wire [7:0] seg_GT;
    
    wire [15:0] oled_data_GT;
    
    display_main_menu MM(
        .basys_clock(basys_clock),
        .JC(JC_MM),
        .ps2_clk(ps2_clk), 
        .ps2_data(ps2_data)
    );
    
    Group_Task GT(
        .basys_clock(basys_clock), 
        .sw0(sw0),
        .sw15(sw15),
        .cursor_x_pos(cursor_x_pos),
        .cursor_y_pos(cursor_y_pos),
        .mouse_left_btn(debounced_left), 
        .btnC(btnC), 
        .ps2_clk(ps2_clk), 
        .ps2_data(ps2_data),
        .pixel_index(pixel_index),
        .led15(led15),
        .an(an),
        .seg(seg),
        .oled_data(oled_data_GT)
    );

    
    reg current_state = 2;
    
//    assign JC = JC_GT;
//    assign an = an_GT;
//    assign seg = seg_GT;
//    assign JB = JB_GT;
    
//    always @ (*) begin
//        case (current_state)
//            MAIN_MENU: begin
//                JC <= JC_MM;
//                an <= 1;
//                seg <= 1;
//                JB <= 0;
//            end
//            GROUP_TASK: begin
//                JC <= JC_GT;
//                an <= an_GT;
//                seg <= seg_GT;
//                JB <= JB_GT;
//            end
//        endcase
//    end
//////////////////////////////////////////////////////////////////////////////////
endmodule