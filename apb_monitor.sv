
 class apb_monitor extends uvm_monitor;

  	virtual dut_if vif;
  
  	uvm_analysis_port#(apb_transaction) item_collected_port;

  	`uvm_component_utils(apb_monitor)

  	function new(string name = "monitor", uvm_component parent);
     		super.new(name, parent);
     		item_collected_port = new("item_collected_port", this);
   	endfunction

   	function void build_phase(uvm_phase phase);
     		super.build_phase(phase);
     		if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif)) begin
       			`uvm_error("build_phase", "No virtual interface specified for this monitor instance")
       		end
   	endfunction

   	virtual task run_phase(uvm_phase phase);
     		super.run_phase(phase);
     		forever begin
       			apb_transaction tr;
       
       			do begin
         			@ (posedge vif.pclk);
         		end
         		while (vif.psel !== 1'b1 || vif.penable !== 1'b0);

        		tr = apb_transaction::type_id::create("tr", this);
	        
       			tr.pwrite = (vif.pwrite) ? apb_transaction::WRITE : apb_transaction::READ;
         		tr.addr = vif.paddr;

       			@ (posedge vif.pclk);
         		if (vif.penable !== 1'b1) begin
            			`uvm_error("APB", "APB protocol violation: SETUP cycle not followed by ENABLE cycle");
         		end
         
       			if (tr.pwrite == apb_transaction::READ) begin
         			tr.data = vif.prdata;
       			end
       			else if (tr.pwrite == apb_transaction::WRITE) begin
         			tr.data = vif.pwdata;
       			end
         
       		  	item_collected_port.write(tr);
      		end
   	endtask

 endclass
