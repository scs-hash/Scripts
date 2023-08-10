# Disable timer update to speed up runtime
setEcoMode -updateTiming false

# Temprorarily disable LEQ checks so inverters can replace buffers:
setEcoMode -LEQCheck false

# Insert buffer to drive U1 through U8 and then change it to an inverter:
ecoAddRepeater -term {U1/D U2/D U3/D U4/D U5/D U6/D U7/D u8/D} -cell BUFX2 -name eco_inst_1
ecoChangeCell -cell INVX2 -inst eco_inst_1

# Insert buffer to drive U9 through U16 and then change it to an inverter:
ecoAddRepeater -term {U9/D U10/D U11/D U12/D U13/D U14/D U15/D U16/D} -cell BUFX2 -name eco_inst_2
ecoChangeCell -cell INVX2 -inst eco_inst_2

# Insert buffer to drive eco_inst_1 and eco_inst2 and then change it to an inverter:
ecoAddRepeater -term {eco_inst_1/A eco_inst_2/A} -cell BUFX2 -name eco_inst_0
ecoChangeCell -cell INVX2 -inst eco_inst_0

# Restore LEQ checking for ECOs:
setEcoMode -LEQCheck true