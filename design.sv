
 interface dut_if;

  	logic pclk;
  	logic rst_n;
  	logic [31:0] paddr;
  	logic psel;
  	logic penable;
  	logic pwrite;
  	logic [31:0] pwdata;
  	logic pready;
  	logic [31:0] prdata;

 endinterface


 module apb_slave(dut_if dif);

  	logic [31:0] mem [255:0];
  	logic [1:0] apb_st;
  	const logic [1:0] SETUP=0;
  	const logic [1:0] W_ENABLE=1;
  	const logic [1:0] R_ENABLE=2;
  
  	always @(posedge dif.pclk) begin
    		if (!dif.rst_n) begin
      			apb_st <=0;
      			dif.prdata <=0;
      			dif.pready <=1;
      			for(int i=0;i<256;i++) mem[i]=i;
    		end
    		else begin
      			case (apb_st)
        			SETUP: begin
          					dif.prdata <= 0;
          					if (dif.psel && !dif.penable) begin
            						if (dif.pwrite) begin
              							apb_st <= W_ENABLE;
            						end
            						else begin
              							apb_st <= R_ENABLE;
              							dif.prdata <= mem[dif.paddr];
            						end
          					end
        				end
        			W_ENABLE: begin
          					if (dif.psel && dif.penable && dif.pready && dif.pwrite) begin
            						mem[dif.paddr] <= dif.pwdata;
          					end
          					apb_st <= SETUP;
        				  end
        			R_ENABLE: begin
          					if (dif.psel && dif.penable && dif.pready && !dif.pwrite) begin
            						dif.prdata <= mem[dif.paddr];
          					end
          					apb_st <= SETUP;
        	                	  end
      			endcase
   	 	end
  	end

 endmodule
