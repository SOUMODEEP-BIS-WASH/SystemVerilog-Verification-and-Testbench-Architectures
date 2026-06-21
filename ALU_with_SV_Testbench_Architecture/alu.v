`timescale 1ns / 1ps

module alu(
    input [3:0]a,b,
    input [2:0]s,
    output reg [7:0]y
    );
    
    always @(*) begin
    case (s)
    3'b000: y = a+b;
    3'b001: begin y[4:0] = a-b; y[7:5] = 3'b000; end
    3'b010: y = a*b;
    3'b011: y = a/b;
    3'b100: begin y[3:0] = a&b; y[7:4]=4'b0000; end
    3'b101: begin y[3:0] = a|b; y[7:4]=4'b0000; end
    3'b110: begin y[3:0] = ~(a&b); y[7:4]=4'b0000; end
    3'b111: begin y[3:0] = ~(a|b); y[7:4]=4'b0000; end
    default: y = y;    
    endcase
    end
    
endmodule
