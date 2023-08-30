# create pg shapes by existed shapes
proc create_pg_shape_by_existed_shapes {pg_shapes layers direction} {
    if {$direction == "horizontal"} {
        set net_dir 0
    } else {
        set net_dir 1
    }
    
    foreach shape $pg_shapes {
        set net_name    [get_db $shape .net.name]
        set ll_x        [get_db $shape .polygon.bbox.ll.x]
        set ll_y        [get_db $shape .polygon.bbox.ll.y]
        set ur_x        [get_db $shape .polygon.bbox.ur.x]
        set ur_y        [get_db $shape .polygon.bbox.ur.y]
        foreach layer $layers {
            dbCreateWire $net_name $ll_x $ll_y $ur_x $ur_y $layer $net_dir STRIPE
        }
    }
}