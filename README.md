# BIST (Built-In Self-Test) — Verilog Implementation


A complete RTL implementation of a **Built-In Self-Test (BIST)** architecture in Verilog, including pattern generation via LFSR, a 1×4 DEMUX as the Circuit Under Test (CUT), response analysis, and a top-level controller.

---

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Module Descriptions](#module-descriptions)
- [Directory Structure](#directory-structure)
- [Block Diagram](#block-diagram)
- [Simulation](#simulation)
- [Signal Description](#signal-description)
- [Revision History](#revision-history)

---

## Architecture Overview

The BIST system is composed of four main sub-modules integrated by a top-level module:

```
str_bist ──► BIST Controller ──► pat / ra
                                    │
                    ┌───────────────┘
                    ▼
               LFSR (4-bit)  ──► pattern ──► DEMUX 1×4 ──► cut_out[3:0]
                    │                                            │
                    └── shift[3:0] ──► sel[1:0]                 │
                                                                 ▼
                                                     Response Analyser
                                                          │
                                          ┌───────────────┴───────────────┐
                                          ▼               ▼               ▼
                                       pass             fail          bist_done
```

---

## Module Descriptions

### 1. `bist_contr` — BIST Controller
**File:** `src/bist_contr.v`

Controls the overall BIST operation. Activates pattern generation (`pat`) and response analysis (`ra`) when `str_bist` is asserted. Passes `bist_done`, `pass`, and `fail` signals from the response analyser to the top-level outputs.

| Port | Dir | Description |
|------|-----|-------------|
| `str_bist` | Input | Start BIST signal |
| `clk` | Input | Clock |
| `rst` | Input | Reset |
| `bist_done_w` | Input | Done flag from Response Analyser |
| `pass_w` | Input | Pass flag from Response Analyser |
| `fail_w` | Input | Fail flag from Response Analyser |
| `bist_done` | Output | BIST completion indicator |
| `pass` | Output | Test passed |
| `fail` | Output | Test failed |
| `pat` | Output (reg) | Enable pattern generation |
| `ra` | Output (reg) | Enable response analysis |

---

### 2. `lfsr` — 4-bit Linear Feedback Shift Register
**File:** `src/LFSR.v`

Generates pseudo-random test patterns using a 4-bit LFSR with XOR feedback on bits `[3]` and `[0]`. Resets to seed `4'b1010` and signals `pat_done` when it reaches `4'b0101`.

| Port | Dir | Description |
|------|-----|-------------|
| `clk` | Input | Clock |
| `rst` | Input | Async reset (seed: `4'b1010`) |
| `pat` | Input | Enable shifting |
| `pattern` | Output | Serial test pattern (LSB of shift register) |
| `pat_done` | Output (reg) | High when shift reaches `4'b0101` |
| `shift` | Output (reg) [3:0] | Current LFSR state |

---

### 3. `demux1x4` — 1×4 Demultiplexer (Circuit Under Test)
**File:** `src/demux1x4.v`

Acts as the Circuit Under Test (CUT). Routes the input pattern `i` to one of four outputs based on select lines `s0` and `s1`. All outputs have a propagation delay of 5 time units.

| Port | Dir | Description |
|------|-----|-------------|
| `i` | Input | Data input (pattern from LFSR) |
| `s0`, `s1` | Input | Select lines (driven by `shift[1:2]`) |
| `y0–y3` | Output | Demultiplexed outputs |

**Truth Table:**

| s1 | s0 | Active Output |
|----|----|---------------|
| 0  | 0  | y0            |
| 1  | 0  | y1            |
| 0  | 1  | y2            |
| 1  | 1  | y3            |

---

### 4. `resp_analy` — Response Analyser
**File:** `src/res_anal.v`

Compares the CUT output (`cut_out`) against the expected output (`exp_out`) derived from the input pattern and select lines. Asserts `pass` or `fail` accordingly, and asserts `bist_done` when `pat_done` is received.

| Port | Dir | Description |
|------|-----|-------------|
| `ra` | Input | Enable response analysis |
| `clk` | Input | Clock |
| `rst` | Input | Async reset |
| `in` | Input | Original pattern input |
| `pat_done` | Input | Pattern generation complete |
| `exp_sel` [1:0] | Input | Expected output selector |
| `cut_out` [3:0] | Input | CUT output to verify |
| `bist_done` | Output (reg) | BIST done flag |
| `pass` | Output (reg) | Test pass flag |
| `fail` | Output (reg) | Test fail flag |

---

### 5. `top` — Top-Level Integration Module
**File:** `src/top.v`

Integrates all sub-modules. Connects LFSR shift bits `[1:2]` to the DEMUX select and Response Analyser `exp_sel` lines. Wires inter-module signals.

---

### 6. `tb_top` — Testbench
**File:** `tb/tb_top.v`

Top-level testbench. Applies reset, asserts `str_bist`, and runs the simulation for 200 time units. Dumps waveforms to `top.vcd`.

---

## Directory Structure

```
BIST_Project/
├── src/
│   ├── bist_contr.v      # BIST Controller
│   ├── LFSR.v            # 4-bit LFSR Pattern Generator
│   ├── demux1x4.v        # 1×4 DEMUX (Circuit Under Test)
│   ├── res_anal.v        # Response Analyser
│   └── top.v             # Top-level Integration Module
├── tb/
│   └── tb_top.v          # Top-level Testbench
└── README.md
```

---

## Simulation

### Using Icarus Verilog (iverilog)

```bash
# Compile
iverilog -o bist_sim src/top.v tb/tb_top.v

# Run simulation
vvp bist_sim

# View waveforms (GTKWave)
gtkwave top.vcd
```

> **Note:** Since `top.v` uses `` `include `` directives, ensure all source files are in the same directory, or adjust the include paths before compiling.

### Expected Output

- `pass` asserts when CUT output matches expected output at each clock cycle.
- `fail` asserts when a mismatch is detected.
- `bist_done` asserts when the LFSR completes its sequence (`shift == 4'b0101`).

---

## Signal Description (Top-Level)

| Signal | Dir | Width | Description |
|--------|-----|-------|-------------|
| `str_bist` | Input | 1 | Start BIST — activates pattern gen and response analysis |
| `clk` | Input | 1 | System clock |
| `rst` | Input | 1 | Active-high synchronous reset |
| `bist_done` | Output | 1 | Indicates BIST sequence is complete |
| `pass` | Output | 1 | Indicates CUT passed all tests |
| `fail` | Output | 1 | Indicates CUT failed at least one test |
| `shift` | Output | 4 | Current LFSR shift register state |

---

