#<
set ah_maxiter 100
set ah_contfail 1

set cs_file_adjchseed $FOLDER_CRP/adj/a.chseed
set cs_num_crp 100
#>

source $FOLDER_CODE/FUNC_GENCHSEED.tcl
set ah_file_adj_chseed $cs_file_adjchseed

################################################
#################### 50% #######################
################################################
#if {.}{...}
#这个if用来进行调试。
#if {1}{...} 则代码块可以运行。
#if {0}{...} 则代码块相当于注释掉。OK
#<
if {1} {
#>
#初始化调整信号
  set ah_check_01 1
  set ah_adj_init ""
  #ah_adj_fix和ah_adj_init都是64位
  for {set i 0} {$i<[expr 2*$ADJBIT]} {incr i} {
  	set ah_adj_fix($i) 0
    #[expr int(2*rand())] 产生01比特序列
  	append ah_adj_init [expr int(2*rand())]
  }
#设置uniform目标值

# set ah_uniform_target 0.5  
  set ah_uniform_target 0.5
#<
# set ah_file_adj $FOLDER_CRP/adj/50.adj
  set ah_file_adj $FOLDER_CRP/adj/50.adj
#>

  source $FOLDER_CODE/FUNC_ADJHEURISTIC.tcl

  puts "$ah_uniform_target : $ah_adj0 $ah_adj1 $ah_uniform"
}
################################################
############### fix adj bit ####################
################################################
#将上一步获得的$ah_adj0和$ah_adj1合并到ah_adj_init
#然后从50%的uniform左右进行调整。
#<
if {0} {
#>
#0-31
  set ah_adj_init ""
  set chars [split $ah_adj0 ""]
  for {set i 0} {$i<$ADJBIT} {incr i} {
    set ah_adj_fix($i) [lindex $chars $i]
    append ah_adj_init $ah_adj_fix($i)
  }

#31-63
  set chars [split $ah_adj1 ""]
  for {set i 0} {$i<$ADJBIT} {incr i} {
    set j [expr $ADJBIT+$i]
    set ah_adj_fix($j) [lindex $chars $i]
    append ah_adj_init $ah_adj_fix($j)
  }
}

#寻找目标分别为uniform为0.1，0.3，0.7和0.9的调整信号
#<
if {0} {
#>
  set ah_check_01 0
#<
  #x=10,30,70,90
  for {set x 10} {$x<=90} {set x [expr $x+20]} {
#<
    if {$x!=50} {
      set ah_uniform_target [expr double($x)/100.0]
#<
      set ah_file_adj $FOLDER_CRP/adj/$x.adj
#>
      source $FOLDER_CODE/FUNC_ADJHEURISTIC.tcl
      puts "$ah_uniform_target : $ah_adj0 $ah_adj1 $ah_uniform"
    }
  }
}
