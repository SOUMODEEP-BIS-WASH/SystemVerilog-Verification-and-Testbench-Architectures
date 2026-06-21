`timescale 1ns / 1ps

//INTERFACE

interface fifint(input bit clk,rst);

logic [7:0]din;
logic rd_en,wr_en;
logic full,empty;
logic [7:0]dout;

clocking dcb @(posedge clk);
default input #(1) output #(1);
output rd_en, wr_en,din;
input full,empty,dout;
endclocking

clocking mcb @(posedge clk);
default input #(1) output #(1);
input rd_en, wr_en,din;
input full,empty,dout;
endclocking


endinterface

//TRANSACTION
class transaction;
    randc bit [7:0]din;
    bit rd_en,wr_en;
    bit full,empty;
    bit [7:0]dout;
    constraint c1{if(wr_en==1) din inside {[0:255]};} 
endclass

//GENERATOR
class generator;
transaction t1;
mailbox #(transaction) mbx1;

function new(input mailbox #(transaction) mbx);
    mbx1=mbx;
endfunction

task rd_work();
t1=new();
t1.rd_en=1;
t1.wr_en=0;
t1.randomize();
mbx1.put(t1);
endtask

task wr_work();
t1=new();
t1.rd_en=0;
t1.wr_en=1;
t1.randomize();
mbx1.put(t1);
endtask
endclass

//DRIVER
class driver;
    transaction t1;
    mailbox #(transaction) mbx1;
    virtual fifint intc;
    
    function new(input virtual fifint intf,input mailbox #(transaction) mbx);
    intc=intf;
    mbx1=mbx;
    endfunction
    
    task work();
    t1=new();
    mbx1.get(t1);
    @(intc.dcb);
    intc.dcb.din<=t1.din;
    intc.dcb.wr_en<=t1.wr_en;
    intc.dcb.rd_en<=t1.rd_en;
    
    endtask
endclass

//MONITOR

class monitor;
transaction t2;
mailbox #(transaction) mbx2;
virtual fifint intc;

covergroup fifcvg;
 WR: coverpoint t2.din{bins HALF1={[0:127]}; bins HALF2={[128:255]};}
 WR_EN: coverpoint t2.wr_en;
 RD_EN: coverpoint t2.rd_en;
 cross WR_EN,WR;
endgroup


function new(input virtual fifint intf,input mailbox #(transaction) mbx);
    intc=intf;
    mbx2=mbx;
        fifcvg=new();
endfunction

task work();
    t2=new();
    @(intc.mcb)
    t2.din = intc.mcb.din;
    t2.wr_en = intc.mcb.wr_en;
    t2.rd_en = intc.mcb.rd_en;
    t2.full = intc.mcb.full;
    t2.empty = intc.mcb.empty;
    @(intc.mcb)
    t2.dout = intc.mcb.dout;
     fifcvg.sample();
     mbx2.put(t2);
endtask
    
endclass

// SCOREBOARD

class scoreboard;
transaction t2;
mailbox #(transaction) mbx2;

bit [7:0]ref_mem[255:0];
bit [7:0]ref_wr;
bit [7:0]ref_rd;
bit [7:0]ref_dout;


function new(input mailbox #(transaction) mbx);
    mbx2=mbx;

endfunction

function reference(input bit [7:0]din, input bit wr_en, input rd_en, input bit full, input bit empty);
    if(wr_en && !full)begin ref_mem[ref_wr[7:0]]=din; ref_wr = ref_wr+1; end
    if(rd_en && !empty) begin ref_dout=ref_mem[ref_rd[7:0]]; ref_rd=ref_rd+1; end
    return ref_dout;
endfunction

task work();
 t2=new();
 mbx2.get(t2);
 reference(t2.din,t2.wr_en,t2.rd_en,t2.full,t2.empty);
 $display("TIME = %t | Din = %0d | WR_EN = %b | RD_EN = %b | FULL = %b | EMPTY = %b | DOUT = %0d",$time,t2.din,t2.wr_en,t2.rd_en,t2.full,t2.empty,t2.dout);
 if(t2.rd_en && (ref_dout==t2.dout)) $display("=============| PASS FOR READ WITH ACTUAL = %0d & EXPECTED = %0d |================",t2.dout,ref_dout);
 else if(t2.rd_en && (ref_dout!=t2.dout)) $display("=============| FAIL FOR READ WITH ACTUAL = %0d & EXPECTED = %0d |================",t2.dout,ref_dout);

endtask

endclass

//ENVIRONMENT

class environment;
generator gen;
driver drv;
monitor mon;
scoreboard sb;

mailbox #(transaction) mbx1=new();
mailbox #(transaction) mbx2=new();

virtual fifint intc;

function new(input virtual fifint intf);
    intc=intf;
    gen=new(mbx1);
    drv=new(intc,mbx1);
    mon=new(intc,mbx2);
    sb=new(mbx2);
endfunction

task rd_work();
gen.rd_work();
drv.work();
mon.work();
sb.work();
endtask

task wr_work();
gen.wr_work();
drv.work();
mon.work();
sb.work();
endtask

endclass

//TEST

class test;

environment env;

virtual fifint intc;

function new(input virtual fifint intf);
    intc=intf;
    env = new(intc);
endfunction;

task work();
 $display("====================| SCOREBOARD |======================");
 repeat(9) begin
 env.wr_work(); #10;
 env.rd_work(); #10;
 end
 $display("========================================================");
 $display("COVERAGE = %.2f %%",$get_coverage());
endtask


endclass

// TOP MODULE

module tb;
bit clk=0;
bit rst;

fifint intc(clk,rst);

sync_FIFO DUT(.din(intc.din),.rd_en(intc.rd_en),.wr_en(intc.wr_en),.clk(intc.clk),.rst(intc.rst),.full(intc.full),.empty(intc.empty),.dout(intc.dout));
test t=new(intc);

always #5 clk=~clk;

initial begin
rst=1;#10;
rst=0;
$display("===========| START OF VERIFICATION AT %0t |============",$time);
t.work();
$display("===========| END OF VERIFICATION AT %0t |============",$time);
$finish;
end
endmodule
