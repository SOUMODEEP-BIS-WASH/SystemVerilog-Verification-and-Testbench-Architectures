`timescale 1ns / 1ps

module sync_FIFO(
    input [7:0]din,
    input rd_en,wr_en,clk,rst,
    output full,empty,
    output reg [7:0]dout
    );
    
    reg [7:0]mem[255:0];
    reg [8:0]wr_addr;
    reg [8:0]rd_addr;
    integer i;
    always @(posedge clk or posedge rst) begin
    if (rst) begin
    wr_addr<=9'b00000_0000;
    rd_addr<=9'b00000_0000;
    dout<=8'b0000_0000;
    for(i=0;i<256;i=i+1) mem[i]<=0;
    end
    else begin
        //if(rd_en && wr_en && !full && !empty) begin mem[wr_addr[7:0]]<=din; dout<=mem[rd_addr[7:0]]; wr_addr <= wr_addr+1; rd_addr<=rd_addr+1; end
        if(wr_en && !full)begin mem[wr_addr[7:0]]<=din; wr_addr <= wr_addr+1; end
        if(rd_en && !empty) begin dout<=mem[rd_addr[7:0]]; rd_addr<=rd_addr+1; end
        //else begin dout<=dout; wr_addr<=wr_addr; rd_addr<=rd_addr; end
    end
    end
    assign full = ((wr_addr[8]!=rd_addr[8]) && (wr_addr[7:0]==rd_addr[7:0]))?1:0;
    assign empty = (wr_addr==rd_addr)?1:0;
endmodule
