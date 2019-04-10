#############################################################
#######################Init Route File#######################
#############################################################
set FILE_ROUTE "$FOLDER_CONSTRS/new/route.xdc"
set fout [ open $FILE_ROUTE w ]
puts $fout ""
close $fout
add_files -fileset constrs_1 "$FOLDER_CONSTRS/new/route.xdc"
set_property target_constrs_file $FILE_ROUTE [current_fileset -constrset]

#############################################################
########################Syn Impel############################
#############################################################
source $FOLDER_CODE/SYN_IMP.tcl
open_run impl_1

#############################################################
#######################Fix Route#############################
#############################################################
#set_property is_route_fixed 1 [get_nets {apuf/transition_wire }]

for {set i 0} {$i<=$CHPORT} {incr i} {
	set_property is_route_fixed 1 [get_nets apuf/path0/genblk1[$i].chblock/OUT ]
}

for {set i 0} {$i<$ADJPORT} {incr i} {
	set_property is_route_fixed 1 [get_nets apuf/path0/genblk2[$i].adjblock/OUT ]
}

#set_property is_route_fixed 1 [get_nets {apuf/arbiter/IN0 }]
#set_property is_route_fixed 1 [get_nets {apuf/arbiter/IN1 }]

save_constraints -force
#############################################################
##############Copy Path0's Route To Path1###################
#############################################################
set fin  [ open "$FOLDER_CONSTRS/new/route.xdc"     r ]
set ftmp [ open "$FOLDER_CONSTRS/new/route_tmp.xdc" w ]
while {[gets $fin line] >= 0} {
	puts $ftmp $line
	if {[regsub -all {path0} $line "path1" match]==1} {
		if {[regexp path0.*$ADJPORT $line ignore]!=1} {
			puts $ftmp $match
		}
	}
}
close $fin
close $ftmp

file copy   -force "$FOLDER_CONSTRS/new/route_tmp.xdc" "$FOLDER_CONSTRS/new/route.xdc"
file delete -force "$FOLDER_CONSTRS/new/route_tmp.xdc"

close_design
