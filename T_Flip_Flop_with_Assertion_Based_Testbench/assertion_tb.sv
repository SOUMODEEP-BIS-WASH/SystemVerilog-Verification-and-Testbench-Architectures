`timescale 1ns / 1ps

//INTERFACE

interface intf(input bit clk);
logic T,rst;
logic Q;
endinterface

//ASSERTION

module tff_assertions(intf intfc);



//always @(posedge intfc.clk) past_q <= intfc.Q;
property toggle;
bit past_q;
@(posedge intfc.clk) disable iff(intfc.rst)
(intfc.T==1,past_q=intfc.Q)|=> (intfc.Q)==! past_q;
endproperty

assert property(toggle) $display("TOGGLE TEST PASSED AT TIME = %t",$time);
else $display("ERROR AT TOGGLE AT TIME = %t",$time);


property hold;
logic past_q;
@(posedge intfc.clk) disable iff(intfc.rst)
(intfc.T==0,past_q=intfc.Q)|=>(intfc.Q)===past_q;
endproperty

assert property(hold) $display("HOLD TEST PASSED AT TIME = %t",$time);
else $display("ERROR AT HOLD AT TIME = %t",$time);

property reset;
@(posedge intfc.clk) (intfc.rst)|-> (intfc.Q==0);
endproperty

assert property(reset) $display("RESET TEST PASSED AT TIME = %t",$time);
else $display("ERROR AT RESET AT TIME = %t",$time);



endmodule

//TOGGLE TRANSACTION 

class toggle_trans;
randc bit T;
constraint c1{T inside {0,1};}
endclass

//TOP MODULE

module assertion_tb;
bit clk;
intf intfc(clk);
TFF DUT(.T(intfc.T),.clk(intfc.clk),.rst(intfc.rst),.Q(intfc.Q));
tff_assertions tffa(intfc);
toggle_trans t=new();


always #5 clk=~clk;

initial begin
$display("=======================================================");
$display("====== START OF VERIFICATION AT TIME = %t =========",$time);
$display("=======================================================");
$display("=======================SCOREBOARD======================");

$monitor("TIME = %t | RST = %0b | T = %0b | Q = %0b",$time,intfc.rst,intfc.T,intfc.Q);

//$display("TIME = %t | RST = %0b | T = %0b | Q = %0b",$time,intfc.rst,intfc.T,intfc.Q);
intfc.rst=1;intfc.T=0;#10;
//$display("TIME = %t | RST = %0b | T = %0b | Q = %0b",$time,intfc.rst,intfc.T,intfc.Q);
//#5;
intfc.rst=0;//#5;
//$display("TIME = %t | RST = %0b | T = %0b | Q = %0b",$time,intfc.rst,intfc.T,intfc.Q);
//#5;
fork
//repeat(5) @(posedge intfc.clk) 
repeat(5) begin
t.randomize();
intfc.T=t.T;#10;
//$display("TIME = %t | RST = %0b | T = %0b | Q = %0b",$time,intfc.rst,intfc.T,intfc.Q);
end
join
$display("=======================================================");
$display("====== END OF VERIFICATION AT TIME = %t =========",$time);
$display("=======================================================");
$finish;

end

endmodule
