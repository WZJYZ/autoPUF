# FUNCTION GEN CH SEED

# input:
# cs_file_adjchseed
# cs_num_crp

#在RUN_ADJ_MANUAL中$cs_num_crp=100
# cs_num_active: 100/((4096-1)/(30-1)) + 1 = 100/141 + 1 = 1
#也就是生成的种子的数量
set cs_num_active [expr $cs_num_crp/(($ILA_SIZE-1)/($CYCLE_TOTAL-1))+1]

set foutchseed [open $cs_file_adjchseed w]
#
puts $foutchseed $cs_num_active
for {set i 0} {$i<$cs_num_active} {incr i} {
	#调用RANDBINARY函数生成长度为32的种子
	set ch_seed [RANDBINARY $CHBIT]
	#将种子保存在adj/m.chseed文件中
	puts $foutchseed $ch_seed
}

close $foutchseed

# output: