# FUNCTION ADJ HEURISTIC

# input:
# ah_file_adj_chseed
# ah_check_01
# ah_adj_fix()
# ah_adj_init
# ah_uniform_target
# ah_maxiter
# ah_contfail
# ah_file_adj
###########################################

set rs_repeat 1
#读取种子至数组rs_ch_seed
set finchseed [open $ah_file_adj_chseed r]
gets $finchseed rs_num_active
for {set a 0} {$a<$rs_num_active} {incr a} {
	gets $finchseed rs_ch_seed($a)
}
close $finchseed

###########################################
# ->0
#adj0全部设置为1
#adj1全部设置为0
#得到uniform_0为0.0：所有的rsp都为0.
set uniform_0 0
if {$ah_check_01==1} {
  for {set i 0} {$i<$ADJBIT} {incr i} {
  	set H_ADJ0($i) 1
  	set H_ADJ1($i) 0
  }

  set rs_adj0 ""
  set rs_adj1 ""
  for {set i 0} {$i<$ADJBIT} {incr i} {
  	append rs_adj0 $H_ADJ0($i)
  	append rs_adj1 $H_ADJ1($i)
  }

  source $FOLDER_CODE/FUNC_GETCRP.tcl

  set uniform_0 $rs_uniform
}

###########################################
# ->1
#adj0全部设置为0
#adj1全部设置为1
#得到uniform_1为1.0:所有的rsp都为1.
set uniform_1 1
if {$ah_check_01==1} {
  for {set i 0} {$i<$ADJBIT} {incr i} {
  	set H_ADJ0($i) 0
  	set H_ADJ1($i) 1
  }

  set rs_adj0 ""
  set rs_adj1 ""
  for {set i 0} {$i<$ADJBIT} {incr i} {
  	append rs_adj0 $H_ADJ0($i)
  	append rs_adj1 $H_ADJ1($i)
  }

  source $FOLDER_CODE/FUNC_GETCRP.tcl

  set uniform_1 $rs_uniform
}

###########################################
#调整失败标志
set FLAG_ADJ_FAIL 0
#启发式算法最大运行次数
set max_iter $ah_maxiter

#puts "$uniform_0 $uniform_1"
if {$uniform_0>$ah_uniform_target} {
	set max_iter 0
	set FLAG_ADJ_FAIL 1
}
if {$uniform_1<$ah_uniform_target} {
	set max_iter 0
	set FLAG_ADJ_FAIL 1
}

###########################################
#初始化调整信号rs_adj0和rs_adj1
set chars [split $ah_adj_init ""]
for {set i 0} {$i<$ADJBIT} {incr i} {
  set j [expr $ADJBIT+$i]
	set H_ADJ0($i) [lindex $chars $i]
	set H_ADJ1($i) [lindex $chars $j]
}

set rs_adj0 ""
set rs_adj1 ""
for {set i 0} {$i<$ADJBIT} {incr i} {
	append rs_adj0 $H_ADJ0($i)
	append rs_adj1 $H_ADJ1($i)
}

#获取当前调整信号下的crp并计算uniform
source $FOLDER_CODE/FUNC_GETCRP.tcl

set current_uniform $rs_uniform
set current_uniform_delta [expr $current_uniform-$ah_uniform_target]
if {$current_uniform_delta<0} {
	set current_uniform_delta [expr 0.0-$current_uniform_delta]
}

#puts "0: $rs_adj0 $rs_adj1 $current_uniform $current_uniform_delta"

set BEST_ADJ0 $rs_adj0
set BEST_ADJ1 $rs_adj1
set BEST_UNIFORM $current_uniform
set BEST_UNIFORM_DELTA $current_uniform_delta

set countcontfail 0
#启发式算法寻找设定目标下的最佳调整信号
for {set iter 1} {$iter<=$max_iter} {} {

	set flag_adj 0
	set adj_id [expr int(2*$ADJBIT*rand())]

	#puts "$iter $adj_id $ah_adj_fix($adj_id)"

	if {$ah_adj_fix($adj_id)==0} {
		if {$current_uniform<$ah_uniform_target} {
			if {$adj_id<$ADJBIT} {
				if {$H_ADJ0($adj_id)==1} {
					set H_ADJ0($adj_id) 0
					set flag_adj 1
				}
			} else {
				set tmp_id [expr $adj_id-$ADJBIT]
				if {$H_ADJ1($tmp_id)==0} {
					set H_ADJ1($tmp_id) 1
					set flag_adj 1
				}
			}
		}

		if {$current_uniform>$ah_uniform_target} {
			if {$adj_id<$ADJBIT} {
				if {$H_ADJ0($adj_id)==0} {
					set H_ADJ0($adj_id) 1
					set flag_adj 1
				}
			} else {
				set tmp_id [expr $adj_id-$ADJBIT]
				if {$H_ADJ1($tmp_id)==1} {
					set H_ADJ1($tmp_id) 0
					set flag_adj 1
				}
			}
		}
	}

	if {$flag_adj==1} {
		set rs_adj0 ""
		set rs_adj1 ""
		for {set i 0} {$i<$ADJBIT} {incr i} {
			append rs_adj0 $H_ADJ0($i)
			append rs_adj1 $H_ADJ1($i)
		}

		source $FOLDER_CODE/FUNC_GETCRP.tcl

		set new_uniform $rs_uniform
		set new_uniform_delta [expr $new_uniform-$ah_uniform_target]
		if {$new_uniform_delta<0} {
			set new_uniform_delta [expr 0.0-$new_uniform_delta]
		}

#		puts "$iter $rs_adj0 $rs_adj1 $new_uniform $new_uniform_delta $adj_id"

		if {$new_uniform_delta>$current_uniform_delta} {
			incr countcontfail

			if {$countcontfail<=$ah_contfail} {
				if {$adj_id<$ADJBIT} {
					set $H_ADJ0($adj_id) [expr 1-$H_ADJ0($adj_id)]
				} else {
					set $tmp_id [expr $adj_id-$ADJBIT]
					set $H_ADJ1($tmp_id) [expr 1-$H_ADJ1($tmp_id)]
				}
			} else {
				set countcontfail 0

				set current_uniform       $new_uniform
				set current_uniform_delta $new_uniform_delta
			}
		} else {
			set countcontfail 0

			set current_uniform       $new_uniform
			set current_uniform_delta $new_uniform_delta
		}

		if {$new_uniform_delta<$BEST_UNIFORM_DELTA} {
			set BEST_ADJ0 $rs_adj0
			set BEST_ADJ1 $rs_adj1
			set BEST_UNIFORM $current_uniform
			set BEST_UNIFORM_DELTA $current_uniform_delta
		}

		puts "$iter: $rs_adj0 $rs_adj1 $current_uniform $current_uniform_delta"

		incr iter
	}
}
#puts "BEST: $BEST_ADJ0 $BEST_ADJ1 $BEST_UNIFORM $BEST_UNIFORM_DELTA"

set ah_adj0 $BEST_ADJ0
set ah_adj1 $BEST_ADJ1
set ah_uniform $BEST_UNIFORM

#ah_file_adj:$FOLDER_CRP/adj/$x.adj
set foutfile [open $ah_file_adj w]
puts $foutfile "$BEST_ADJ0 $BEST_ADJ1 $BEST_UNIFORM"
close $foutfile

#############################
# output:
# ah_adj0
# ah_adj1
# ah_uniform
