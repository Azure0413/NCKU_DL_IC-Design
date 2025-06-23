-makelib xcelium_lib/xilinx_vip -sv \
  "C:/verilog/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
  "C:/verilog/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
  "C:/verilog/Vivado/2018.3/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
  "C:/verilog/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
  "C:/verilog/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
  "C:/verilog/Vivado/2018.3/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
  "C:/verilog/Vivado/2018.3/data/xilinx_vip/hdl/axi_vip_if.sv" \
  "C:/verilog/Vivado/2018.3/data/xilinx_vip/hdl/clk_vip_if.sv" \
  "C:/verilog/Vivado/2018.3/data/xilinx_vip/hdl/rst_vip_if.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib -sv \
  "C:/verilog/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "C:/verilog/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "C:/verilog/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_vip_v1_1_4 -sv \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ipshared/98af/hdl/axi_vip_v1_1_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/processing_system7_vip_v1_0_6 -sv \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ipshared/70cf/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/mergetest/ip/mergetest_processing_system7_0_0/sim/mergetest_processing_system7_0_0.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_3 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ip/mergetest_merge_v1_0_0_0/src/arrayFifo/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_3 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ip/mergetest_merge_v1_0_0_0/src/arrayFifo/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_3 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ip/mergetest_merge_v1_0_0_0/src/arrayFifo/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/mergetest/ip/mergetest_merge_v1_0_0_0/src/arrayFifo/sim/arrayFifo.v" \
  "../../../bd/mergetest/ip/mergetest_merge_v1_0_0_0/src/mergedFifo/sim/mergedFifo.v" \
  "../../../bd/mergetest/ipshared/926e/merge_1.0/hdl/mergeCore.v" \
  "../../../bd/mergetest/ipshared/926e/merge_1.0/hdl/merge_v1_0_S00_AXI.v" \
  "../../../bd/mergetest/ipshared/926e/merge_1.0/hdl/merge_v1_0.v" \
  "../../../bd/mergetest/ip/mergetest_merge_v1_0_0_0/sim/mergetest_merge_v1_0_0_0.v" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_17 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ipshared/c4fd/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_18 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ipshared/cc23/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_protocol_converter_v2_1_18 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ipshared/7a04/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/mergetest/ip/mergetest_auto_pc_0/sim/mergetest_auto_pc_0.v" \
-endlib
-makelib xcelium_lib/lib_cdc_v1_0_2 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \
-endlib
-makelib xcelium_lib/proc_sys_reset_v5_0_13 \
  "../../../../merge_test.srcs/sources_1/bd/mergetest/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/mergetest/ip/mergetest_rst_ps7_0_100M_0/sim/mergetest_rst_ps7_0_100M_0.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/mergetest/sim/mergetest.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

