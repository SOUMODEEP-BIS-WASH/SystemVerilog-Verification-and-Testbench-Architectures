`timescale 1ns / 1ps

//INTERFACE

interface intfc(input bit clk);

logic rst;
logic rd_en;
logic wr_en;
logic [7:0]wr_addr;
logic [7:0]rd_addr;
logic [7:0]wr_data;
logic [7:0]rd_data;

clocking cb @(posedge clk);

default input #1 output #1;

output rst,rd_en,wr_en;
output wr_addr,rd_addr,wr_data;
input rd_data;
endclocking

endinterface

//TRANSACTION

class transaction;
randc bit rst;
randc bit rd_en;
randc bit wr_en;
randc bit [7:0]wr_addr;
randc bit [7:0]rd_addr;
randc bit [7:0]wr_data;
bit [7:0]rd_data;

constraint C1{rd_en||wr_en;}

constraint C2{if(rd_en && wr_en) rd_addr!=wr_addr;}

endclass

//GENERATOR

class generator;
transaction t1;
mailbox #(transaction) mbx1;

function new(input mailbox #(transaction) mbx);
mbx1=mbx;
endfunction

task work();
t1=new();
t1.randomize();
mbx1.put(t1);
endtask

endclass

//DRIVER

//DRIVER

class driver;
virtual intfc int1;
transaction t1;
mailbox #(transaction) mbx1;

function new(input virtual intfc in,input mailbox #(transaction) mbx);
int1=in;
mbx1=mbx;
endfunction

task work();
mbx1.get(t1);
int1.cb.rst<=t1.rst;
int1.cb.rd_en<=t1.rd_en;
int1.cb.wr_en<=t1.wr_en;
int1.cb.wr_addr<=t1.wr_addr;
int1.cb.rd_addr<=t1.rd_addr;
int1.cb.wr_data<=t1.wr_data;
endtask
endclass

//MONITOR

class monitor;
    virtual intfc int1;
    transaction t2 = new();
    mailbox #(transaction) mbx2;

    // ---------------- COVERAGE ----------------
    covergroup ram_cvg;
        CP_WR_EN   : coverpoint t2.wr_en;
        CP_RD_EN   : coverpoint t2.rd_en;
        CP_ADDR_WR : coverpoint t2.wr_addr { bins low = {[0:63]}; bins mid = {[64:127]}; bins high = {[128:255]}; }
        CP_ADDR_RD : coverpoint t2.rd_addr { bins low = {[0:63]}; bins mid = {[64:127]}; bins high = {[128:255]}; }
        CP_DATA    : coverpoint t2.wr_data { bins low = {[0:63]}; bins mid = {[64:127]}; bins high = {[128:255]} ;}
        CP_RESET   : coverpoint t2.rst;

        CROSS_OP : cross CP_WR_EN, CP_RD_EN;
        CROSS_ADDR : cross CP_ADDR_WR, CP_ADDR_RD;
    endgroup
    // ------------------------------------------

    function new(input virtual intfc in, input mailbox #(transaction) mbx);
        int1 = in;
        mbx2 = mbx;
        ram_cvg = new();
    endfunction

    task work();
        // Sample from clocking block — no @(posedge clk)
        t2.rst     = int1.rst;
        t2.wr_en   = int1.wr_en;
        t2.rd_en   = int1.rd_en;
        t2.wr_addr = int1.wr_addr;
        t2.rd_addr = int1.rd_addr;
        t2.wr_data = int1.wr_data;
        t2.rd_data = int1.cb.rd_data;

        ram_cvg.sample();
        mbx2.put(t2);
    endtask
endclass

//SCOREBOARD

class scoreboard;

    mailbox #(transaction) mbx2;
    transaction t2;

    // Reference model memory
    byte ref_mem [0:255];

    function new(input mailbox #(transaction) mbx);
        mbx2 = mbx;
        t2 = new();

        // initialize model
        foreach (ref_mem[i])
            ref_mem[i] = 0;
    endfunction

    task work();
        mbx2.get(t2);

        // Handle reset
        if (t2.rst) begin
            foreach (ref_mem[i])
                ref_mem[i] = 0;
            return;
        end

        // ---------------- Reference model update ----------------
        if (t2.wr_en && (t2.wr_addr != t2.rd_addr)) begin
            ref_mem[t2.wr_addr] = t2.wr_data;
        end

        // ---------------- Checking read data -------------------
        if (t2.rd_en && (t2.wr_addr != t2.rd_addr)) begin
            if (t2.rd_data !== ref_mem[t2.rd_addr]) begin
                $display("|TIME=%0t| ❌ FAIL | RD_ADDR=%0d | EXP=%0h | GOT=%0h |",
                          $time, t2.rd_addr, ref_mem[t2.rd_addr], t2.rd_data);
            end
            else begin
                $display("|TIME=%0t| ✅ PASS | RD_ADDR=%0d | DATA=%0h |",
                          $time, t2.rd_addr, t2.rd_data);
            end
        end
        $display("TIME = %t | WR_DATA = %0d | RD_DATA = %0d | RD_ADDR = %0d | WR_ADDR = %0d | RD_EN = %b | WR_EN = %b | RST =%b |",$time,t2.wr_data,t2.rd_data,t2.rd_addr,t2.wr_addr,t2.rd_en,t2.wr_en,t2.rst);
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
virtual intfc intf;

function new(input virtual intfc in);
    intf = in;
    gen= new(mbx1);
    drv = new(intf,mbx1);
    mon = new(intf,mbx2);
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
virtual intfc intf;

function new(input virtual intfc in);
intf=in;
env=new(intf);
endfunction

task work();
env.work();
endtask

endclass

//TOP MODULE
module tb;

    bit clk = 0;

    // Interface with clocking block
    intfc intf(clk);

    // DUT
    RAM DUT (
        .clk     (intf.clk),
        .rst     (intf.rst),
        .wr_en   (intf.wr_en),
        .rd_en   (intf.rd_en),
        .wr_addr (intf.wr_addr),
        .rd_addr (intf.rd_addr),
        .wr_data (intf.wr_data),
        .rd_data (intf.rd_data)
    );

    // Test
    test t = new(intf);

    // Clock
    always #5 clk = ~clk;

    initial begin
        $display("========== SRAM VERIFICATION START ==========");

        // Run the test (environment runs forever)
        repeat(50) begin t.work(); #10;end

        // Let simulation run for some cycles
        //#1000;

        $display("========== COVERAGE REPORT ==========");
        $display("Functional Coverage = %0.2f %%", $get_coverage());

        $finish;
    end

endmodule

