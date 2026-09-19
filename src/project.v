`default_nettype none

parameter LOGO_WIDTH = 128;
parameter LOGO_HEIGHT = 80;
parameter DISPLAY_WIDTH = 640;
parameter DISPLAY_HEIGHT = 480;

module tt_um_vga_example (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,      
    input  wire       clk,      
    input  wire       rst_n     
);

  wire hsync;
  wire vsync;
  reg [1:0] R;
  reg [1:0] G;
  reg [1:0] B;
  wire video_active;
  wire [9:0] pix_x;
  wire [9:0] pix_y;

  assign uo_out  = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};
  assign uio_out = 0;
  assign uio_oe  = 0;
  
  wire _unused_ok = &{ena, ui_in, uio_in};

  reg [9:0] prev_y;

  hvsync_generator vga_sync_gen (
      .clk(clk),
      .reset(~rst_n),
      .hsync(hsync),
      .vsync(vsync),
      .display_on(video_active),
      .hpos(pix_x),
      .vpos(pix_y)
  );

  reg [9:0] logo_left;
  reg [9:0] logo_top;
  reg dir_x;
  reg dir_y;

  wire pixel_value;
  reg [2:0] color_index;
  wire [5:0] color;

  wire [9:0] x = pix_x - logo_left;
  wire [9:0] y = pix_y - logo_top;
  
  wire is_within_logo_x = (pix_x >= logo_left) && (pix_x < logo_left + LOGO_WIDTH);
  wire is_within_logo_y = (pix_y >= logo_top) && (pix_y < logo_top + LOGO_HEIGHT);
  wire logo_pixels = is_within_logo_x && is_within_logo_y;

  // Draw a 2-pixel wide border at the absolute edges of the 640x480 screen
  wire draw_screen_border = (pix_x < 2) || (pix_x >= DISPLAY_WIDTH - 2) || 
                            (pix_y < 2) || (pix_y >= DISPLAY_HEIGHT - 2);

  bitmap_rom rom1 (
      .x(x[6:0]),
      .y(y[6:0]),
      .pixel(pixel_value)
  );

  palette palette_inst (
      .color_index(color_index),
      .rrggbb(color)
  );

  always @(posedge clk) begin
    if (~rst_n) begin
      R <= 0;
      G <= 0;
      B <= 0;
    end else begin
      R <= 0;
      G <= 0;
      B <= 0;
      if (video_active) begin
        if (draw_screen_border) begin
          // Render white border at screen edges
          R <= 2'b11;
          G <= 2'b11;
          B <= 2'b11;
        end else if (logo_pixels) begin
          // Render logo inside bounds
          R <= pixel_value ? color[5:4] : 0;
          G <= pixel_value ? color[3:2] : 0;
          B <= pixel_value ? color[1:0] : 0;
        end
      end
    end
  end

  always @(posedge clk) begin
    if (~rst_n) begin
      logo_left <= 200;
      logo_top <= 200;
      dir_y <= 0;
      dir_x <= 1;
      color_index <= 0;
      prev_y <= 0;
    end else begin
      prev_y <= pix_y;
      
      if (pix_y == 0 && prev_y != 0) begin
        
        // Horizontal Bounce
        if (logo_left == 0 && !dir_x) begin
          dir_x <= 1;
          color_index <= color_index + 1;
          logo_left <= 1;
        end else if (logo_left >= DISPLAY_WIDTH - LOGO_WIDTH && dir_x) begin
          dir_x <= 0;
          color_index <= color_index + 1;
          logo_left <= DISPLAY_WIDTH - LOGO_WIDTH - 1;
        end else begin
          logo_left <= logo_left + (dir_x ? 1 : -1);
        end

        // Vertical Bounce
        if (logo_top == 0 && !dir_y) begin
          dir_y <= 1;
          color_index <= color_index + 1;
          logo_top <= 1;
        end else if (logo_top >= DISPLAY_HEIGHT - LOGO_HEIGHT && dir_y) begin
          dir_y <= 0;
          color_index <= color_index + 1;
          logo_top <= DISPLAY_HEIGHT - LOGO_HEIGHT - 1;
        end else begin
          logo_top <= logo_top + (dir_y ? 1 : -1);
        end

      end
    end
  end

endmodule