`timescale 1ns / 1ps


//INTERFACE DEFINITION

interface intf(input clk);
    logic [3:0]a,b;
    logic cin;
    logic [3:0]sum;
    logic cout;
endinterface

//COMPONENT 1: TRANSACTION

class transaction;
    randc bit [3:0]a,b;
    randc bit cin;
    bit [3:0]sum;
    bit cout;
endclass

//COMPONENT 2: GENERATOR

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

//COMPONENT 3: DRIVER

class driver;
    transaction t1=new();
    mailbox #(transaction) mbx1;
    virtual intf vif1;
    
    function new(input virtual intf intf1, input mailbox #(transaction) mbx);
    vif1 = intf1;
    mbx1=mbx;
    endfunction
    
    task work();
    mbx1.get(t1);
    vif1.a = t1.a;
    vif1.b = t1.b;
    vif1.cin = t1.cin;
    endtask;
endclass

//COMPONENT 4: MONITOR

class monitor;
    transaction t2=new();
    virtual intf vif2;
    mailbox #(transaction) mbx2;
    
    function new(input virtual intf intf2,input mailbox #(transaction) mbx);
    mbx2=mbx;
    vif2=intf2;
    endfunction
    
    task work();
    #0;
    t2.a = vif2.a;
    t2.b = vif2.b;
    t2.cin = vif2.cin;
    t2.sum = vif2.sum;
    t2.cout = vif2.cout;
    mbx2.put(t2);
    endtask
endclass

//COMPONENT 5: SCOREBOARD

class scoreboard;
    transaction t2 = new();
    mailbox #(transaction) mbx2;
    bit [4:0] exp_sum;
    function new(input mailbox #(transaction) mbx);
    mbx2=mbx;
    endfunction
    
    function add(input bit [3:0]a, input bit [3:0]b, input bit cin, output bit [4:0]sum);
    sum = a+b+cin;
    return sum;
    endfunction
    
    task work();
    mbx2.get(t2);
    add(t2.a,t2.b,t2.cin,exp_sum);
    if({t2.cout,t2.sum}==exp_sum) $display("||TIME = %t|| PASS FOR: | A = %4b | B = %4b | Cin =%b | SUM = %4b | Cout = %b | EXPECTED = %5b |",$time,t2.a,t2.b,t2.cin,t2.sum,t2.cout,exp_sum);
    else $display("||TIME = %t|| FAIL FOR: | A = %4b | B = %4b | Cin =%b | SUM = %4b | Cout = %b | EXPECTED = %5b |",$time,t2.a,t2.b,t2.cin,t2.sum,t2.cout,exp_sum);
    endtask
endclass

// ENVIRONMENT

class environment;
    
    generator gen;
    driver driv;
    monitor mon;
    scoreboard sb;
    
    mailbox #(transaction) mbx1=new();
    mailbox #(transaction) mbx2=new();
    
    virtual intf vif;
        
    function new(input virtual intf intf1);
    vif = intf1;
    gen=new(mbx1);
    driv=new(vif,mbx1);
    mon=new(vif,mbx2);
    sb=new(mbx2);
    endfunction
    
    task work();
    gen.work();
    driv.work();
    mon.work();
    sb.work();
    endtask
endclass

// TEST CLASS

class test;

environment env;
virtual intf vif;
function new(input virtual intf intf1);
vif = intf1;
env=new(vif);
endfunction

task work();
env.work();
endtask

endclass

//TOP MODULE 

module tb_arch;
bit clk=0;
intf intf1(clk);
adder DUT(.a(intf1.a),.b(intf1.b),.cin(intf1.cin),.sum(intf1.sum),.cout(intf1.cout));
test t = new(intf1);
always #5 clk=~clk;
initial begin
$display("=========SCOREBOARD=========");
repeat(5) begin
t.work();#5;
end
end
endmodule
