#######################
### Common Variavles ##
#######################

## set DESIGN top_design_name
set DESIGN "ibex_wrapper"                                                                                                                                                                 

## set work dirs
set WORK   "./work"
set LOG    "./log"
set REPORT "./reports"
set OUTPUT "./output"

## set db files
## array set dbFiles {
##    HVT,SS /path/to/ss.db
##    HVT,FF /path/to/ff.db
##    HVT,TT /path/to/tt.db
##
##    LVT,SS /path/to/ss.db
##    LVT,FF /path/to/ff.db
##    LVT,TT /path/to/tt.db
##    ...
##}

array set dbFiles {
    HVT,SS /mnt/hgfs/saed14_pdk/SAED14nm_EDK_CORE_HVT_v_062020/stdcell_hvt/db_ccs/saed14hvt_ss0p72vm40c.db
    HVT,FF /mnt/hgfs/saed14_pdk/SAED14nm_EDK_CORE_HVT_v_062020/stdcell_hvt/db_ccs/saed14hvt_ff0p88v125c.db
    HVT,TT /mnt/hgfs/saed14_pdk/SAED14nm_EDK_CORE_HVT_v_062020/stdcell_hvt/db_ccs/saed14hvt_tt0p8v25c.db
}

########################
###   Syn Variables  ###
########################
set SSLIB ""
set FFLIB ""

foreach vt {HVT} {
    set SSLIB "$SSLIB $dbFiles($vt,SS)"
    set FFLIB "$FFLIB $dbFiles($vt,FF)"
}


########################
###   PnR Variables  ###
########################

## set ndm files
