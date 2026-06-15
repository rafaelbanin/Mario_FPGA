// Simple PIO exposing debounced KEY inputs to the HPS lightweight bridge.
module key_pio (
    input  wire        clk,
    input  wire        reset,
    input  wire [3:0]  key_n,

    input  wire        avs_read,
    output reg  [31:0] avs_readdata
);

    reg [19:0] debounce_cnt [0:3];
    reg [3:0]  key_sync;
    reg [3:0]  key_stable;

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            key_sync   <= 4'hF;
            key_stable <= 4'hF;
            for (i = 0; i < 4; i = i + 1)
                debounce_cnt[i] <= 20'd0;
        end else begin
            key_sync <= key_n;

            for (i = 0; i < 4; i = i + 1) begin
                if (key_sync[i] != key_stable[i]) begin
                    if (debounce_cnt[i] == 20'd0)
                        key_stable[i] <= key_sync[i];
                    else
                        debounce_cnt[i] <= debounce_cnt[i] - 1'b1;
                end else begin
                    debounce_cnt[i] <= 20'd50000;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (avs_read)
            avs_readdata <= {28'h0, key_stable};
    end

endmodule
