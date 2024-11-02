# -- File name : run.tcl
# Compiled library path
# set  PRECOMPILED_SIM_XLIB_PATH C:/Work/compiled_lib
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
# Map Xilinx precompiled libraries
vmap xpm                        $env(PRECOMPILED_SIM_XLIB_PATH)/xpm
vmap unisims_ver                $env(PRECOMPILED_SIM_XLIB_PATH)/unisims_ver
vmap secureip                   $env(PRECOMPILED_SIM_XLIB_PATH)/secureip
vmap unimacro_ver               $env(PRECOMPILED_SIM_XLIB_PATH)/unimacro_ver
# Compile DUT
#  Command : "-coveropt 3" sets optimization level to 3
#  Command : "+cover" enables code coverage, by default all types of
#  coverage (s, b, c, e, f, t) are enabled. To enable only certain
#  coverage types, use "+cover=sbf". Here, s = Statement, b = Branch,
#  c = Condition, e = Expression, f = FSM, t = toggle.
vlog -coveropt 3 +cover +acc -incr -mfcu -work xil_defaultlib \
"./top.v" \
"./tb.v"

vlog -work xil_defaultlib "glbl.v"
# --
# ELABORATE DO
# --
vopt +acc=npr -suppress 10016 -L xil_defaultlib \
-L unisims_ver -L unimacro_ver -L secureip -L xpm \
-work xil_defaultlib xil_defaultlib.tb \
xil_defaultlib.glbl -o tb_opt
# --
# Print whether the script is running in compiled mode
if {$batch_mode eq 0} {
  vsim -coverage -lib xil_defaultlib tb_opt
  delete wave -all
  set WildcardFilter [lsearch -not -all -inline $WildcardFilter Memory]
  # Add waveforms
  view wave
  add wave -divider dut
  add wave -expand -group dut -position insertpoint sim:/tb/top_inst/*
  # run 100ns
  run -all
  wave zoomful
  config wave -signalnamewidth 1
  radix -unsigned
} else {
   # Remove ucdb_lib folder if it exists
   file delete -force ./ucdb_lib
   # Create a folder for ucdb_lib which contains coverage reports and ucdb files
   file mkdir ucdb_lib
   vsim -coverage -lib xil_defaultlib tb_opt +nowarnTSCALE -t 1fs -do "coverage save -onexit -directive -codeAll ./ucdb_lib/merged_coverage.ucdb"
   run -all
   exit
}




