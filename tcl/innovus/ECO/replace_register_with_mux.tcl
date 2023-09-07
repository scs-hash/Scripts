##################################################
# Same with detach_and_attach.tcl
# 1. func logic ignore this register
# 2. scan chain keep
# 3. replace register with mux
#     - reg Q pin net -> mux IO pin
#     - reg si pin net -> mux I1 pin
#     - reg z pin net -> mux Z pin
#     - reg se pin net -> MUX S pin
#
#                        |\
#                    I0  | \
#     reg D pin net   ---|  |       (Z)
#                        |  |--------- reg Q pin net
#     reg SI pin net  ---|  |
#                     I1 | /
#                        |/ | (S)
#                           reg SE pin net
#                          
##################################################

set inst_list "u1_SPE/u2_super_scaler/u0_superscaler_top/u2_hsharp/wra_vsync_reg
u1_SPE/u2_super_scaler/u0_superscaler_top/u2_hsharp/wra_de_reg
u1_SPE/u2_super_scaler/u0_superscaler_top/u2_hsharp/wra_delast_reg"

for {set i 0} {$i < 10} {incr i} {
    lappend inst_list u1_SPE/u2_super_scaler/u0_superscaler_top/u2_hsharp/wra_yin0_reg_${i}_ 
    lappend inst_list u1_SPE/u2_super_scaler/u0_superscaler_top/u2_hsharp/wra_yin1_reg_${i}_ 
    lappend inst_list u1_SPE/u2_super_scaler/u0_superscaler_top/u2_hsharp/wra_uin0_reg_${i}_ 
    lappend inst_list u1_SPE/u2_super_scaler/u0_superscaler_top/u2_hsharp/wra_uin1_reg_${i}_ 
    lappend inst_list u1_SPE/u2_super_scaler/u0_superscaler_top/u2_hsharp/wra_vin0_reg_${i}_ 
    lappend inst_list u1_SPE/u2_super_scaler/u0_superscaler_top/u2_hsharp/wra_vin1_reg_${i}_ 
}

foreach inst $inst_list {
    set inst_obj [get_db insts $inst]
    set inst_x   [get_db $inst_obj .bbox.ll.x]
    set inst_y   [get_db $inst_obj .bbox.ll.y]
    set ori_pins [get_db $inst_obj .pins.base_name]
    puts "## $inst  $ori_pins"
    # 1. save origin D/Q/SI/SE pin net name
    set d_pin_net   [get_db [get_db pins ${inst}/D] .net.name]
    set q_pin_net   [get_db [get_db pins ${inst}/Q] .net.name]
    set si_pin_net  [get_db [get_db pins ${inst}/SI] .net.name]
    set se_pin_net  [get_db [get_db pins ${inst}/SE] .net.name]
    # 2. detach inst pins from orign net
    foreach pin_obj [get_db $inst_obj .pins] {
        set pin_name    [get_db $pin_obj .base_name]
        set net_name    [get_db $pin_obj .net.name]
        puts "detachTerm $inst $pin_name $net_name"
    }   
    # 3. delete orign inst
    puts "deleteInst $inst"
    # 4. create new mux inst
    set new_inst_name   "${inst}_cpt_replaced_mux"
    puts "addInst -cell MUX2D2BWPLVT -inst ${new_inst_name} -loc $inst_x $inst_y"
    # 5. attach mux pin to origin net
    puts "attachTerm $new_inst_name I0 $d_pin_net"
    puts "attachTerm $new_inst_name I1 $si_pin_net"
    puts "attachTerm $new_inst_name Z  $q_pin_net"
    puts "attachTerm $new_inst_name S  $se_pin_net"
    puts ""
}
