##############setup##############
#################################
set_property DISPLAY_RADIX      BINARY [get_hw_probes ch      ]
set_property OUTPUT_VALUE_RADIX BINARY [get_hw_probes ch_seed ]
set_property OUTPUT_VALUE_RADIX BINARY [get_hw_probes adj0    ]
set_property OUTPUT_VALUE_RADIX BINARY [get_hw_probes adj1    ]

set_property CONTROL.TRIGGER_POSITION 0 [get_hw_ilas -of_objects [get_hw_devices $NAME_DEVICE] -filter {CELL_NAME=~"inst_ila"}]