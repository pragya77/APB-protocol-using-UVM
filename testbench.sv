
 import uvm_pkg::*;
 `include "uvm_macros.svh"

 `include "apb_transaction.sv"
 `include "apb_sequence.sv"
 `include "apb_sequencer.sv"
 `include "apb_driver.sv"
 `include "apb_monitor.sv"
 `include "apb_agent.sv"
 `include "apb_scoreboard.sv"
 `include "apb_env.sv"
 `include "apb_test.sv"

 module tb;

   	logic pclk;
   	logic rst_n;
   	logic [31:0] paddr;
   	logic        psel;
   	logic        penable;
   	logic        pwrite;
   	logic [31:0] prdata;
   	logic [31:0] pwdata;
  
   	dut_if apb_if();
  
   	apb_slave dut(.dif(apb_if));

   	initial begin
      		apb_if.pclk=0;
   	end

   	always begin
      		#10 apb_if.pclk = ~apb_if.pclk;
   	end
 
  	initial begin
    		apb_if.rst_n=0;
    		#30;
    		apb_if.rst_n=1;
  	end
 
  	initial begin
    		uvm_config_db#(virtual dut_if)::set( uvm_root::get(),"*", "vif", apb_if);
    		run_test("apb_test");
  	end
  
  	initial begin
    		$dumpfile("dump.vcd");
    		$dumpvars;
  	end
  
 endmodule

