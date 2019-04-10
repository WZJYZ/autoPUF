create_ip -name vio -vendor xilinx.com -library ip -module_name vio -dir "$FOLDER_SOURCES/ip"
set_property -dict [list CONFIG.C_NUM_PROBE_IN {1}] [get_ips vio]
set_property -dict [list CONFIG.C_NUM_PROBE_OUT {5}] [get_ips vio]
set_property -dict [list CONFIG.C_PROBE_OUT2_WIDTH $ADJBIT] [get_ips vio]
set_property -dict [list CONFIG.C_PROBE_OUT3_WIDTH $ADJBIT] [get_ips vio] 
set_property -dict [list CONFIG.C_PROBE_OUT4_WIDTH $CHBIT]  [get_ips vio]
update_compile_order -fileset sources_1
generate_target all [get_files  "$FOLDER_SOURCES/ip/vio/vio.xci"]
export_ip_user_files -of_objects [get_files "$FOLDER_SOURCES/ip/vio/vio.xci"] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] "$FOLDER_SOURCES/ip/vio/vio.xci"]
launch_runs -jobs 4 vio_synth_1


create_ip -name ila -vendor xilinx.com -library ip -module_name ila -dir "$FOLDER_SOURCES/ip"
set_property -dict [list CONFIG.C_DATA_DEPTH $ILA_SIZE ] [get_ips ila]
set_property -dict [list CONFIG.C_NUM_OF_PROBES {3}] [get_ips ila]
set_property -dict [list CONFIG.C_PROBE0_WIDTH $CHBIT ]   [get_ips ila]
update_compile_order -fileset sources_1
generate_target all [get_files  "$FOLDER_SOURCES/ip/ila/ila.xci"]
export_ip_user_files -of_objects [get_files "$FOLDER_SOURCES/ip/ila/ila.xci"] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] "$FOLDER_SOURCES/ip/ila/ila.xci"]
launch_runs -jobs 4 ila_synth_1
