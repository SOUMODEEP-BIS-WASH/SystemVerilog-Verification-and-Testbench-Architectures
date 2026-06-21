`timescale 1ns/1ps

module RAM #(
    parameter N = 256
) (
    input rd_en,wr_en,clk,rst,
    input [$clog2(N)-1:0]wr_addr,rd_addr,
    input [7:0]wr_data,
    output reg [7:0]rd_data
);

reg [7:0]RAM[N-1:0];
integer i;
always @(posedge clk) begin
    if (rst) begin
        for(i=0;i<N;i=i+1) RAM[i]<=0;
        rd_data<=0;
    end
    else begin
        if (wr_en && rd_en && (wr_addr!=rd_addr)) begin RAM[wr_addr]<=wr_data; rd_data <=RAM[rd_addr]; end
        else if (wr_en) RAM[wr_addr]<=wr_data;
        else if (rd_en) rd_data<=RAM[rd_addr];
        else rd_data<=rd_data;
    end
end
endmodule