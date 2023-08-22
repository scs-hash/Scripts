# replace LVT to SVT

setEcoMode -updateTiming false
setEcoMode -LEQCheck false
setEcoMode -batchMode true
setEcoMode -honorFixedStatus false
setEcoMode -honorDontUse false
setEcoMode -honorDontTouch false
setEcoMode -refinePlace false

set lvt_insts [get_db insts -if {.base_cell.name == *LVT}]
if {[llength $lvt_insts] > 0} {
    foreach inst $lvt_insts {
        set inst_name [get_db $inst .name]
        set new_cell [regsub LVT [get_db $inst .base_cell.name] SVT]
        ecoChangeCell -inst $inst_name $new_cell
    }
}