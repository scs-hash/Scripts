# get latency of launch & capture register flop's CP pin
proc get_clock_pin_network_latency {pin_name check_type } {
    if {$check_type == "setup"} {
        # setup
        puts "  network_latency_fall_max: [get_db [get_db pins $pin_name] .network_latency_fall_max]"
        puts "  network_latency_rise_max: [get_db [get_db pins $pin_name] .network_latency_rise_max]"
    } else {
        # hold
        puts "  network_latency_fall_min: [get_db [get_db pins $pin_name] .network_latency_fall_min]"
        puts "  network_latency_rise_min: [get_db [get_db pins $pin_name] .network_latency_rise_min]"
    }
}

proc custom_report_timing {startpoint endpoint} {
    set timing_path [report_timing -from $startpoint -to $endpoint -collection]

    # 1. get check_type
    set check_type [get_db $timing_path .check_type]
    puts "check_type: $check_type"

    # 2. report common point
    set cmn_point [get_db $timing_path .cppr_branch_point.name]
    puts "common point: $cmn_point"

    # 3. report clocks
    set launch_clock  [get_db $timing_path .launching_clock.base_name]
    set capture_clock [get_db $timing_path .capturing_clock.base_name]
    puts "launch clocks: $launch_clock; capture clocks: $capture_clock"


    # 4. launch & capture clock pins
    set launch_pin_name [get_db $timing_path  .launching_point.name]
    set capture_pin_name [get_db $timing_path .capturing_clock_pin.name]

    puts "launch clock network delay: ->"
    get_clock_pin_network_latency $launch_pin_name $check_type

    puts "capture clock network delay: ->"
    get_clock_pin_network_latency $capture_pin_name $check_type

}

