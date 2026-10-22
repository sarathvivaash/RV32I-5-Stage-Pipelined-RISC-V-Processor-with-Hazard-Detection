A 32-bit RISC-V processor implemented in SystemVerilog, featuring a five-stage pipeline, data forwarding, load-use hazard detection, and branch/jump handling.

Overview

This project implements an RV32I-inspired pipelined processor and verifies its functionality through simulation using Icarus Verilog and waveform inspection with GTKWave.

Architecture:
The processor follows a five-stage pipeline:
IF — Instruction Fetch: Fetches instructions using the program counter.
ID — Instruction Decode: Decodes instructions, reads registers, generates immediates, and determines control signals.
EX — Execute: Performs ALU operations, forwarding, and branch/jump decisions.
MEM — Memory Access: Performs data memory reads and writes.
WB — Write Back: Writes results back to the register file.

Key Features:
32-bit processor datapath
SystemVerilog RTL implementation
Five-stage pipeline integration
Register file with protection for x0
ALU operations and immediate generation
Data forwarding for dependency handling
Load-use hazard detection and pipeline stalling
Branch and jump control-flow handling
Simulation-based functional testing

Project Structure

riscv_cpu/
├── rtl/          # Processor RTL modules
├── tb/           # SystemVerilog testbenches
├── build/        # Generated simulation build files
├── waveform/     # Simulation waveforms
└── README.md

Tools Used:
SystemVerilog
Icarus Verilog (iverilog, vvp)
GTKWave
Git and GitHub
Linux

Run the Simulation
From the project root:
mkdir -p build
iverilog -g2012 -o build/pipelined_cpu_tb.vvp rtl/*.sv tb/pipelined_cpu_tb.sv
vvp build/pipelined_cpu_tb.vvp
Open the waveform if the testbench generates waveform/pipelined_cpu.vcd:
gtkwave waveform/pipelined_cpu.vcd
The exact waveform filename depends on the testbench's $dumpfile setting.

Verification:
The integrated CPU testbench passed 13 functional checks in the current simulation run. These checks cover selected arithmetic, logical, memory, hazard-related, and control-flow scenarios.
This is simulation-based verification of the tested scenarios; it does not establish exhaustive RV32I compliance.

Current Scope
Completed: RTL implementation, integrated simulation, selected functional checks, and waveform inspection.
Not yet completed: Full ISA compliance verification, synthesis, timing analysis, physical design, and GDSII generation.
