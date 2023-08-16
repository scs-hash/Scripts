# 1. set trace through
set_ccopt_property trace_through_to -pin ${inst}/CP ${inst}/Q

# 2. unset ccopt property
unset_ccopt_property trace_through_to -pin ${inst}/CP
