module shift #(parameter DELAY = 4)(
    input clk,
    input rst,
    input in,
    output out
); 

    wire _wire [DELAY:0];
    genvar i;
    generate
        for (i = 0; i<DELAY; i = i + 1) begin
            flipflop ff (.clk(clk),
                         .rst(rst),
                         .in(_wire[i]),
                         .out(_wire[i+1]));
        end
    endgenerate

    assign _wire[0]  = in;
    assign out = _wire[DELAY];
endmodule