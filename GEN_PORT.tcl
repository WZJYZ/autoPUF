set fout [ open "$FOLDER_CONSTRS/port.xdc" w ]
##是否是差分时钟
if {$IS_DIFFPOWER==1} {
	puts $fout "set_property PACKAGE_PIN $PACKAGE_PIN_N \[get_ports CLK_N\]"
	puts $fout "set_property IOSTANDARD $IOSTANDARD_N \[get_ports CLK_N\]"	
	puts $fout "set_property PACKAGE_PIN $PACKAGE_PIN_P \[get_ports CLK_P\]"
	puts $fout "set_property IOSTANDARD $IOSTANDARD_P \[get_ports CLK_P\]"
} else {
	puts $fout "set_property PACKAGE_PIN $PACKAGE_PIN_N \[get_ports clk\]"
	puts $fout "set_property IOSTANDARD $IOSTANDARD_N \[get_ports clk\]"
}	
close $fout
add_files -fileset constrs_1 "$FOLDER_CONSTRS/port.xdc"
