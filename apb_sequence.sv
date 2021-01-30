
 class apb_sequence extends uvm_sequence#(apb_transaction);
  
  	`uvm_object_utils(apb_sequence)
  
  	function new (string name = "apb_sequence");
    		super.new(name);
  	endfunction
  
  	task body();
    		apb_transaction packet;
    		repeat (10) begin
      			packet=new();
      			start_item(packet);
      			assert(packet.randomize());
      			finish_item(packet);
    		end
  	endtask

 endclass