module disp_hex_mux
    (
        input  logic clk, reset,
        input  logic [3:0] hex7, hex6, hex5, hex4, hex3, hex2, hex1, hex0,  // hex digits
        input  logic [7:0] dp_in, // 8 decimal points
        output logic [7:0] an,  // enable 
        output logic [7:0] sseg // led segments
    );

    // constant declaration
    // refreshing rate around 800 Hz (50 MHz/2^16)
    localparam N = 18;
    // internal signal declaration
    logic [N-1:0] q_reg;
    logic [N-1:0] q_next;
    logic [3:0] hex_in;
    logic dp;

    // N-bit counter
    // register
    always_ff @(posedge clk,  posedge reset)
        if (reset)
            q_reg <= 0;
        else
            q_reg <= q_next;

    // next-state logic
    assign q_next = q_reg + 1;

    // 3 MSBs of counter to control 8-to-1 multiplexing
    // and to generate active-low enable signal
    always_comb
        case (q_reg[N-1:N-3])
            3'b000: begin
                    an = 8'b11111110;
                    hex_in = hex0;
                    dp = dp_in[0];
                end
            3'b001: begin
                    an =  8'b11111101;
                    hex_in = hex1;
                    dp = dp_in[1];
                end
            3'b010: begin
                    an =  8'b11111011;
                    hex_in = hex2;
                    dp = dp_in[2];
                end
            3'b011: begin
                    an =  8'b11110111;
                    hex_in = hex3;
                    dp = dp_in[3];
                end
            3'b100: begin
                    an =  8'b11101111;
                    hex_in = hex4;
                    dp = dp_in[4];
                end
            3'b101: begin
                    an =  8'b11011111;
                    hex_in = hex5;
                    dp = dp_in[5];
                end
            3'b110: begin
                    an =  8'b10111111;
                    hex_in = hex6;
                    dp = dp_in[6];
                end
            3'b111: begin
                    an =  8'b01111111;
                    hex_in = hex7;
                    dp = dp_in[7];
                end
        endcase

    // hex to seven-segment led display
    always_comb begin
       case(hex_in)
            4'h0: sseg[6:0] = 7'b1000000;
            4'h1: sseg[6:0] = 7'b1111001;
            4'h2: sseg[6:0] = 7'b0100100;
            4'h3: sseg[6:0] = 7'b0110000;
            4'h4: sseg[6:0] = 7'b0011001;
            4'h5: sseg[6:0] = 7'b0010010;
            4'h6: sseg[6:0] = 7'b0000010;
            4'h7: sseg[6:0] = 7'b1111000;
            4'h8: sseg[6:0] = 7'b0000000;
            4'h9: sseg[6:0] = 7'b0010000;
            4'ha: sseg[6:0] = 7'b0001000;
            4'hb: sseg[6:0] = 7'b0000011;
            4'hc: sseg[6:0] = 7'b1000110;
            4'hd: sseg[6:0] = 7'b0100001;
            4'he: sseg[6:0] = 7'b0000110;
            default: sseg[6:0] = 7'b0001110;  //4'hf
        endcase
      sseg[7] = dp;
    end
endmodule
