# Quartus 23.1 uses qsys 23.1; older releases used 18.1
if {[catch { package require -exact qsys 23.1 }]} {
    if {[catch { package require -exact qsys 18.1 }]} {
        package require qsys
    }
}

set_module_property NAME framebuffer_bridge
set_module_property DISPLAY_NAME "Framebuffer Bridge"
set_module_property VERSION 1.0
set_module_property DESCRIPTION "Dual-port indexed framebuffer for HPS and VGA"
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
set_fileset_property QUARTUS_SYNTH TOP_LEVEL framebuffer_bridge
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
set hdl_dir [file normalize [file join [file dirname [info script]] ../hdl]]
add_fileset_file framebuffer_bridge.v VERILOG PATH [file join $hdl_dir framebuffer_bridge.v]

add_interface avalon_slave avalon end
set_interface_property avalon_slave ADDRESS_UNITS WORDS
set_interface_property avalon_slave ASSOCIATED_CLOCK clock
set_interface_property avalon_slave ASSOCIATED_RESET reset
set_interface_property avalon_slave BITS_PER_SYMBOL 8
set_interface_property avalon_slave BURSTCOUNT_UNITS WORDS
set_interface_property avalon_slave BYTE_ENABLE 1
set_interface_property avalon_slave BYTE_SIZE 8
set_interface_property avalon_slave MAX_BURST_COUNT 1
set_interface_property avalon_slave READ_WAIT_TIME 1
set_interface_property avalon_slave WRITE_WAIT_TIME 0
set_interface_property avalon_slave TIMING_UNITS Cycles

add_interface_port avalon_slave avs_address address Input 2
add_interface_port avalon_slave avs_read read Input 1
add_interface_port avalon_slave avs_write write Input 1
add_interface_port avalon_slave avs_writedata writedata Input 32
add_interface_port avalon_slave avs_readdata readdata Output 32
add_interface_port avalon_slave avs_byteenable byteenable Input 4

add_interface clock clock end
set_interface_property clock ASSOCIATED_RESET reset
set_interface_property clock CLOCK_RATE 50000000
add_interface_port clock clk clk Input 1

add_interface reset reset end
set_interface_property reset ASSOCIATED_CLOCK clock
set_interface_property reset SYNCHRONOUS_EDGES deassert
add_interface_port reset reset reset Input 1
