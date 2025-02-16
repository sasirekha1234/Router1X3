class dest_agent_top extends uvm_env;

        `uvm_component_utils(dest_agent_top)

 dest_agent agt_h[];
 env_config e_cfg;

 function new(string name = "dest_agent_top",uvm_component parent);
        super.new(name,parent);
 endfunction

	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass


 function void dest_agent_top::build_phase(uvm_phase phase);
        
	  super.build_phase(phase);

  `uvm_info("DEST_AGENT_TOP", "This is build_phase", UVM_LOW)

  if (!uvm_config_db#(env_config)::get(this, "", "env_config", e_cfg)) begin
    `uvm_fatal("DEST_AGENT_TOP", "Set the env_config properly")
  end

 $display("=================================================================== %p",e_cfg);	

//	`uvm_info(get_type_name,$sformatf("e_cfg.d_cfg[0].is_active = %s is",e_cfg.d_cfg[0].is_active),UVM_LOW)
  agt_h = new[e_cfg.no_of_dest_agt];

  // d_cfg = e_cfg.d_cfg;

  foreach (agt_h[i])begin
	agt_h[i] = dest_agent::type_id::create($sformatf("agt_h[%0d]", i), this);
    uvm_config_db#(dest_config)::set(this, $sformatf("agt_h[%0d]*", i), "dest_config", e_cfg.d_cfg[i]);
	  end

 endfunction

 task dest_agent_top::run_phase(uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("DEST_AGENT_TOP", "THIS IS RUN_PHASE", UVM_LOW)
 endtask

 


