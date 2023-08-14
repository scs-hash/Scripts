# 1. set dont_touch for cell
proc set_dont_touch_for_instance_by_file {inst_file} {
    set f_p [open $inst_file r]
    while {[gets $f_p line] >= 0} {
        set line [string trim $line]
        if {[string length $line] > 0 } {
            set inst [get_db insts $line]
            if {[llength $inst] > 0} {
                set_db $inst .dont_touch true
            }
        }
    }
    close $f_p
}

# 2. set size_only for cell
proc set_size_only_for_instance_by_file {inst_file} {
    set f_p [open $inst_file r]
    while {[gets $f_p line] >= 0} {
        set line [string trim $line]
        if {[string length $line] > 0 } {
            set inst [get_db insts $line]
            if {[llength $inst] > 0} {
                set_db $inst .dont_touch size_ok
            }
        }
    }
    close $f_p
}

# 3. keep_boundary
proc set_keep_boundary_for_hinst_by_file {hinst_file} {
    set f_p [open $hinst_file r]
    while {[gets $f_p line] >= 0} {
        set line [string trim $line]
        if {[string length $line] > 0 } {
            set hinst [get_db hinsts $line]
            if {[llength $hinst] > 0} {
                set_db $hinst .dont_touch_hports true
            }
        }
    }
    close $f_p
}

