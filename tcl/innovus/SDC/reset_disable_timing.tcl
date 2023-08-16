#1. set disable timing
set_disable_timing -from CLKB -to CLKA [get_cells -filter "ref_name == RF2P_32x32m2 || ref_name == RF2P_64x64m2 || ref_name == RF2P_1024x60m4 || ref_name == RF2P_1024x48m4 || ref_name == RF2P_1024x16m4 || ref_name == RF2P_1024x24m4 || ref_name == RF2P_1024x64m4 " -hier] 
set_disable_timing -from CLKA -to CLKB [get_cells -filter "ref_name == RF2P_32x32m2 || ref_name == RF2P_64x64m2 || ref_name == RF2P_1024x60m4 || ref_name == RF2P_1024x48m4 || ref_name == RF2P_1024x16m4 || ref_name == RF2P_1024x24m4 || ref_name == RF2P_1024x64m4 " -hier] 
set_disable_timing -from CLKB -to CLKA [get_cells -filter "ref_name == RF2P_64x32m2 || ref_name == RF2P_256x22m2 || ref_name == RF2P_256x120m2 || ref_name == RF2P_32x60m2 || ref_name == RF2P_512x12m2 || ref_name == RF2P_512x112m2 || ref_name == RF2P_160x128m2 || ref_name == RF2P_256x88m2 " -hier] 
set_disable_timing -from CLKA -to CLKB [get_cells -filter "ref_name == RF2P_64x32m2 || ref_name == RF2P_256x22m2 || ref_name == RF2P_256x120m2 || ref_name == RF2P_32x60m2 || ref_name == RF2P_512x12m2 || ref_name == RF2P_512x112m2 || ref_name == RF2P_160x128m2 || ref_name == RF2P_256x88m2 " -hier] 


#2. reset disable timing
set_interactive_constraint_modes [all_constraint_modes]
    reset_disable_timing -from CLKB -to CLKA [get_cells -filter "ref_name == RF2P_32x32m2 || ref_name == RF2P_64x64m2 || ref_name == RF2P_1024x60m4 || ref_name == RF2P_1024x48m4 || ref_name == RF2P_1024x16m4 || ref_name == RF2P_1024x24m4 || ref_name == RF2P_1024x64m4 " -hier] 
    reset_disable_timing -from CLKA -to CLKB [get_cells -filter "ref_name == RF2P_32x32m2 || ref_name == RF2P_64x64m2 || ref_name == RF2P_1024x60m4 || ref_name == RF2P_1024x48m4 || ref_name == RF2P_1024x16m4 || ref_name == RF2P_1024x24m4 || ref_name == RF2P_1024x64m4 " -hier] 
    reset_disable_timing -from CLKB -to CLKA [get_cells -filter "ref_name == RF2P_64x32m2 || ref_name == RF2P_256x22m2 || ref_name == RF2P_256x120m2 || ref_name == RF2P_32x60m2 || ref_name == RF2P_512x12m2 || ref_name == RF2P_512x112m2 || ref_name == RF2P_160x128m2 || ref_name == RF2P_256x88m2 " -hier] 
    reset_disable_timing -from CLKA -to CLKB [get_cells -filter "ref_name == RF2P_64x32m2 || ref_name == RF2P_256x22m2 || ref_name == RF2P_256x120m2 || ref_name == RF2P_32x60m2 || ref_name == RF2P_512x12m2 || ref_name == RF2P_512x112m2 || ref_name == RF2P_160x128m2 || ref_name == RF2P_256x88m2 " -hier]
set_interactive_constraint_modes []