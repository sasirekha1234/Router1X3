 interface dest_if(
	input bit clk
 );


//nets

logic[7:0] data_out;
logic valid_out;
logic read_en;


//clocking

clocking drv_cb@(posedge clk);
	input valid_out;
	output read_en;
endclocking


clocking mon_cb@(posedge clk);
	input data_out;
	input valid_out;
	input read_en;

//modports
endclocking

modport DRV_MP(clocking drv_cb);
modport MON_MP(clocking mon_cb);




 endinterface
