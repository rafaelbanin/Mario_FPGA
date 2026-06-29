# Quartus 23.1 uses qsys 23.1; older releases used 18.1
if {[catch { package require -exact qsys 23.1 }]} {
    if {[catch { package require -exact qsys 18.1 }]} {
        package require qsys
    }
}

set_module_property NAME key_pio
set_module_property DISPLAY_NAME "Key PIO"
set_module_property VERSION 1.0
set_module_property DESCRIPTION "Debounced KEY input PIO for DE10"
set_module_property GROUP "Super Mario"
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "SuperMario_DE10"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false

add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL key_pio
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
set _hdl_path ""
foreach _candidate {../hdl/key_pio.v hdl/key_pio.v} {
    set _norm [file normalize $_candidate]
    if {[file exists $_norm]} {
        set _hdl_path $_norm
        break
    }
}
if {$_hdl_path eq ""} {
    error "Cannot find fpga/hdl/key_pio.v (cwd=[pwd])"
}
add_fileset_file key_pio.v VERILOG PATH $_hdl_path

add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock
set_interface_property avalon_slave associatedReset reset
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave timingUnits Cycles

add_interface_port avalon_slave avs_read read Input 1
add_interface_port avalon_slave avs_readdata readdata Output 32

add_interface clock clock end
set_interface_property clock associatedReset reset
set_interface_property clock clockRate 50000000
add_interface_port clock clk clk Input 1

add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
add_interface_port reset reset reset Input 1

add_interface key_input conduit end
set_interface_property key_input associatedClock clock
set_interface_property key_input associatedReset reset
add_interface_port key_input key_n key_n Input 4
