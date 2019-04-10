##########Place
#x:101, Y:100, LX:97
set X  $PLACE_TRAN_X
set Y  $PLACE_TRAN_Y
set LX $PLACE_X0

set fout [ open "$FOLDER_CONSTRS/new/place.xdc" w ]

##-nonewline告诉puts不换行
puts $fout "set_property BEL $BEL_TRAN \[get_cells apuf\/transition\]"
puts -nonewline $fout "set_property LOC SLICE_X$X"
puts $fout "Y$Y \[get_cells apuf/transition\]"

for {set i 0} {$i<$CHBIT} {incr i} {
	set Y [expr $Y-1]
	
	puts $fout "set_property BEL $BEL_CH \[get_cells \{apuf/path0/genblk1[$i].chblock/mux\}\]"
	puts -nonewline $fout "set_property LOC SLICE_X$LX"
	puts $fout "Y$Y \[get_cells {apuf/path0/genblk1[$i].chblock/mux}\]"
	puts $fout "set_property LOCK_PINS $PIN_CH \[get_cells \{apuf/path0/genblk1[$i].chblock/mux\}\]"	
	
	puts $fout "set_property BEL $BEL_CH \[get_cells \{apuf/path1/genblk1[$i].chblock/mux\}\]"
	puts -nonewline $fout "set_property LOC SLICE_X$X"
	puts $fout "Y$Y \[get_cells \{apuf/path1/genblk1[$i].chblock/mux\}\]"
	puts $fout "set_property LOCK_PINS $PIN_CH \[get_cells \{apuf/path1/genblk1[$i].chblock/mux\}\]"
}

for {set i 0} {$i<$ADJBIT} {incr i} {
	set Y [expr $Y-1]
	
	puts $fout "set_property BEL $BEL_ADJ \[get_cells \{apuf/path0/genblk2[$i].adjblock/mux\}\]"
	puts -nonewline $fout "set_property LOC SLICE_X$LX"
	puts $fout "Y$Y \[get_cells \{apuf/path0/genblk2[$i].adjblock/mux\}\]"
	puts $fout "set_property LOCK_PINS $PIN_ADJ \[get_cells \{apuf/path0/genblk2[$i].adjblock/mux\}\]"
	
	puts $fout "set_property BEL $BEL_ADJ \[get_cells \{apuf/path1/genblk2[$i].adjblock/mux\}\]"
	puts -nonewline $fout "set_property LOC SLICE_X$X"
	puts $fout "Y$Y \[get_cells \{apuf/path1/genblk2[$i].adjblock/mux\}\]"
	puts $fout "set_property LOCK_PINS $PIN_ADJ \[get_cells \{apuf/path1/genblk2[$i].adjblock/mux\}\]"
}

set Y [expr $Y-1]
puts $fout "set_property BEL $BEL_ARB \[get_cells apuf/arbiter/inst_RSP\]"
puts -nonewline $fout "set_property LOC SLICE_X$X"
puts $fout "Y$Y \[get_cells apuf/arbiter/inst_RSP\]"

close $fout

add_files -fileset constrs_1 "$FOLDER_CONSTRS/new/place.xdc"

