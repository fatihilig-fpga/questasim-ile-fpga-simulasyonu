# -- File name : run.tcl
# Search for the "-c" parameter in the command-line arguments
set batch_mode 0
foreach arg $argv {
    if {$arg eq "-c"} {
        set batch_mode 1
        puts "c is used $batch_mode"
        break
    }
}

#Remove questa_lib folder if exist
file delete -force questa_lib
mkdir questa_lib
# COMPILE DO
vlib questa_lib/work
vlib questa_lib/msim
vlib questa_lib/msim/xil_defaultlib
vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vlog  -incr -mfcu -work xil_defaultlib \
"./tb.sv"
vlog -work xil_defaultlib "glbl.v"
# --
# ELABORATE DO
# --
vopt +acc=npr -suppress 10016 -L xil_defaultlib \
-work xil_defaultlib xil_defaultlib.tb \
xil_defaultlib.glbl -o tb_opt
# --
# SIMULATE DO
# --
vsim -lib xil_defaultlib tb_opt

# Print whether the script is running in compiled mode
if {$batch_mode eq 0} {
  delete wave -all
  set WildcardFilter [lsearch -not -all -inline $WildcardFilter Memory]
  # Add waveforms
  view wave
  add wave -divider TB
  add wave -position insertpoint sim:/tb/*
}
# --
run -all
if {$batch_mode eq 0} {
  wave zoomful
  config wave -signalnamewidth 1
  radix -unsigned
}




