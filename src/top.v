module tt_um_algofoogle_solo_squash(
    // 8 dedicated user inputs:
    input   wire [7:0]  ui_in,

    // 8 dedicated user outputs:
    output  wire [7:0]  uo_out,

    // 8 bidirectional user IOs:
    output  wire [7:0]  uio_in,     // Input path.
    output  wire [7:0]  uio_out,    // Output path.
    output  wire [7:0]  ui_oe,      // Enable path (active high: 0=input, 1=output)

    // Control:
    input   wire        ena,        // Can be ignored for now.
    input   wire        clk,        // 25.175MHz ideal, but 25.000MHz is good enough.
    input   wire        rst_n       // Active low reset
);

    // Hard-wire bidir IOs to just be inputs:
    assign ui_oe = 8'b0;

    // For test purposes, use unused outputs to loop back a couple of things:
    assign ui_out[5] = 0; //SMELL: Speaker is disabled for now because of a Yosys complaint.
    assign ui_out[6] = clk;
    assign ui_out[7] = ~ui_in[4]; // Unused input, just inverted for testing.

    solo_squash solo_squash(
        // --- Inputs ---
        .clk        (clk),
        .reset      (~rst_n),       // Active HIGH reset needed here.
        // Active-low control inputs (but pulled low by the chip BY DEFAULT when not pressed, so inverted here):
        .pause_n    (~ui_in[0]),
        .new_game_n (~ui_in[1]),
        .down_key_n (~ui_in[2]),
        .up_key_n   (~ui_in[3]),

        // --- Outputs ---
        .red        (ui_out[0]),
        .green      (ui_out[1]),
        .blue       (ui_out[2]),
        .hsync      (ui_out[3]),
        .vsync      (ui_out[4]),
        // .speaker    (ui_out[5]) //SMELL: Speaker is disabled for now because of a Yosys complaint.
    );

endmodule
