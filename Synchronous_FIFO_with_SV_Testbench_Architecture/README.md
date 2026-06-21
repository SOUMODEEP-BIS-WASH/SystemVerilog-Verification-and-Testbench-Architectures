# Synchronous_FIFO_with_SV_Testbench_Architecture

## Overview
This project implements a **256x8 Synchronous FIFO (First-In-First-Out)** in Verilog and verifies it using a **SystemVerilog layered testbench architecture**.

The FIFO supports synchronous read and write operations using a single clock domain and includes status flags for **FULL** and **EMPTY** conditions. The verification environment uses reusable SV components such as generator, driver, monitor, scoreboard, interface, and functional coverage.

---

## Features
- 256-depth FIFO with 8-bit data width
- Single clock synchronous design
- Supports:
 - Write operation
  - Read operation
  - Simultaneous flag monitoring
- FIFO status flags:
  - `full`
  - `empty`
- Pointer-based circular memory handling
- Reset initialization for memory and pointers
- SystemVerilog layered verification architecture
- Functional coverage collection

---

## FIFO Specifications

| Parameter | Value |
|-----------|-------|
| Depth | 256 |
| Data Width | 8 bits |
| Clock Type | Single Clock |
| Read Mode | Synchronous |
| Write Mode | Synchronous |

---

## Inputs and Outputs

### Inputs
- `clk` → System clock
- `rst` → Reset
- `din[7:0]` → Input data
- `wr_en` → Write enable
- `rd_en` → Read enable

### Outputs
- `dout[7:0]` → Output data
- `full` → FIFO full flag
- `empty` → FIFO empty flag

---

## FIFO Operation

### Write Operation
When:
- `wr_en = 1`
- FIFO is not full

Data is written into FIFO memory and write pointer increments.

### Read Operation
When:
- `rd_en = 1`
- FIFO is not empty

Data is read from FIFO memory and read pointer increments.

### Full Condition
FIFO becomes full when:
- Write pointer wraps around and catches read pointer.

### Empty Condition
FIFO becomes empty when:
- Write pointer equals read pointer.

---

## Verification Architecture

The project uses a complete **SystemVerilog layered testbench architecture**.

### Components

### Interface
Contains DUT signals and clocking blocks:
- Driver clocking block
- Monitor clocking block

### Transaction
Stores FIFO transaction data:
- Input data
- Read/Write controls
- Output data
- Status flags

### Generator
Creates randomized transactions for:
- Write operations
- Read operations

### Driver
Applies generated transactions to DUT.

### Monitor
Observes DUT outputs and samples:
- Input data
- Control signals
- Output data
- Status flags

Also collects functional coverage.

### Scoreboard
Implements FIFO reference model using memory array and compares:
- Expected output
- Actual output

### Environment
Connects all verification components.

### Test
Runs multiple read/write transactions and reports coverage.

---

## Functional Coverage

Coverage is collected for:
- Input data ranges
- Read enable
- Write enable
- Cross coverage between:
  - Write enable
  - Input data bins

Coverage bins:
- Lower half: 0–127
- Upper half: 128–255

---

## Verification Flow

1. Reset DUT
2. Generate write transaction
3. Drive write transaction
4. Monitor outputs
5. Scoreboard comparison
6. Generate read transaction
7. Compare expected vs actual output
8. Collect coverage

---

## Simulation Output
Simulation prints:
- Transaction details
- FIFO status
- Read verification result (PASS/FAIL)
- Functional coverage percentage

Example:
```text
TIME = 45 | Din = 123 | WR_EN = 1 | RD_EN = 0 | FULL = 0 | EMPTY = 0 | DOUT = 0
PASS FOR READ WITH ACTUAL = 123 & EXPECTED = 123
```

---

## Tools Used
- **AMD Vivado**
- Verilog HDL
- SystemVerilog

---

## Learning Outcomes
This project demonstrates:
- Synchronous FIFO design
- Circular buffer implementation
- Pointer-based FIFO control
- Full/Empty detection logic
- Layered verification architecture
- Functional coverage
- Reference model based verification
- Scoreboard-based checking
