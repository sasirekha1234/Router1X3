class source_drv extends uvm_driver #(source_trans);


	`uvm_component_utils(source_drv)


 virtual source_if.DRV_MP vif;

 source_config my_config;


 function new(string name = "source_drv",uvm_component parent);
	super.new(name,parent);
 endfunction

 extern function void build_phase(uvm_phase phase);
 extern function void connect_phase(uvm_phase phase);
 extern task run_phase(uvm_phase phase);
 extern task send_to_dut(source_trans trans);

endclass


 function void source_drv::build_phase(uvm_phase phase);
	super.build_phase(phase);

	`uvm_info("SOURCE_DRV", "THIS IS BUILD_PHASE OF SOURCE_DRV", UVM_LOW)

	if(!uvm_config_db#(source_config)::get(this,"","source_config",my_config))
		begin
		`uvm_fatal("SOURCE_DRV", "SET THE SOURCE_CONFIG PROPERLY")
		end
	
 endfunction:build_phase


 function void source_drv::connect_phase(uvm_phase phase);
	`uvm_info("SOURCE_DRV", "THIS IS CONNECT_PHASE OF SOURCE_DRV", UVM_LOW)
	super.connect_phase(phase);
	vif  = my_config.vif;
 endfunction:connect_phase


	task source_drv::send_to_dut(source_trans trans);

	`uvm_info("SOURCE_DRV", "THIS IS SEND_TO_DUT OF SOURCE_DRV", UVM_LOW)
	`uvm_info("SOURCE_DRV", $sformatf("printing from driver \n %s", trans.sprint()), UVM_LOW)

	wait(vif.drv_cb.busy==0);
	vif.drv_cb.pkt_valid<= 1'b1;

	vif.drv_cb.data_in <= trans.header;

	@(vif.drv_cb);
	
	foreach(trans.payload[i])
		begin
	wait(vif.drv_cb.busy==0);
	vif.drv_cb.data_in<=trans.payload[i];
	@(vif.drv_cb);
		end

	vif.drv_cb.pkt_valid<= 1'b0;
	
	vif.drv_cb.data_in<=trans.parity;

	repeat(2)
		@(vif.drv_cb);
	`uvm_info("SOURCE_DRV", "THIS IS END OF SEND_TO_DUT", UVM_LOW)
	endtask:send_to_dut


 task source_drv::run_phase(uvm_phase phase);

	`uvm_info("SOURCE_DRV", "THIS IS RUN_PHASE OF SOURCE_DRV", UVM_LOW)

	@(vif.drv_cb);
	vif.drv_cb.resetn<=1'b0;

	repeat(2)
	@(vif.drv_cb);
	vif.drv_cb.resetn<=1'b1;

	forever begin
	`uvm_info("SOURCE_DRV", "get_next_item is asserted", UVM_LOW)
	seq_item_port.get_next_item(req);
	`uvm_info("SOURCE_DRV", "get_nest_item is unblocked", UVM_LOW)
	send_to_dut(req);
	seq_item_port.item_done();
	`uvm_info("SOURCE_DRV", "item_done is asserted", UVM_LOW)
	end

 endtask:run_phase
	

