
 class apb_test extends uvm_test;

  	`uvm_component_utils(apb_test);
  
  	apb_env  env;
  	apb_sequence seq;
  
  	function new(string name = "apb_test", uvm_component parent = null);
    		super.new(name, parent);
  	endfunction

  	function void build_phase(uvm_phase phase);
    		env = apb_env::type_id::create("env", this);
    		seq = apb_sequence::type_id::create("seq",this);
  	endfunction

  	task run_phase( uvm_phase phase );
   		phase.raise_objection( this );
   
    		fork 
    			begin
		    		seq.start(env.agt.sqr);       
    			end
    			begin
          			#20000;
    			end
    		join_any 
    		phase.drop_objection( this );
  	endtask
  
  	function void end_of_elaboration_phase (uvm_phase phase);
		uvm_top.print_topology;
   	endfunction
  
 endclass
