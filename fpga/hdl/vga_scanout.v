// Maps 256x240 indexed framebuffer to 640x480 VGA with 2x scaling.
module vga_scanout #(
    parameter FB_WIDTH  = 256,
    parameter FB_HEIGHT = 240,
    parameter ADDR_WIDTH = 16,
    parameter H_OFFSET = 64
)(
    input  wire [9:0]  pixel_row,
    input  wire [9:0]  pixel_column,
    input  wire        video_on,
    input  wire [3:0]  color_index,
    output wire        red,
    output wire        green,
    output wire        blue,
    output wire [ADDR_WIDTH-1:0] fb_addr,
    output wire        fb_read_en
);

    wire [8:0] game_x = pixel_column[9:1] - H_OFFSET[8:0];
    wire [8:0] game_y = pixel_row[9:1];

    wire in_viewport =
        (pixel_column >= H_OFFSET) &&
        (pixel_column < (H_OFFSET + (FB_WIDTH << 1))) &&
        (pixel_row < (FB_HEIGHT << 1));

    assign fb_read_en = video_on & in_viewport;
    assign fb_addr    = {game_y, game_x};

    // Unified palette (see software/palette.h) - mono VGA MSB per channel
    reg red_r, green_r, blue_r;

    always @(*) begin
        case (color_index)
            4'h0:  begin red_r = 1'b0; green_r = 1'b0; blue_r = 1'b0; end // transparent/black
            4'h1:  begin red_r = 1'b0; green_r = 1'b0; blue_r = 1'b0; end // black
            4'h2:  begin red_r = 1'b0; green_r = 1'b0; blue_r = 1'b1; end // sky
            4'h3:  begin red_r = 1'b0; green_r = 1'b0; blue_r = 1'b1; end // mario blue
            4'h4:  begin red_r = 1'b1; green_r = 1'b0; blue_r = 1'b0; end // red
            4'h5:  begin red_r = 1'b1; green_r = 1'b1; blue_r = 1'b0; end // yellow
            4'h6:  begin red_r = 1'b0; green_r = 1'b1; blue_r = 1'b0; end // green light
            4'h7:  begin red_r = 1'b1; green_r = 1'b1; blue_r = 1'b0; end // goomba tan
            4'h8:  begin red_r = 1'b1; green_r = 1'b0; blue_r = 1'b0; end // brown dark
            4'h9:  begin red_r = 1'b1; green_r = 1'b1; blue_r = 1'b0; end // ground orange
            4'hA:  begin red_r = 1'b1; green_r = 1'b1; blue_r = 1'b0; end // brick light
            4'hB:  begin red_r = 1'b1; green_r = 1'b0; blue_r = 1'b0; end // brick dark
            4'hC:  begin red_r = 1'b1; green_r = 1'b1; blue_r = 1'b1; end // white
            4'hD:  begin red_r = 1'b0; green_r = 1'b1; blue_r = 1'b0; end // pipe green
            4'hE:  begin red_r = 1'b1; green_r = 1'b1; blue_r = 1'b0; end // skin
            4'hF:  begin red_r = 1'b0; green_r = 1'b1; blue_r = 1'b1; end // reserved cyan
            default: begin red_r = 1'b0; green_r = 1'b0; blue_r = 1'b0; end
        endcase
    end

    assign red   = red_r   & fb_read_en;
    assign green = green_r & fb_read_en;
    assign blue  = blue_r  & fb_read_en;

endmodule
