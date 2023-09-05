#
#           |------|    |\
#       ----| D  Q |----|  ----
#           | reg1 | |  |/    buf1                    |------|
#           |------| |                    |-----------|D     | Latch
#                    |--------------------|           |------|            |--------|
#                                         |-------------------------------|SI      |
#                                                                         |  reg2  |
#                                                                         |--------|
#

#########################################################################
# Requirements: 
#         1. Registers Connect Wrong, now func need bypass register1
#         2. Latch/D and reg2/SI pin need keep connection to reg1/Q pin for dft scan chain connection
#         3. buf1, combination, and other register need connect to reg1/D pin
#
#Steps:
#         1. Reg1/Q all fanout detach from reg1/Q's net, and attach to Reg1/D's net
#         2. Detach Reg1/Q from Reg1/Q's net
#         3. Remove origin Reg1/Q's net and create top level Reg1/Q net, attach new net to Reg1/Q
#         4. Latch/D and Reg/SI detach from origin net, attach to new Reg1/Q net
#
#Comments:
#          1. attachTerm command only connect pin and net in same hierarchical
#          2. if inst's pin and connected net not in same hierarchical, attachTerm will report error
#          3. So we delete origin net, create net in top level to solve this issue
#          4. for example, a/b/c/d -> a_b_c_d
#
#########################################################################


proc verify_top_net_name {net_name} {
    if {[llength [get_db nets $net_name]] == 0} {
        set new_net_name $net_name
    } else {
        set new_net_name "cpt_eco_fix_${net_name}"
    }   
    return $new_net_name
}

#####################################
# 1. collect inst name
#####################################

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

#####################################
# 2. detach and attach
#####################################

foreach inst $inst_list {
    puts "# ${inst}"
    set d_pin "${inst}/D"
    set q_pin "${inst}/Q"
    set d_pin_net_name  [get_db [get_db pins $d_pin] .net.name]
    set q_pin_net_name  [get_db [get_db pins $q_pin] .net.name]
    set load_list   [get_db [get_db pins $q_pin] .net.loads]
    set scan_pins   [get_object_name [get_pins -quiet [all_fanout -from ${inst}/Q] -filter "full_name=~*/SI||full_name=~*lockup*"]]
    # 1. get new top net name
    set new_q_pin_net_name  [regsub -all / $q_pin_net_name _]
    set new_q_pin_net_name  [verify_top_net_name $new_q_pin_net_name]
    foreach load_pin $load_list {
        set load_pin_name       [get_db $load_pin .base_name]
        set load_inst_name      [get_db $load_pin .inst.name]
        # 2. detach loads input pin -> Q pin net
        puts "detachTerm $load_inst_name $load_pin_name $q_pin_net_name"
        # 3. attacth loads input pin -> D pin net
        puts "attachTerm $load_inst_name $load_pin_name $d_pin_net_name"
    }   
    # 4. remove origin Q pin net
    puts "detachTerm $inst Q $q_pin_net_name"
    puts "deleteNet $q_pin_net_name"
    # 5. create new top-level Q pin net
    puts "addNet $new_q_pin_net_name"
    puts "attachTerm $inst Q $new_q_pin_net_name"

    # 6. rewire scan pins to new net
    foreach pin $scan_pins {
        set inst_name     [get_db [get_db pins $pin] .inst.name]
        set net           [get_db [get_db pins $pin] .net.name]
        set pin_base_name [get_db [get_db pins $pin] .base_name]
        if {$net == $q_pin_net_name} {
            puts "# no need detach, already delete"
        } else {
            puts "detachTerm ${inst_name} ${pin_base_name} ${net}"
        }
        puts "attachTerm ${inst_name} ${pin_base_name} ${new_q_pin_net_name}"
    }   
    puts ""
}
