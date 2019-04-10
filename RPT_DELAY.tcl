open_run impl_1

set tran0 [get_property SLOW_MAX [ get_net_delays -of_objects [get_nets apuf/transition_wire] -to [get_pins apuf/path0/genblk1[0].chblock/mux/I0] ]]
set tran1 [get_property SLOW_MAX [ get_net_delays -of_objects [get_nets apuf/transition_wire] -to [get_pins apuf/path0/genblk1[0].chblock/mux/I1] ]]
set tran2 [get_property SLOW_MAX [ get_net_delays -of_objects [get_nets apuf/transition_wire] -to [get_pins apuf/path1/genblk1[0].chblock/mux/I0] ]]
set tran3 [get_property SLOW_MAX [ get_net_delays -of_objects [get_nets apuf/transition_wire] -to [get_pins apuf/path1/genblk1[0].chblock/mux/I1] ]]

for {set p 0} {$p<=1} {incr p} {
  for {set i 0} {$i<$CHBIT} {incr i} {
    for {set k 0} {$k<=1} {incr k} {
      set j [expr $i+1]

      if {$i!=[expr $CHBIT-1]} {                                                                                                                                                                         
        set delay_ch("$p\_$i\_$k") [ get_property SLOW_MAX [ get_net_delays -of_objects [get_nets apuf/path$p/genblk1[$i].chblock/OUT] -to [get_pins apuf/path$p/genblk1[$j].chblock/mux/I$k] ] ]
      } else {                                                                                                                                                                                               
        set delay_ch("$p\_$i\_$k") [ get_property SLOW_MAX [ get_net_delays -of_objects [get_nets apuf/path$p/genblk1[$i].chblock/OUT] -to [get_pins apuf/path$p/genblk2[0].adjblock/mux/I$k] ] ]
      }
    }
  }
}

for {set p 0} {$p<=1} {incr p} {
  for {set i 0} {$i<[expr $ADJBIT-1]} {incr i} {
    for {set k 0} {$k<=1} {incr k} {
      set j [expr $i+1]
      
      set delay_adj("$p\_$i\_$k") [ get_property SLOW_MAX [ get_net_delays -of_objects [get_nets apuf/path$p/genblk2[$i].adjblock/OUT] -to [get_pins apuf/path$p/genblk2[$j].adjblock/mux/I$k] ] ]
    }
  }
}

set path0_rsp [get_property SLOW_MAX [ get_net_delays -of_objects [get_nets apuf/arbiter/IN0] -to [get_pins apuf/arbiter/inst_RSP/C] ]]
set path1_rsp [get_property SLOW_MAX [ get_net_delays -of_objects [get_nets apuf/arbiter/IN1] -to [get_pins apuf/arbiter/inst_RSP/D] ]]

set fout [open "$FOLDER_CRP/delay.txt" w]
puts $fout "\t\tpath0\t|\tpath1\t"
puts $fout "0:\t$tran0\t$tran1\t|\t$tran2\t$tran3"
for {set i 0} {$i<$CHBIT} {incr i} {
	if {$i<$CHBIT-1} {
		puts -nonewline $fout [expr $i+1]
		puts -nonewline $fout ":\t"
	} else {
		puts -nonewline $fout "0:\t"
	}
  puts -nonewline $fout $delay_ch("0_$i\_0")
  puts -nonewline $fout "\t"
  puts -nonewline $fout $delay_ch("0_$i\_1")
  puts -nonewline $fout "\t|\t"
  puts -nonewline $fout $delay_ch("1_$i\_0")
  puts -nonewline $fout "\t"
  puts -nonewline $fout $delay_ch("1_$i\_1")
  puts -nonewline $fout "\t*\t"
  puts -nonewline $fout [expr $delay_ch("0_$i\_1")-$delay_ch("0_$i\_0")]
  puts -nonewline $fout "\t"
  puts -nonewline $fout [expr $delay_ch("1_$i\_1")-$delay_ch("1_$i\_0")]
  puts $fout ""
}
for {set i 0} {$i<$ADJBIT-1} {incr i} {
	puts -nonewline $fout [expr $i+1]
	puts -nonewline $fout ":\t"
  puts -nonewline $fout $delay_adj("0_$i\_0")
  puts -nonewline $fout "\t"
  puts -nonewline $fout $delay_adj("0_$i\_1")
  puts -nonewline $fout "\t|\t"
  puts -nonewline $fout $delay_adj("1_$i\_0")
  puts -nonewline $fout "\t"
  puts -nonewline $fout $delay_adj("1_$i\_1")
  puts -nonewline $fout "\t*\t"
  puts -nonewline $fout [expr $delay_adj("0_$i\_1")-$delay_adj("0_$i\_0")]
  puts -nonewline $fout "\t"
  puts -nonewline $fout [expr $delay_adj("1_$i\_1")-$delay_adj("1_$i\_0")]
  puts $fout ""
}
puts $fout "\t$path0_rsp\t|\t$path1_rsp"
puts $fout ""

close $fout

close_design