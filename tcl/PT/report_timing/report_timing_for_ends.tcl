proc report_timing_from_timing_points {timing_point} {
    report_timing -from $timing_point -path_type summary -nworst 10 -max_paths 10 -nosplit -slack_greater_than  -9999
}

proc report_timing_to_timing_points {timing_point} {
    report_timing -to $timing_point -path_type summary -nworst 10 -max_paths 10 -nosplit -slack_greater_than  -9999
}