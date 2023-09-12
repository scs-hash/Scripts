#####################################################################################################################################
#  cell list: 
#   u0_HDMI_RX/u1_slishdmir_top/HDMI2_0_RXPHY_A0/HDMI2_0_RXPHYD_A0/tmdsconta/digital_filter/ud_d1_reg       SDFCNQD2BWPLVT                                                                                                                                                                                                   
#   u0_HDMI_RX/u1_slishdmir_top/HDMI2_0_RXPHY_A0/HDMI2_0_RXPHYD_A0/tmdsconta/digital_filter/sfd47_dc        XNR2D1BWPLVT
#   u0_HDMI_RX/u1_slishdmir_top/HDMI2_0_RXPHY_A0/HDMI2_0_RXPHYD_A0/tmdsconta/digital_filter/sfd12_dc        NR2XD8BWPLVT
#   u0_HDMI_RX/u1_slishdmir_top/HDMI2_0_RXPHY_A0/HDMI2_0_RXPHYD_A0/tmdsconta/pi_control/sfd6_dc     NR2D8BWPLVT
#   u0_HDMI_RX/u1_slishdmir_top/HDMI2_0_RXPHY_A0/HDMI2_0_RXPHYD_A0/tmdsconta/pi_control/sfd93_dc        NR2D2BWPLVT
#   u0_HDMI_RX/u1_slishdmir_top/HDMI2_0_RXPHY_A0/HDMI2_0_RXPHYD_A0/tmdsconta/digital_filter/downreg_reg_8_      SDFCNQD1BWPLVT
#   u0_HDMI_RX/u1_slishdmir_top/HDMI2_0_RXPHY_A0/HDMI2_0_RXPHYD_A0/tmdsconta/digital_filter/oddeven_reg     SDFCNQD2BWPLVT
#   u0_HDMI_RX/u1_slishdmir_top/HDMI2_0_RXPHY_A0/HDMI2_0_RXPHYD_A0/tmdsconta/digital_filter/sfd13_dc        OAI21D2BWPLVT
#   u0_HDMI_RX/u1_slishdmir_top/HDMI2_0_RXPHY_A0/HDMI2_0_RXPHYD_A0/tmdsconta/digital_filter/upreg_reg_8_        SDFCNQD4BWPLVT
#######################################################################################################################################

if {[info exists synopsys_program_name] == 1 && $synopsys_program_name == "pt_shell"} {
    set fp [open "/proj/SATURN/WORK/laval_li/scripts/skew_check_point/new/fix/cell_list" "r"]
    set cont [read $fp]
    close $fp    
    foreach line [split $cont "\n"] {
        set trim_line [string trim $line]
        if {[string length $trim_line] > 0} {
            regsub -all -line {\s+} $trim_line " " seg_lst
            set inst_name       [lindex $seg_lst 0]
            set lib_cell_name   [lindex $seg_lst 1]
            set org_lib_cell    [get_attribute [get_cells $inst_name] lib_cell.base_name]
            if {$lib_cell_name != $org_lib_cell} {
                size_cell $inst_name [get_lib_cells */${lib_cell_name}]
            }    
        }        
    }            
} else {         
    set fp [open "/proj/SATURN/WORK/laval_li/scripts/skew_check_point/new/fix/cell_list" "r"]
    set cont [read $fp]
    close $fp    
    foreach line [split $cont "\n"] {
        set trim_line [string trim $line]
        if {[string length $trim_line] > 0} {
            regsub -all -line {\s+} $trim_line " " seg_lst
            set inst_name       [lindex $seg_lst 0]
            set lib_cell_name   [lindex $seg_lst 1]
            set org_lib_cell    [get_db [get_db insts $inst_name] .base_cell.name]
            if {$lib_cell_name != $org_lib_cell} {
                puts "ecoChangeCell -inst $inst_name -cell $lib_cell_name"                                                                                                                                                                                                                                               
            }    
        }        
    }            
}    