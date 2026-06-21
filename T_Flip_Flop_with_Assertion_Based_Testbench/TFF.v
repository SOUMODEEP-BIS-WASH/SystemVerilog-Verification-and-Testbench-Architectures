`timescale 1ns / 1ps

module TFF(
    input T, clk,rst,
    output reg Q
    );
    
    always @(posedge clk or posedge rst) 
    begin 
        if(rst) Q<=0;
        else if(T) Q<=~Q;
        else Q<=Q;
        
    end
    
endmodule
