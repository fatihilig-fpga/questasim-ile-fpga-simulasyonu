#!/bin/bash
vsim -c -do run.tcl
vcover report ./ucdb_lib/merged_coverage.ucdb -details -html -output ./covhtmlreport
