source -v -e ../conf/conf.tcl
 
#######################	

set slowLibs "$dbFiles(${preferedVT},SS)"
set fastLibs "$dbFiles(${preferedVT},FF)"
set typicalLibs "$dbFiles(${preferedVT},TT)"

set_app_var target_library "$slowLibs $fastLibs $typicalLibs"

set_app_var link_library "* $target_library"

#######################
sh rm -rf $WORK

sh mkdir -p $WORK
#######################

define_design_lib work -path $WORK

#######################
set pkg {
		ibex_pkg.sv \
		prim_mubi_pkg.sv \
		prim_count_pkg.sv \
		prim_pkg.sv \
		prim_ram_1p_pkg.sv \
		prim_secded_pkg.sv \
		prim_cipher_pkg.sv \
		prim_util_pkg.sv 
	}

# 35
set hier_0 {
		prim_generic_clock_gating.sv \
		prim_xilinx_clock_gating.sv \
		prim_generic_buf.sv \
		ibex_compressed_decoder.sv \
		ibex_fetch_fifo.sv \
		prim_generic_buf.sv \
		prim_secded_inv_39_32_dec.sv \
		prim_secded_inv_39_32_enc.sv \
		prim_secded_inv_28_22_dec.sv \
		prim_secded_inv_28_22_enc.sv \
		prim_lfsr.sv \
		ibex_branch_predict.sv \
		ibex_decoder.sv \
		ibex_controller.sv \
		ibex_alu.sv \
		ibex_multdiv_fast.sv \
		ibex_multdiv_slow.sv \
		ibex_wb_stage.sv \
		ibex_csr.sv \
		ibex_counter.sv \
		ibex_pmp.sv \
		prim_onehot_check.sv \
		prim_onehot_enc.sv \
		prim_generic_and2.sv \
		prim_generic_flop.sv \
		prim_subst_perm.sv \
		prim_prince.sv \
		prim_generic_ram_1p.sv \
		prim_secded_inv_22_16_dec.sv \
		prim_secded_inv_22_16_enc.sv \
		prim_secded_inv_hamming_22_16_dec.sv \
		prim_secded_inv_hamming_22_16_enc.sv \
		prim_secded_inv_hamming_39_32_dec.sv \
		prim_secded_inv_hamming_39_32_enc.sv \
		prim_generic_clock_mux2.sv \
		prim_badbit_ram_1p.sv \
		prim_xilinx_flop.sv \
		prim_xilinx_and2.sv \
		prim_xilinx_buf.sv \
		prim_xilinx_clock_mux2.sv 
	}
	
# 12	
# ibex_cs_registers.sv
set hier_1 {
		prim_clock_gating.sv \
		prim_buf.sv \
		ibex_prefetch_buffer.sv \
		ibex_icache.sv \
		ibex_dummy_instr.sv \
		ibex_cs_registers.sv \
		ibex_id_stage.sv \
		ibex_ex_block.sv \
		prim_and2.sv \
		prim_flop.sv \
		prim_ram_1p.sv \
		prim_clock_mux2.sv
        }
		
# 6
set hier_2 { 
		ibex_if_stage.sv \
		ibex_load_store_unit.sv \
		prim_onehot_mux.sv \
		prim_ram_1p_scr.sv \
		prim_ram_1p_adv.sv \
		prim_count.sv
	}

# 5
set hier_3 {
		ibex_core.sv \
		ibex_register_file_ff.sv \
		ibex_register_file_fpga.sv \
		ibex_register_file_latch.sv \
		ibex_lockstep.sv
	}
###########################
sh rm -rf ${LOG}
sh mkdir -p ${LOG}

foreach i $pkg {
	analyze -library work -format sverilog "../dig/rtl/$i" > "${LOG}/analyze_package.log"
}

foreach i $hier_0 {
	analyze -library work -format sverilog "../dig/rtl/$i" > "${LOG}/analyze_hier_0.log"
}

foreach i $hier_1 {
	analyze -library work -format sverilog "../dig/rtl/$i" > "${LOG}/analyze_hier_1.log"
}

foreach i $hier_2 {
	analyze -library work -format sverilog "../dig/rtl/$i" > "${LOG}/analyze_hier_2.log"
}

foreach i $hier_3 {
	analyze -library work -format sverilog "../dig/rtl/$i" > "${LOG}/analyze_hier_3.log"
}

analyze -library work -format sverilog "../dig/rtl/${DESIGN}.sv" > "${LOG}/analyze_top.log"

elaborate ${DESIGN} -library work > "${LOG}/elaborate.log"
#######################
current_design

check_design > "${LOG}/check_design.log"
################
source ./cons/${DESIGN}_constrains.tcl > "${LOG}/source_constraints.log"

check_design > "${LOG}/check_design_post_constraints.log"

#################

link > "${LOG}/link.log"

##return

compile_ultra > "${LOG}/compile_ultra.log"
#######################
sh rm -rf ${REPORT}

sh mkdir -p ${REPORT}
#####################
report_area > "${REPORT}/syn_area.rpt"

report_timing -delay_type max -max_paths 100 > "${REPORT}/syn_setup.rpt"
report_timing -delay_type min -max_paths 100 > "${REPORT}/syn_hold.rpt"

report_power > "${REPORT}/syn_power.rpt"

report_cell > "${REPORT}/syn_cell_simple.rpt"

report_resources > "${REPORT}/syn_resources.rpt"

report_constraints -all_violators > "${REPORT}/syn_violations.rpt"

report_qor > "${REPORT}/syn_qor.rpt"
##########################
sh rm -rf ${OUTPUT}

sh mkdir -p ${OUTPUT}
#######################
write_sdc "${OUTPUT}/${DESIGN}.sdc"

write -hierarchy -format verilog -output "${OUTPUT}/${DESIGN}.v" >> "${LOG}/write_netlist.log"

write -format ddc -output "${OUTPUT}/${DESIGN}.ddc"

