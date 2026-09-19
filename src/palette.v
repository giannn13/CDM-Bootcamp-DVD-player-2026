`default_nettype none

module palette (
    input wire [2:0] color_index,
    output reg [5:0] rrggbb
);

  always @(*) begin
    case(color_index)
      3'd0: rrggbb = 6'b11_00_00; // Red
      3'd1: rrggbb = 6'b00_11_00; // Green
      3'd2: rrggbb = 6'b00_00_11; // Blue
      3'd3: rrggbb = 6'b11_11_00; // Yellow
      3'd4: rrggbb = 6'b11_00_11; // Magenta
      3'd5: rrggbb = 6'b00_11_11; // Cyan
      3'd6: rrggbb = 6'b11_11_11; // White
      3'd7: rrggbb = 6'b11_01_00; // Orange
    endcase
  end

endmodule