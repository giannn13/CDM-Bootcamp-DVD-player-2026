`default_nettype none

module bitmap_rom (
    input wire [6:0] x,
    input wire [6:0] y,
    output wire pixel
);

  // Draw First 'D' (x: 16 to 40, y: 16 to 56)
  wire D1_outer = (x >= 16 && x <= 40 && y >= 16 && y <= 56);
  wire D1_inner = (x >= 24 && x <= 32 && y >= 24 && y <= 48);
  wire draw_D1  = D1_outer && !D1_inner;

  // Draw 'V' (x: 48 to 72, y: 16 to 56)
  wire V_left   = (x >= 48 && x <= 56 && y >= 16 && y <= 40);
  wire V_right  = (x >= 64 && x <= 72 && y >= 16 && y <= 40);
  wire V_bottom = (x >= 56 && x <= 64 && y >= 40 && y <= 56);
  wire draw_V   = V_left || V_right || V_bottom;

  // Draw Second 'D' (x: 80 to 104, y: 16 to 56)
  wire D2_outer = (x >= 80 && x <= 104 && y >= 16 && y <= 56);
  wire D2_inner = (x >= 88 && x <= 96 && y >= 24 && y <= 48);
  wire draw_D2  = D2_outer && !D2_inner;

  // Draw Underline (x: 16 to 104, y: 64 to 72)
  wire draw_underline = (x >= 16 && x <= 104 && y >= 64 && y <= 72);

  // Combine shapes to output the final white pixel
  assign pixel = draw_D1 | draw_V | draw_D2 | draw_underline;

endmodule