
 class apb_driver extends uvm_driver#(apb_transaction);
  
  	`uvm_component_utils(apb_driver)
  
  	virtual dut_if vif;
  
  	function new(string name, uvm_component parent);
    		super.new(name,parent);
  	endfunction
  
  	function void build_phase(uvm_phase phase);
    		super.build_phase(phase);
    		if(!uvm_config_db#(virtual dut_if)::get(this,"","vif",vif)) begin
      			`uvm_error("build_phase","driver virtual interface failed")
    		end
  	endfunction
  
  	virtual task run_phase(uvm_phase phase);
    		super.run_phase(phase);
    		vif.psel    <= 0;
    		vif.penable <= 0;

    		forever begin
      			apb_transaction tr;
      			@ (posedge this.vif.pclk);

	      		seq_item_port.get_next_item(tr);
      			@ (posedge this.vif.pclk);
      			uvm_report_info("APB_DRIVER ", $psprintf("Got Transaction %s",tr.convert2string()));
     	 
      			case (tr.pwrite)
        			apb_transaction::READ:  drive_read(tr.addr, tr.data);  
        			apb_transaction::WRITE: drive_write(tr.addr, tr.data);
      			endcase

	      		seq_item_port.item_done();
    			end
  	endtask
  
  	virtual protected task drive_read(input  bit   [31:0] addr, output logic [31:0] data);
    		vif.paddr   <= addr;
    		vif.pwrite  <= 0;
    		vif.psel    <= 1;
    		@ (posedge vif.pclk);
    		vif.penable <= 1;
    		vif.pready <= 1;
    		@ (posedge vif.pclk);
    		data = vif.prdata;
    		vif.psel    <= 0;
    		vif.penable <= 0;
    		vif.pready <= 0;
  	endtask

	virtual protected task drive_write(input bit [31:0] addr, input bit [31:0] data);
    		vif.paddr   <= addr;
    		vif.pwdata  <= data;
    		vif.pwrite  <= 1;
    		vif.psel    <= 1;
    		@ (posedge vif.pclk);
    		vif.penable <= 1;
    		vif.pready <= 1;
    		@ (posedge vif.pclk);
    		vif.psel    <= 0;
    		vif.penable <= 0;
    		vif.pready <= 0;
  	endtask

 endclass