puts "#---------------------------------------------------------"
puts "#-- Title : run.tcl                                       "
puts "#---------------------------------------------------------"
puts "#-- Author        : Fatih ILIG <fatihilig@gmail.com>      "
puts "#--                                                       "
puts "#---------------------------------------------------------"
puts "#-- Description : QuestaSim simulation script (DO file)   "
puts "#---------------------------------------------------------"

# Compiled library path
# Not: If this variable is set on Env variable as bashrc then this line is    # not needed.
# set  PRECOMPILED_SIM_XLIB_PATH C:/Work/compiled_lib
# Map Xilinx precompiled libraries
vmap xpm                        $env(PRECOMPILED_SIM_XLIB_PATH)/xpm
vmap unisims_ver                $env(PRECOMPILED_SIM_XLIB_PATH)/unisims_ver
vmap secureip                   $env(PRECOMPILED_SIM_XLIB_PATH)/secureip
vmap unimacro_ver               $env(PRECOMPILED_SIM_XLIB_PATH)/unimacro_ver
vlib work
vlog "../glbl.v"
# SIMULATION FILES
set vhdl_file_list {
../source/tam_toplayici.vhd
../source/top.vhd}

set verilog_file_list {
../testbench/tb.sv}

# TESTBENCH_ARCH
set TESTBENCH_ARCH tb
# 93 or 2008
set VHDL_VERSION 2008

# Compile
set time_now [clock seconds]
if {![info exists last_compile_time]} {
  set last_compile_time 0};

foreach file $vhdl_file_list {
    puts "$file : [file mtime $file]"
    if { $last_compile_time < [file mtime $file] } {
        vcom -mixedsvvh -$VHDL_VERSION $file
    } else {puts "$file Already compiled"}
}

foreach file $verilog_file_list {
    puts "$file : [file mtime $file]"
    if { $last_compile_time < [file mtime $file] } {
        vlog -mixedsvvh $file
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
add wave -divider DUT
add wave -color LimeGreen -radix unsigned DUT/*
add wave -divider adim_0
add wave -radix binary tb/DUT/adim_0/*
add wave -divider adim_1
add wave -radix binary tb/DUT/adim_1/*
add wave -divider adim_2
add wave -radix binary tb/DUT/adim_2/*
add wave -divider adim_3
add wave -radix binary tb/DUT/adim_3/*
# --
run 100ns
wave zoomful
config wave -signalnamewidth 1
radix -unsigned



