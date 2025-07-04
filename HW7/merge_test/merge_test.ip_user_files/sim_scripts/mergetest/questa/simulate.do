onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib mergetest_opt

do {wave.do}

view wave
view structure
view signals

do {mergetest.udo}

run -all

quit -force
