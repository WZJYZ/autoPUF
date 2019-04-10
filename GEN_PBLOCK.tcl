##########Pblock
set fout [ open "$FOLDER_CONSTRS/new/pblock.xdc" w ]
puts $fout "create_pblock pblock_1"
puts $fout "resize_pblock \[get_pblocks pblock_1\] -add $PBLOCK_CONTR"
puts $fout "add_cells_to_pblock \[get_pblocks pblock_1\] \[get_cells -quiet \[list chcontrol lfsr buf_ch_adj dbg_hub inst_ila inst_vio\]\]"
close $fout
add_files -fileset constrs_1 "$FOLDER_CONSTRS/new/pblock.xdc"
##########