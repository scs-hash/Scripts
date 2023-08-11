proc highlight_open_channels {} {
    set block_pr    [create_poly_rect -boundary [get_attribute [get_core_area] boundary]]
    set macros      [get_cells -physical_context -filter "design_type == macro"]
    set keepouts    [get_keepout_margins -type hard -quiet]
    set place_blkgs [get_placement_blockages -filter "blockage_type == hard" -quiet]

    if [sizeof_collection $macros] {
        set macros_pr   [create_poly_rect -boundary [get_attribute $macros boundary]]
    }

    if [sizeof_collection $keepouts] {
        set keepout_pr  [create_poly_rect -boundary [get_attribute $keepouts boundary]]
    }

    if [sizeof_collection $place_blkgs] {
        set place_blkgs_pr  [create_poly_rect -boundary [get_attribute $place_blkgs boundary]]
    }

    if [info exists macros_pr] {
        set blocked_pr $macros_pr
        if [info exists keepout_pr] {
            set blocked_pr [compute_polygons -operation or -objects1 $blocked_pr -objects2 $keepout_pr]
            if [info exists place_blkgs_pr] {
                set blocked_pr [compute_polygons -operation or -objects1 $blocked_pr -objects2 $place_blkgs_pr]
            }
        } else {
            if [info exists place_blkgs_pr] {
                set blocked_pr [compute_polygons -operation or -objects1 $blocked_pr -objects2 $place_blkgs_pr]
            }
        }
    } else {
        error "There are no macros, placement blockages or placement keepouts in your design"
    }

    set open_channels_pr [compute_polygons -operation not -objects1 $block_pr -objects2 $blocked_pr]

    gui_remove_all_annotations
    puts [get_attribute $open_channels_pr poly_rects]
    foreach_in_collection poly_rect [get_attribute $open_channels_pr poly_rects] {
        gui_add_annotation -type polygon -pattern SolidPattern -color red -window [gui_get_current_window -types Layout -mru] [get_attribute $poly_rect point_list]
    }

    gui_set_setting -window [gui_get_current_window -types Layout -mru] -setting showCellCore -value false
    gui_set_pref_value -category layout -key showHighlightByNormalColor -value true
}