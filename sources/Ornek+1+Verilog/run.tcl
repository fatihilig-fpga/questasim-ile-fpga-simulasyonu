# Compiled library path
# Not: If this variable is set on Env variable as bashrc then this line is    # not needed.
# set  PRECOMPILED_SIM_XLIB_PATH C:/Work/compiled_lib
# Map Xilinx precompiled libraries
vmap xpm                        $env(PRECOMPILED_SIM_XLIB_PATH)/xpm
vmap unisims_ver                $env(PRECOMPILED_SIM_XLIB_PATH)/unisims_ver
vmap secureip                   $env(PRECOMPILED_SIM_XLIB_PATH)/secureip
vmap unimacro_ver               $env(PRECOMPILED_SIM_XLIB_PATH)/unimacro_ver
vlib work
vlog "glbl.v"
# SIMULATION FILES
set file_list {
  "./ip/clk_wiz_0/clk_wiz_0_clk_wiz.v"
  "./ip/clk_wiz_0/clk_wiz_0.v"
  "./top.v"
  "./tb.v"
}
# TESTBENCH_ARCH
set TESTBENCH_ARCH tb
# Compile
set time_now [clock seconds]
if {![info exists last_compile_time]} {
  set last_compile_time 0};
foreach file $file_list {
    puts "$file : [file mtime $file]"
    if { $last_compile_time < [file mtime $file] } {
        vlog $file
    } else {puts "$file Already compiled"}
}
set last_compile_time $time_now;
# simulate
if {![info exists VSIM_RUN]} {
   echo RUN_VSIM
   vsim -voptargs="+acc=npr" -L unisims_ver -L unimacro_ver \
   -L secureip -L xpm -t 1ps -lib work $TESTBENCH_ARCH glbl
} else {
   echo VSIM already running....
   restart -force
   delete wave *
}
set VSIM_RUN YES
# Add waveforms
view wave
add wave -divider TB
add wave -noupdate -expand -group TB -position insertpoint sim:/tb/*
add wave -divider DUT
add wave -noupdate -expand -group DUT -position insertpoint sim:/tb/top_inst/*
#
run -all
wave zoomful
config wave -signalnamewidth 1
radix -unsigned


