module vending_machine (
    input clk,
    input rst,
    input [1:0] coin,
    output reg dispense,
    output reg [1:0] change
);

    // Coin encoding:
    // 2'b00 = No coin
    // 2'b01 = Rs. 5
    // 2'b10 = Rs. 10

    // State encoding
    parameter S0 = 2'b00;  // Rs. 0
    parameter S1 = 2'b01;  // Rs. 5
    parameter S2 = 2'b10;  // Rs. 10

    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state    <= S0;
            dispense <= 1'b0;
            change   <= 2'b00;
        end
        else begin
            // Default outputs for each clock cycle
            dispense <= 1'b0;
            change   <= 2'b00;

            case (state)

                S0: begin
                    if (coin == 2'b01)
                        state <= S1;
                    else if (coin == 2'b10)
                        state <= S2;
                end

                S1: begin
                    if (coin == 2'b01)
                        state <= S2;
                    else if (coin == 2'b10) begin
                        dispense <= 1'b1;
                        change   <= 2'b00;
                        state    <= S0;
                    end
                end

                S2: begin
                    if (coin == 2'b01) begin
                        dispense <= 1'b1;
                        change   <= 2'b00;
                        state    <= S0;
                    end
                    else if (coin == 2'b10) begin
                        dispense <= 1'b1;
                        change   <= 2'b01; // Return Rs. 5
                        state    <= S0;
                    end
                end

                default: state <= S0;

            endcase
        end
    end

endmodule
