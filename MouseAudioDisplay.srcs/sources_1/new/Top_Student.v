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
    // Delete this comment and include Basys3 inputs and outputs here
    input clock,
    input [4:0] sw,
    output [7:0] JC
    );
    
    parameter GREEN = 16'h07E0;
    parameter RED = 16'hF800;
    parameter BLACK = 16'h0000;
    parameter WHITE = 16'hFFFF; 

    // Delete this comment and write your codes and instantiations here
    
    reg [15:0] oled_data = (sw[4]) ? RED : GREEN;
    wire frame_begin, sending_pixels, sample_pixel;
    wire [12:0] pixel_index;
    
    wire clk6p25m;
    clk_divider my_clk6p25m (.basys_clk(clock), .m(7), .new_clk(clk6p25m));
    
    Oled_Display oled_unit_one(
        .clk(clk6p25m), 
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
    
    // end of old code
    
    wire [6:0] x;
    wire [5:0] y;
        
    assign x = (pixel_index % 96); // from 0 to 95
    assign y = (pixel_index / 96); // from 0 to 63
    
    always @ (posedge clk6p25m) begin // CHANGE TO 25MHz clock!!
    if (sw[4]) begin
    
        // Green border
        if ((x == 56 && y <= 56) || 
            (x <= 56 && y == 56) ||
            (x == 57 && y <= 57) || 
            (x <= 57 && y == 57) ||
            (x == 58 && y <= 58) ||
            (x <= 58 && y == 58)) begin
            oled_data <= GREEN;
        end
        
        // 0 Digit -> sw[0]
        else if ((sw[0] && ~sw[1] && ~sw[2] && ~sw[3]) &&
                 ((x >= 10 && x <= 45 && y >= 6 && y <= 12) ||
                  (x >= 10 && x <= 45 && y >= 43 && y <= 49) ||
                  (x >= 10 && x <= 16 && y >= 13 && y <= 42) ||
                  (x >= 39 && x <= 45 && y >= 13 && y <= 42))) begin
            oled_data <= WHITE;
        end
        
        // 1 Digit -> sw[1]
        else if ((sw[1] && ~sw[2] && ~sw[3]) &&
                 ((x >= 24 && x <= 32 && y >= 6 && y <= 49))) begin
            oled_data <= WHITE;      
        end
          
//        else if ((sw[1]) &&
//                 ((x >= 24 && x <= 31 && y == 6) ||
//                  (x >= 23 && x <= 31 && y == 7) ||
//                  (x >= 22 && x <= 31 && y == 8) ||
//                  (x >= 21 && x <= 31 && y == 9) ||
//                  (x >= 20 && x <= 31 && y == 10) ||
//                  (x >= 19 && x <= 31 && y == 11) ||
//                  (x >= 18 && x <= 31 && y == 12) ||
//                  (x >= 17 && x <= 31 && y == 13) ||
//                  (x >= 16 && x <= 31 && y >= 14 && y <= 19) ||
//                  (x >= 24 && x <= 31 && y >= 20 && y <= 43) ||
//                  (x >= 16 && x <= 39 && y >= 44 && y <= 49))) begin
//            oled_data <= WHITE;           
//        end
        
        // 2 Digit -> sw[2]
        else if ((sw[2] && ~sw[3]) &&
                 ((x >= 10 && x <= 45 && y >= 6 && y <= 11) ||
                  (x >= 40 && x <= 45 && y >= 12 && y <= 23) ||
                  (x >= 10 && x <= 45 && y >= 24 && y <= 31) ||
                  (x >= 10 && x <= 15 && y >= 32 && y <= 43) ||
                  (x >= 10 && x <= 45 && y >= 44 && y <= 49))) begin
            oled_data <= WHITE;
        end          
        
        // Test
        else if ((sw[3]) && ((x == 72 && y == 16) || (x == 73 && y == 16) || (x == 74 && y == 16) || (x == 75 && y == 16) || (x == 76 && y == 16) || (x == 23 && y == 17) || (x == 24 && y == 17) || (x == 25 && y == 17) || (x == 47 && y == 17) || (x == 48 && y == 17) || (x == 49 && y == 17) || (x == 50 && y == 17) || (x == 71 && y == 17) || (x == 72 && y == 17) || (x == 76 && y == 17) || (x == 77 && y == 17) || (x == 23 && y == 18) || (x == 26 && y == 18) || (x == 46 && y == 18) || (x == 50 && y == 18) || (x == 51 && y == 18) || (x == 71 && y == 18) || (x == 72 && y == 18) || (x == 78 && y == 18) || (x == 79 && y == 18) || (x == 21 && y == 19) || (x == 22 && y == 19) || (x == 27 && y == 19) || (x == 45 && y == 19) || (x == 52 && y == 19) || (x == 72 && y == 19) || (x == 73 && y == 19) || (x == 79 && y == 19) || (x == 21 && y == 20) || (x == 28 && y == 20) || (x == 44 && y == 20) || (x == 45 && y == 20) || (x == 52 && y == 20) || (x == 73 && y == 20) || (x == 74 && y == 20) || (x == 75 && y == 20) || (x == 76 && y == 20) || (x == 77 && y == 20) || (x == 78 && y == 20) || (x == 79 && y == 20) || (x == 20 && y == 21) || (x == 21 && y == 21) || (x == 28 && y == 21) || (x == 44 && y == 21) || (x == 52 && y == 21) || (x == 77 && y == 21) || (x == 78 && y == 21) || (x == 20 && y == 22) || (x == 28 && y == 22) || (x == 43 && y == 22) || (x == 52 && y == 22) || (x == 20 && y == 23) || (x == 28 && y == 23) || (x == 43 && y == 23) || (x == 52 && y == 23) || (x == 19 && y == 24) || (x == 29 && y == 24) || (x == 43 && y == 24) || (x == 51 && y == 24) || (x == 52 && y == 24) || (x == 19 && y == 25) || (x == 29 && y == 25) || (x == 43 && y == 25) || (x == 51 && y == 25) || (x == 18 && y == 26) || (x == 29 && y == 26) || (x == 43 && y == 26) || (x == 51 && y == 26) || (x == 18 && y == 27) || (x == 29 && y == 27) || (x == 43 && y == 27) || (x == 50 && y == 27) || (x == 18 && y == 28) || (x == 29 && y == 28) || (x == 42 && y == 28) || (x == 49 && y == 28) || (x == 17 && y == 29) || (x == 29 && y == 29) || (x == 42 && y == 29) || (x == 48 && y == 29) || (x == 74 && y == 29) || (x == 75 && y == 29) || (x == 76 && y == 29) || (x == 77 && y == 29) || (x == 78 && y == 29) || (x == 17 && y == 30) || (x == 29 && y == 30) || (x == 42 && y == 30) || (x == 48 && y == 30) || (x == 71 && y == 30) || (x == 72 && y == 30) || (x == 73 && y == 30) || (x == 79 && y == 30) || (x == 17 && y == 31) || (x == 29 && y == 31) || (x == 42 && y == 31) || (x == 47 && y == 31) || (x == 71 && y == 31) || (x == 79 && y == 31) || (x == 17 && y == 32) || (x == 29 && y == 32) || (x == 42 && y == 32) || (x == 46 && y == 32) || (x == 70 && y == 32) || (x == 79 && y == 32) || (x == 29 && y == 33) || (x == 42 && y == 33) || (x == 45 && y == 33) || (x == 69 && y == 33) || (x == 80 && y == 33) || (x == 29 && y == 34) || (x == 42 && y == 34) || (x == 44 && y == 34) || (x == 69 && y == 34) || (x == 80 && y == 34) || (x == 29 && y == 35) || (x == 41 && y == 35) || (x == 42 && y == 35) || (x == 43 && y == 35) || (x == 69 && y == 35) || (x == 80 && y == 35) || (x == 29 && y == 36) || (x == 32 && y == 36) || (x == 33 && y == 36) || (x == 34 && y == 36) || (x == 35 && y == 36) || (x == 36 && y == 36) || (x == 37 && y == 36) || (x == 38 && y == 36) || (x == 39 && y == 36) || (x == 40 && y == 36) || (x == 42 && y == 36) || (x == 69 && y == 36) || (x == 80 && y == 36) || (x == 29 && y == 37) || (x == 30 && y == 37) || (x == 31 && y == 37) || (x == 42 && y == 37) || (x == 68 && y == 37) || (x == 80 && y == 37) || (x == 28 && y == 38) || (x == 29 && y == 38) || (x == 42 && y == 38) || (x == 68 && y == 38) || (x == 80 && y == 38) || (x == 26 && y == 39) || (x == 27 && y == 39) || (x == 29 && y == 39) || (x == 42 && y == 39) || (x == 68 && y == 39) || (x == 80 && y == 39) || (x == 25 && y == 40) || (x == 29 && y == 40) || (x == 42 && y == 40) || (x == 68 && y == 40) || (x == 80 && y == 40) || (x == 24 && y == 41) || (x == 25 && y == 41) || (x == 29 && y == 41) || (x == 42 && y == 41) || (x == 68 && y == 41) || (x == 80 && y == 41) || (x == 24 && y == 42) || (x == 29 && y == 42) || (x == 42 && y == 42) || (x == 68 && y == 42) || (x == 79 && y == 42) || (x == 80 && y == 42) || (x == 23 && y == 43) || (x == 24 && y == 43) || (x == 29 && y == 43) || (x == 42 && y == 43) || (x == 68 && y == 43) || (x == 79 && y == 43) || (x == 23 && y == 44) || (x == 29 && y == 44) || (x == 42 && y == 44) || (x == 68 && y == 44) || (x == 79 && y == 44) || (x == 23 && y == 45) || (x == 29 && y == 45) || (x == 42 && y == 45) || (x == 43 && y == 45) || (x == 68 && y == 45) || (x == 79 && y == 45) || (x == 23 && y == 46) || (x == 28 && y == 46) || (x == 43 && y == 46) || (x == 68 && y == 46) || (x == 79 && y == 46) || (x == 22 && y == 47) || (x == 27 && y == 47) || (x == 28 && y == 47) || (x == 43 && y == 47) || (x == 68 && y == 47) || (x == 78 && y == 47) || (x == 22 && y == 48) || (x == 26 && y == 48) || (x == 43 && y == 48) || (x == 60 && y == 48) || (x == 68 && y == 48) || (x == 78 && y == 48) || (x == 22 && y == 49) || (x == 26 && y == 49) || (x == 43 && y == 49) || (x == 60 && y == 49) || (x == 68 && y == 49) || (x == 77 && y == 49) || (x == 78 && y == 49) || (x == 22 && y == 50) || (x == 26 && y == 50) || (x == 44 && y == 50) || (x == 60 && y == 50) || (x == 69 && y == 50) || (x == 77 && y == 50) || (x == 22 && y == 51) || (x == 26 && y == 51) || (x == 44 && y == 51) || (x == 60 && y == 51) || (x == 69 && y == 51) || (x == 76 && y == 51) || (x == 77 && y == 51) || (x == 22 && y == 52) || (x == 25 && y == 52) || (x == 44 && y == 52) || (x == 59 && y == 52) || (x == 69 && y == 52) || (x == 75 && y == 52) || (x == 76 && y == 52) || (x == 22 && y == 53) || (x == 24 && y == 53) || (x == 25 && y == 53) || (x == 45 && y == 53) || (x == 59 && y == 53) || (x == 69 && y == 53) || (x == 74 && y == 53) || (x == 75 && y == 53) || (x == 22 && y == 54) || (x == 23 && y == 54) || (x == 46 && y == 54) || (x == 47 && y == 54) || (x == 57 && y == 54) || (x == 58 && y == 54) || (x == 69 && y == 54) || (x == 73 && y == 54) || (x == 74 && y == 54) || (x == 47 && y == 55) || (x == 48 && y == 55) || (x == 49 && y == 55) || (x == 50 && y == 55) || (x == 55 && y == 55) || (x == 56 && y == 55) || (x == 69 && y == 55) || (x == 70 && y == 55) || (x == 71 && y == 55) || (x == 72 && y == 55) || (x == 50 && y == 56) || (x == 51 && y == 56) || (x == 52 && y == 56) || (x == 53 && y == 56) || (x == 54 && y == 56)))
        begin
            oled_data <= WHITE;
        end
        
        else begin
            oled_data <= 0;
        end
    end
    else begin
        oled_data <= 0;
    end
    end
    
endmodule