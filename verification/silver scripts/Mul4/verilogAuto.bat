@echo off 

::Set .v and _tb.v
set source_module=Mul4
set testbentch_module=Mul4_tb

::delete vvp and vcd for regengerate every time
if exist "%testbentch_module%.vvp" (del "%testbentch_module%.vvp" & echo vvp deleted)
if exist "%testbentch_module%.vcd" (del "%testbentch_module%.vcd" & echo vcd deleted)

::Emulation command
iverilog -o "%testbentch_module%.vvp" %testbentch_module%.v %source_module%.v
vvp -n "%testbentch_module%.vvp"
echo with WaveTrace plug-in you don't need to gtkwave "%testbentch_module%.vcd"