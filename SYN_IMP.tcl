reset_run   synth_1
launch_runs synth_1 -jobs 4
wait_on_run synth_1

reset_run   impl_1
launch_runs impl_1  -jobs 4
wait_on_run impl_1