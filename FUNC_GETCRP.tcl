# FUNCTION GET CRP : REPEAT SEED
set FILE_CSV $FOLDER_CRP/csv/tmp.csv
# input:
# rs_adj0
# rs_adj1
# rs_num_active
# rs_ch_seed()
# rs_repeat

#vio核rst信号初始化为0
set_property OUTPUT_VALUE 0 [get_hw_probes rst]
commit_hw_vio [get_hw_probes rst]
#vio核start信号初始化为0
set_property OUTPUT_VALUE 0 [get_hw_probes start]
commit_hw_vio [get_hw_probes start]

#adj0和adj1
set_property OUTPUT_VALUE $rs_adj0 [get_hw_probes adj0]
commit_hw_vio [get_hw_probes adj0]
set_property OUTPUT_VALUE $rs_adj1 [get_hw_probes adj1]
commit_hw_vio [get_hw_probes adj1]


for {set rs_r 0} {$rs_r<$rs_repeat} {incr rs_r} {
	
	#每次循环产生的激励响应对的个数rs_num_crp
	set rs_num_crp 0
	#rs_num_active种子数量
	for {set rs_a 0} {$rs_a<$rs_num_active} {incr rs_a} {	
		#添加种子
		set_property OUTPUT_VALUE $rs_ch_seed($rs_a) [get_hw_probes ch_seed]
		commit_hw_vio [get_hw_probes ch_seed]	
		#ila wait
		#设置ila触发条件：start信号触发条件0-1跳变
		set_property TRIGGER_COMPARE_VALUE eq1'bR [get_hw_probes start_1]
		run_hw_ila [get_hw_ilas -of_objects [get_hw_devices $NAME_DEVICE] -filter {CELL_NAME=~"inst_ila"}]
		#vio act
		#设置vio核start核rst信号进行触发
		set_property OUTPUT_VALUE 1 [get_hw_probes rst]
		commit_hw_vio [get_hw_probes rst]
		set_property OUTPUT_VALUE 0 [get_hw_probes rst]
		commit_hw_vio [get_hw_probes rst]
		set_property OUTPUT_VALUE 1 [get_hw_probes start]
		commit_hw_vio [get_hw_probes start]
		set_property OUTPUT_VALUE 0 [get_hw_probes start]
		commit_hw_vio [get_hw_probes start]
		#ila active
		#ila核捕捉4096个周期内波形变化，并把结果输出为csv文件
		wait_on_hw_ila [get_hw_ilas -of_objects [get_hw_devices $NAME_DEVICE] -filter {CELL_NAME=~"inst_ila"}]
		upload_hw_ila_data [get_hw_ilas -of_objects [get_hw_devices $NAME_DEVICE] -filter {CELL_NAME=~"inst_ila"}]
		write_hw_ila_data -csv_file $FILE_CSV -force
		#extrac tmp.csv
        
		#处理tmp.csv文件，并利用正则表达式
		#从中提取出sample，ch，和rsp
		#当sample取模29个时钟周期为0时，添加相应的激励ch 和响应rsp到数组中rs_crp_ch，rs_crp_rsp。
		#在RUN_ADJ_MANUAL中激励响应对数应为141：即rs_cpr_ch，rs_crp_rsp的size为141
		set rs_fcsv [open $FILE_CSV r]
		while {[gets $rs_fcsv line] >= 0} {
			if {[regexp {(\d+),\d+,\d,(\d+),(\d),\d} $line match sample ch rsp]==1} {
				if {$sample>1 && [expr $sample%($CYCLE_TOTAL-1)]==0} {
					set rs_crp_ch($rs_num_crp)  $ch
					set rs_crp_rsp($rs_num_crp,$rs_r) $rsp
					incr rs_num_crp
				}
			}
		}
		close $rs_fcsv
	}
}

set rs_uniform  0.0
set rs_reliable 0.0
for {set rs_c 0} {$rs_c<$rs_num_crp} {incr rs_c} {
	set thisrsp 0.0
	for {set rs_r 0} {$rs_r<$rs_repeat} {incr rs_r} {
		set thisrsp [expr $thisrsp+$rs_crp_rsp($rs_c,$rs_r)]
	}
	set thisrsp [expr double($thisrsp)/double($rs_repeat)]
	
	if {$thisrsp>0.5} {
		set rs_uniform  [expr $rs_uniform+1.0]
	}
	if {$thisrsp<0.5} {
		set rs_reliable [expr $rs_ reliable+1.0-$thisrsp]
	} else {
		set rs_reliable [expr $rs_reliable+$thisrsp]
	}
}
set rs_uniform  [expr double($rs_uniform)/double($rs_num_crp)]
set rs_reliable [expr double($rs_reliable)/double($rs_num_crp)]

#puts "Uniform:  $rs_uniform"
#puts "Reliable: $rs_reliable"
#puts "$rs_adj0 $rs_adj1 $rs_uniform"

# output:
# rs_num_crp
# rs_crp_ch()
# rs_crp_rsp()
# rs_uniform
# rs_reliable