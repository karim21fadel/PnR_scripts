proc highlight_cell_groups {args} {
    # Help message
    if {[lsearch $args -h] != -1} {
        puts "Usage: highlight_cell_groups ?-bbox { {llx lly} {urx ury} }? ?-min_size N?"
        puts ""
        puts "Options:"
        puts "  [format "%-*s" 50 -h] --Show this help message"
        puts "  [format "%-*s" 50 -bbox { {llx lly} {urx ury} }] --Limit analysis to cells within given bounding box"
        puts "  [format "%-*s" 50 -min_group_size N] --Minimum number of cells per group to highlight (default: 100)"
        puts ""
        puts "Description:"
        puts "  This script groups stdcells by instance name prefix (before '_') and"
        puts "  highlights each group (if count greater than min_group_size), taking a snapshot per group."
        puts "  Useful for identifying what type of cells dominate congested areas."
        return
    }

    # Default values
    set bbox [get_attribute [get_core_area] bbox]
    set min_group_size 100

    # Parse arguments
    if {[lsearch $args -bbox] != -1} {
        set bbox_index [expr {[lsearch $args -bbox] + 1}]
        set bbox [lindex $args $bbox_index]
    }

    if {[lsearch $args -min_group_size] != -1} {
        set size_index [expr {[lsearch $args -min_size] + 1}]
        set min_group_size [lindex $args $size_index]
    }

    # Get all stdcell instances within bbox
    set all_cells [get_cells -within $bbox]

    # Initialize hash map for grouping
    array unset prefix_groups
    array set prefix_groups {}

    # Group cells by prefix
    foreach_in_collection cell $all_cells {
        set cell_name [get_attribute $cell full_name]
        set cell_prefix [lindex [split $cell_name "_"] 0]
        if {[string length $cell_prefix] > 1} {
            lappend prefix_groups($cell_prefix) $cell_name
        }
    }

    # Create output directory
	puts "Creating group_snapshots dir to drop snapshots"
    sh mkdir -p group_snapshots
    gui_deselect -all
    set core_bbox [get_attribute [get_core_area] bbox]
    gui_zoom_window -window [gui_get_current_window] -rect $core_bbox

    # Loop over each group
    foreach cell_prefix [array names prefix_groups] {
        set group_cells $prefix_groups($cell_prefix)
        set group_count [llength $group_cells]
        if {$group_count >= $min_group_size} {
            puts "Coloring prefix: $cell_prefix ($group_count cells)"
            gui_change_highlight -remove -all_colors
            gui_change_highlight -collection [get_cells $group_cells] -color red
            gui_write_window_image -file ./group_snapshots/${cell_prefix}.png
            puts "Saved snapshot: group_snapshots/${cell_prefix}.png"
        }
    }

    # Final cleanup
    gui_change_highlight -remove -all_colors
}