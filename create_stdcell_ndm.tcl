# ------- specify db files ------------#
set vt "HVT" 
if { $vt == "HVT" } {
	set STDCELL_PATH "/mnt/hgfs/saed14_pdk/SAED14nm_EDK_CORE_HVT_v_062020/stdcell_hvt/"
	set LIBNAME "saed14hvt"
} elseif {$vt == "RVT"} {
	set STDCELL_PATH "/mnt/hgfs/saed14_pdk/SAED14nm_EDK_CORE_RVT_v_062020/stdcell_rvt/"
	set LIBNAME "saed14rvt"
}

set LIBMODEL "db_nldm"
set PVT "ss0p72vm40c ff0p88v125c tt0p8v25c"


# --------- create workspace ----------#
create_workspace -flow normal ${LIBNAME} 

# --------- read frame only -----------#
read_ndm ${STDCELL_PATH}/ndm/${LIBNAME}_frame_only.ndm

# ---------- read db files ------------#
foreach pvtCorner $PVT {
	set processLabel [lindex [split $pvtCorner 0] 0]
	read_db -process_label $processLabel ${STDCELL_PATH}/${LIBMODEL}/${LIBNAME}_${pvtCorner}.db
}

# --------- checks $ reports ----------#
sh mkdir -p rpt
sh rm -rf rpt/${LIBNAME}*

check_workspace -allow_missing > rpt/${LIBNAME}_check_workspace.rpt
report_workspace -panes > rpt/${LIBNAME}_report_workspace.rpt

# --------- commit workspace ----------#
commit_workspace -force

# ------- check the final ndm ---------#
open_lib ${LIBNAME}.ndm
report_lib ${LIBNAME} > rpt/${LIBNAME}_report_lib.rpt

# -------------- quit -----------------#
quit
