# Resolve HDL paths for custom Platform Designer components.
# Quartus may resolve PATH relative to the _hw.tcl dir, the .qsys dir, or pwd.

set ::mario_ip_dir [file dirname [file normalize [info script]]]

proc mario_resolve_hdl {filename} {
    set candidates {}

    lappend candidates [file join $::mario_ip_dir .. hdl $filename]
    lappend candidates [file join $::mario_ip_dir hdl $filename]

    set pwd [pwd]
    lappend candidates [file join $pwd hdl $filename]
    lappend candidates [file join $pwd fpga hdl $filename]
    lappend candidates [file join $pwd .. hdl $filename]
    lappend candidates [file join $::mario_ip_dir .. .. hdl $filename]
    lappend candidates ../hdl/$filename
    lappend candidates hdl/$filename

    foreach path $candidates {
        set norm [file normalize $path]
        if {[file exists $norm]} {
            return $norm
        }
    }

    error "Cannot find HDL file '$filename'. Searched:\n  [join $candidates "\n  "]"
}
