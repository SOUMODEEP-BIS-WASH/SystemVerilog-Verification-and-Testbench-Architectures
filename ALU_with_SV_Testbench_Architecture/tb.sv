`timescale 1ns / 1ps

//INTERFACE

interface intf(input bit clk);
logic [3:0]a,b;
logic [2:0]s;
logic [7:0]y;
endinterface

//TRANSACTION

class transaction;
randc bit [3:0]a,b;
randc bit [2:0]s;
bit [7:0]y;
bit [7:0]exp;

constraint c1{if(s==3'b11)b!=0;}

constraint c2{a inside {[0:15]}; b inside {[0:15]};}

endclass

//GENERATOR

class generator;
transaction t1=new();
mailbox #(transaction) mbx1;

function new(input mailbox #(transaction) mbx);
mbx1=mbx;
endfunction

task work();
t1.randomize();
mbx1.put(t1);
endtask

endclass

//DRIVER

class driver;
virtual intf int1;
transaction t1 = new();
mailbox #(transaction) mbx1;

function new(input virtual intf in,input mailbox #(transaction) mbx);
int1=in;
mbx1=mbx;
endfunction

task work();
@(negedge int1.clk)
mbx1.get(t1);
int1.a<=t1.a;
int1.b<=t1.b;
int1.s<=t1.s;
endtask
endclass

//MONITOR

class monitor;
virtual intf int1;
transaction t2=new();
mailbox #(transaction) mbx2;

covergroup alu_cvg;
 C1 : coverpoint t2.a{bins LOW ={[0:5]}; bins MID = {[6:10]}; bins HIGH={[11:15]};}
 C2 : coverpoint t2.b{bins LOW ={[0:5]}; bins MID = {[6:10]}; bins HIGH={[11:15]};}
 C3 : coverpoint t2.s{bins ARTH ={[0:3]}; bins LOG = {[4:7]};}
 cross C1,C2,C3;
endgroup

function new(input virtual intf in,input mailbox #(transaction) mbx);
int1=in;
mbx2=mbx;
alu_cvg=new();
endfunction

task work();
@(posedge int1.clk)
t2.a=int1.a;
t2.b=int1.b;
t2.s=int1.s;
t2.y=int1.y;
alu_cvg.sample();
mbx2.put(t2);
endtask

endclass

//SCOREBOARD

class scoreboard;
transaction t2=new();
mailbox #(transaction) mbx2;

function new(input mailbox #(transaction) mbx);
mbx2=mbx;
endfunction

function model(input transaction t);
case (t.s)
    3'b000: begin t.exp = t.a + t.b; return t.exp; end
    3'b001: begin t.exp[4:0] = t.a - t.b; t.exp[7:5] = 3'b000; return t.exp; end
    3'b010: begin t.exp = t.a * t.b; return t.exp; end
    3'b011: begin t.exp = t.a / t.b; return t.exp; end
    3'b100: begin t.exp[3:0] = t.a & t.b; t.exp[7:4]=4'b0000; return t.exp; end
    3'b101: begin t.exp[3:0] = t.a | t.b; t.exp[7:4]=4'b0000; return t.exp; end
    3'b110: begin t.exp[3:0] = ~(t.a & t.b); t.exp[7:4]=4'b0000;return t.exp; end
    3'b111: begin t.exp[3:0] = ~(t.a | t.b); t.exp[7:4]=4'b0000; return t.exp; end
    default: begin t.exp = t.exp; return t.exp; end  
endcase
endfunction

task work();
    mbx2.get(t2);
    model(t2);
    if(t2.exp==t2.y) $display("|TIME = %t | PASS FOR: | A = %4b | B = %4b | S = %3b | Y = %8b | EXPECTED = %8b |",$time,t2.a,t2.b,t2.s,t2.y,t2.exp);
    else $display("|TIME = %t | FAIL FOR: | A = %4b | B = %4b | S = %3b | Y = %8b | EXPECTED = %8b |",$time,t2.a,t2.b,t2.s,t2.y,t2.exp);
endtask

endclass

//ENVIRONMENT

class environment;
generator gen;
driver drv;
monitor mon;
scoreboard sb;

mailbox #(transaction) mbx1 = new();
mailbox #(transaction) mbx2 = new();
virtual intf intfc;

function new(input virtual intf in);
    intfc = in;
    gen= new(mbx1);
    drv = new(intfc,mbx1);
    mon = new(intfc,mbx2);
    sb = new(mbx2);
endfunction

task work();
 gen.work();
 drv.work();
 mon.work();
 sb.work();
endtask

endclass

//TEST
class test;
environment env;
virtual intf intfc;

function new(input virtual intf in);
intfc=in;
env=new(intfc);
endfunction

task work();
env.work();
endtask

endclass

//TOP MODULE

module tb;
bit clk=0;
intf intfc(clk);
alu DUT(.a(intfc.a),.b(intfc.b),.s(intfc.s),.y(intfc.y));
test t=new(intfc);

always #5 clk=~clk;

initial begin
$display("==============SCOREBOARD=============");
repeat(50)
begin
t.work();
end
$display("==============COVERAGE=============");
$display("FUNCTIONAL COVERAGE = %0.2f %%",$get_coverage());
end

endmodule
