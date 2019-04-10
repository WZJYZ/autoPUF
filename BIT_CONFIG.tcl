open_hw
connect_hw_server
open_hw_target


set_property PROBES.FILE  $FILE_LTX [lindex [get_hw_devices $NAME_DEVICE] 0]
set_property PROGRAM.FILE $FILE_BIT [lindex [get_hw_devices $NAME_DEVICE] 0]
program_hw_devices [lindex [get_hw_devices $NAME_DEVICE] 0]
refresh_hw_device  [lindex [get_hw_devices $NAME_DEVICE] 0]
