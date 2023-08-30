#1. fix overlap violation
refinePlace -inst [get_db [get_db markers -if {.type == place && .subtype == SPOverlapViolation}] .objects.name ]
# only refine standard cell overlap violation
refinePlace -inst [get_db [get_db [get_db markers -if {.type == place && .subtype == SPOverlapViolation}] .objects -if {.base_cell.class == core}] .name]

#2. fix orientation violation
refinePlace  -inst [get_db [get_db markers -if {.type == place && .subtype == SPOrientationViolation} ]  .objects.name]