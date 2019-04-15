#<
#设置某个adj_target,如50，在循环次数，如num_repeat为10,下的激励相应对。
set num_adj 5
set adj_target(0) 50
set adj_target(1) 10
set adj_target(2) 30
set adj_target(3) 70
set adj_target(4) 90
set num_repeat(0) 10
set num_repeat(1) 2
set num_repeat(2) 2
set num_repeat(3) 2
set num_repeat(4) 2

set runcrp_setid 0
#avoid losing all the data due to unexpected errors of vivado
for {set runcrp_setid 0} {$runcrp_setid<2} {incr runcrp_setid} {
  #每次循环产生一个种子
  set cs_num_crp 100
  set cs_file_adjchseed $FOLDER_CRP/crp/c$cs_num_crp\_id$runcrp_setid.chseed
  set runcrp_file_crp $FOLDER_CRP/crp/c$cs_num_crp\_id$runcrp_setid.crp
  #>

  source $FOLDER_CODE/FUNC_GENCHSEED.tcl

  for {set i 0} {$i<$num_adj} {incr i} {
  	set x $adj_target($i)
  	set finadj [open $FOLDER_CRP/adj/$x.adj r]
  	gets $finadj line
  	regexp {(\S+)\s+(\S+)\s+\S+} $line match rs_adj0 rs_adj1
  	close $finadj
  	#
	#读取前面生成的种子
  	set finchseed [open $cs_file_adjchseed r]
  	gets $finchseed rs_num_active
  	for {set a 0} {$a<$rs_num_active} {incr a} {
  		gets $finchseed rs_ch_seed($a)
  	}
  	close $finchseed
  	
  	set rs_repeat $num_repeat($i)
  	
  #	puts "$rs_adj0 $rs_adj1 $rs_num_active $rs_repeat"

  	source $FOLDER_CODE/FUNC_GETCRP.tcl

  	for {set c 0} {$c<$rs_num_crp} {incr c} {
  		for {set r 0} {$r<$rs_repeat} {incr r} {
  			set runcrp_rsp($i,$c,$r) $rs_crp_rsp($c,$r)
  		}
  	}
  }

  set foutcrp [open $runcrp_file_crp w]
  puts $foutcrp $rs_num_crp
  for {set c 0} {$c<$rs_num_crp} {incr c} {
  	puts -nonewline $foutcrp $rs_crp_ch($c)
  	for {set i 0} {$i<$num_adj} {incr i} {
  		puts -nonewline $foutcrp " "
  		for {set r 0} {$r<$num_repeat($i)} {incr r} {
  			puts -nonewline $foutcrp $runcrp_rsp($i,$c,$r)
  		}
  	}
  	puts $foutcrp ""
  }
  close $foutcrp
}