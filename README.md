![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout DVD Player Screensaver

This project implements a hardware-accelerated, classic **bouncing DVD logo screensaver** designed for a VGA-driven FPGA/ASIC environment (such as Tiny Tapeout and VGA Playground). 

- [Read the documentation for project](docs/info.md)

---

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

---

## How it works

The design renders a smooth, real-time bouncing animation onto a standard 640x480 VGA display. Key architectural blocks include:

1. **VGA Timing Generation (`hvsync_generator.v`)**: Drives standard 640x480 resolution video timing signals (`hsync`, `vsync`, and active video boundaries).
2. **Bitmap ROM (`bitmap_rom.v`)**: Stores the graphical asset of the logo (`128x80` pixels), mapping coordinates dynamically to output pixel values.
3. **Color Palette Lookup (`palette.v`)**: Translates a color index into vibrant 2-bit per channel RGB (`rrggbb`) color outputs. 
4. **Collision & Motion Physics**: 
   * Continuously tracks the logo's top-left coordinates (`logo_left`, `logo_top`).
   * Evaluates boundary collisions against the screen dimensions (`640x480`) and a 2-pixel wide perimeter screen border.
   * Reverses horizontal (`dir_x`) and vertical (`dir_y`) directions instantly upon hitting a wall, while automatically cycling the color palette index on every wall bounce.
5. **Interactive Controls (`ui_in`)**:
   * **`ui_in[0]`**: Acts as a pause/run toggle to freeze or resume the animation.
   * **`ui_in[1]`**: Triggers a manual board/position reset.

---

## How to test

1. **Hardware Connection**:
   * Connect a VGA monitor or compatible screen to the **TinyVGA PMOD** output pins.
2. **Simulation / Execution**:
   * Apply power or release the reset line (`rst_n` high).
   * A framed 640x480 display area will appear with a 2-pixel white border.
   * The custom logo will automatically bounce across the screen, shifting colors each time it ricochets off a corner or wall edge.
3. **Using Inputs**:
   * Toggle **`ui_in[0]`** to pause or unpause the movement.
   * Toggle **`ui_in[1]`** to reset or randomize the layout state.

---

## External hardware

- **VGA Display / Monitor**: Connected via the TinyVGA PMOD interface (`HSync`, `VSync`, and 6-bit RGB outputs `uo[7:0]`).
- **Toggle Switches (`ui_in`)**: Connected to pins `ui_in[0]` (Pause/Run) and `ui_in[1]` (Reset/Randomize).

---

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://www.www.tinytapeout.com/guides/local-hardening/)

---

## What next?

- [Submit your design to the next shuttle](https://app.tinytapeout.com/).
- Share your project on your social network of choice:
  - LinkedIn [#tinytapeout](https://www.linkedin.com/search/results/content/?keywords=%23tinytapeout) [@TinyTapeout](https://www.linkedin.com/company/100708654/)
  - Mastodon [#tinytapeout](https://chaos.social/tags/tinytapeout) [@matthewvenn](https://chaos.social/@matthewvenn)
  - X (formerly Twitter) [#tinytapeout](https://twitter.com/hashtag/tinytapeout) [@tinytapeout](https://twitter.com/tinytapeout)
  - Bluesky [@tinytapeout.com](https://bsky.app/profile/tinytapeout.com)
