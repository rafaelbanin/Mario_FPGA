// Top-level: HPS SoC fabric + VGA pipeline for Super Mario DE10.
module SuperMario_top (
    input  wire        CLOCK_50,
    input  wire [3:0]  KEY,

    output wire        VGA_HS,
    output wire        VGA_VS,
    output wire        VGA_CLK,
    output wire        VGA_R,
    output wire        VGA_G,
    output wire        VGA_B,

    // HPS memory interface (connected to soc_system in Platform Designer)
    output wire [14:0] hps_memory_mem_a,
    output wire [2:0]  hps_memory_mem_ba,
    output wire        hps_memory_mem_ck,
    output wire        hps_memory_mem_ck_n,
    output wire        hps_memory_mem_cke,
    output wire        hps_memory_mem_cs_n,
    output wire        hps_memory_mem_dm,
    inout  wire [15:0] hps_memory_mem_dq,
    inout  wire [1:0]  hps_memory_mem_dqs,
    inout  wire [1:0]  hps_memory_mem_dqs_n,
    output wire        hps_memory_mem_odt,
    output wire        hps_memory_mem_ras_n,
    output wire        hps_memory_mem_reset_n,
    output wire        hps_memory_mem_we_n,

    output wire        hps_emac_md_clk,
    inout  wire        hps_emac_md_io,
    input  wire        hps_emac_rx_clk,
    input  wire        hps_emac_rx_dv,
    input  wire [3:0]  hps_emac_rx_d,
    input  wire        hps_emac_tx_clk,
    output wire        hps_emac_tx_en,
    output wire [3:0]  hps_emac_tx_d,

    inout  wire [3:0]  hps_qspi_io,
    output wire        hps_qspi_ss_n,
    input  wire        hps_sd_cmd,
    inout  wire [3:0]  hps_sd_data,
    input  wire        hps_sd_wp_n,
    input  wire        hps_uart_rx,
    output wire        hps_uart_tx,

    input  wire        hps_usb_clk,
    inout  wire [7:0]  hps_usb_data,
    input  wire [1:0]  hps_usb_addr,
    input  wire        hps_usb_nxt,
    input  wire        hps_usb_stp
);

    wire        reset;
    wire        video_on;
    wire [9:0]  pixel_row;
    wire [9:0]  pixel_column;
    wire        red, green, blue;

    wire [15:0] fb_addr;
    wire [3:0]  fb_color;

    assign reset = 1'b0;

    VGA_SYNC vga_sync_inst (
        .clock_50Mhz   (CLOCK_50),
        .red           (red),
        .green         (green),
        .blue          (blue),
        .red_out       (VGA_R),
        .green_out     (VGA_G),
        .blue_out      (VGA_B),
        .horiz_sync_out(VGA_HS),
        .vert_sync_out (VGA_VS),
        .video_on      (video_on),
        .pixel_clock   (VGA_CLK),
        .pixel_row     (pixel_row),
        .pixel_column  (pixel_column)
    );

    vga_scanout #(
        .FB_WIDTH (256),
        .FB_HEIGHT(240)
    ) scanout_inst (
        .pixel_row    (pixel_row),
        .pixel_column (pixel_column),
        .video_on     (video_on),
        .color_index  (fb_color),
        .red          (red),
        .green        (green),
        .blue         (blue),
        .fb_addr      (fb_addr),
        .fb_read_en   ()
    );

    soc_system u0 (
        .clk_clk                              (CLOCK_50),
        .reset_reset_n                        (~reset),
        .memory_mem_a                         (hps_memory_mem_a),
        .memory_mem_ba                        (hps_memory_mem_ba),
        .memory_mem_ck                        (hps_memory_mem_ck),
        .memory_mem_ck_n                      (hps_memory_mem_ck_n),
        .memory_mem_cke                       (hps_memory_mem_cke),
        .memory_mem_cs_n                      (hps_memory_mem_cs_n),
        .memory_mem_dm                        (hps_memory_mem_dm),
        .memory_mem_dq                        (hps_memory_mem_dq),
        .memory_mem_dqs                       (hps_memory_mem_dqs),
        .memory_mem_dqs_n                     (hps_memory_mem_dqs_n),
        .memory_mem_odt                       (hps_memory_mem_odt),
        .memory_mem_ras_n                     (hps_memory_mem_ras_n),
        .memory_mem_reset_n                   (hps_memory_mem_reset_n),
        .memory_mem_we_n                      (hps_memory_mem_we_n),
        .hps_0_hps_io_hps_io_gpio_inst        (),
        .emac_md_clk                          (hps_emac_md_clk),
        .emac_md_io                           (hps_emac_md_io),
        .emac_rx_clk                          (hps_emac_rx_clk),
        .emac_rx_dv                           (hps_emac_rx_dv),
        .emac_rx_d                            (hps_emac_rx_d),
        .emac_tx_clk                          (hps_emac_tx_clk),
        .emac_tx_en                           (hps_emac_tx_en),
        .emac_tx_d                            (hps_emac_tx_d),
        .qspi_io                              (hps_qspi_io),
        .qspi_ss_n                            (hps_qspi_ss_n),
        .sd_cmd                               (hps_sd_cmd),
        .sd_data                              (hps_sd_data),
        .sd_wp_n                              (hps_sd_wp_n),
        .uart_rx                              (hps_uart_rx),
        .uart_tx                              (hps_uart_tx),
        .usb_clk                              (hps_usb_clk),
        .usb_data                             (hps_usb_data),
        .usb_addr                             (hps_usb_addr),
        .usb_nxt                              (hps_usb_nxt),
        .usb_stp                              (hps_usb_stp),
        .key_pio_0_key_input_key_n            (KEY),
        .framebuffer_bridge_0_vga_vga_clk     (VGA_CLK),
        .framebuffer_bridge_0_vga_vga_addr    (fb_addr),
        .framebuffer_bridge_0_vga_vga_color   (fb_color)
    );

endmodule
