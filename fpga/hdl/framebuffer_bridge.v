// Avalon-MM slave exposing a dual-port indexed-color framebuffer.
// Port A: HPS writes via lightweight bridge.
// Port B: VGA scanout reads at pixel clock.
module framebuffer_bridge #(
    parameter FB_WIDTH  = 256,
    parameter FB_HEIGHT = 240,
    parameter ADDR_WIDTH = 16
)(
    input  wire        clk,
    input  wire        reset,

    // Avalon-MM slave (HPS lightweight bridge)
    input  wire [1:0]  avs_address,
    input  wire        avs_read,
    input  wire        avs_write,
    input  wire [31:0] avs_writedata,
    output reg  [31:0] avs_readdata,
    input  wire [3:0]  avs_byteenable,

    // VGA read port
    input  wire        vga_clk,
    input  wire [ADDR_WIDTH-1:0] vga_addr,
    output reg  [3:0]  vga_color
);

    localparam FB_PIXELS = FB_WIDTH * FB_HEIGHT;
    localparam FB_BYTES  = (FB_PIXELS + 1) / 2;

    reg [7:0] fb_mem [0:FB_BYTES-1];

    reg [ADDR_WIDTH-1:0] hps_pixel_addr;
    reg [3:0]            hps_color;
    reg                  hps_write_req;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hps_pixel_addr <= {ADDR_WIDTH{1'b0}};
            hps_color      <= 4'h0;
            hps_write_req  <= 1'b0;
            avs_readdata   <= 32'h0;
        end else begin
            hps_write_req <= 1'b0;

            if (avs_write) begin
                case (avs_address)
                    2'd0: hps_pixel_addr <= avs_writedata[ADDR_WIDTH-1:0];
                    2'd1: begin
                        hps_color     <= avs_writedata[3:0];
                        hps_write_req <= 1'b1;
                    end
                    default: ;
                endcase
            end

            if (avs_read) begin
                case (avs_address)
                    2'd0: avs_readdata <= {17'h0, hps_pixel_addr};
                    2'd1: avs_readdata <= {28'h0, hps_color};
                    2'd2: avs_readdata <= 32'h1;
                    default: avs_readdata <= 32'h0;
                endcase
            end

            if (hps_write_req) begin
                if (hps_pixel_addr < FB_PIXELS) begin
                    if (hps_pixel_addr[0] == 1'b0)
                        fb_mem[hps_pixel_addr[ADDR_WIDTH-1:1]][3:0] <= hps_color;
                    else
                        fb_mem[hps_pixel_addr[ADDR_WIDTH-1:1]][7:4] <= hps_color;
                end
                hps_pixel_addr <= hps_pixel_addr + 1'b1;
            end
        end
    end

    always @(posedge vga_clk) begin
        if (vga_addr < FB_PIXELS) begin
            if (vga_addr[0] == 1'b0)
                vga_color <= fb_mem[vga_addr[ADDR_WIDTH-1:1]][3:0];
            else
                vga_color <= fb_mem[vga_addr[ADDR_WIDTH-1:1]][7:4];
        end else begin
            vga_color <= 4'h0;
        end
    end

endmodule
