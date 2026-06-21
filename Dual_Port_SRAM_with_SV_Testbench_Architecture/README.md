# Dual Port SRAM with SV Testbench Architecture

## Overview
This project implements a **256×8 Dual-Port SRAM** in Verilog and verifies it using a structured **SystemVerilog testbench architecture**.

The design supports:
- Simultaneous read and write operations  
- Independent read and write addresses  
- Synchronous operation with clock  
- Reset functionality  

The verification environment uses a layered SV architecture with:
- Transaction
- Generator
- Driver
- Monitor
- Scoreboard
- Environment
- Test

Functional coverage is also included to measure verification completeness.

---

## Design Description

The DUT is a **256-depth, 8-bit Dual-Port SRAM**.

### Inputs
- `clk` → Clock  
- `rst` → Reset  
- `wr_en` → Write enable  
- `rd_en` → Read enable  
- `wr_addr [7:0]` → Write address  
- `rd_addr [7:0]` → Read address  
- `wr_data [7:0]` → Write data  

### Output
- `rd_data [7:0]` → Read data  

---

## Supported Operations

- Write only  
- Read only  
- Simultaneous read and write (different addresses)  
- Reset memory contents  

---

## Verification Architecture

### 1. Interface
Defines DUT signals and includes a **clocking block** for synchronized stimulus and sampling.

---

### 2. Transaction
Represents SRAM transactions.

Contains:
- Reset signal  
- Read enable  
- Write enable  
- Write address  
- Read address  
- Write data  
- Read data  

Constraints:
- At least one operation must be active (`read` or `write`)
- Simultaneous read/write must use different addresses

---

### 3. Generator
Creates randomized SRAM transactions and sends them to driver.

---

### 4. Driver
Applies transactions to DUT through virtual interface using the clocking block.

---

### 5. Monitor
Captures DUT activity:
- Control signals  
- Addresses  
- Data  

Also samples functional coverage.

---

### 6. Scoreboard
Implements a reference SRAM model.

Responsibilities:
- Maintain expected memory contents  
- Track writes  
- Verify reads  
- Report PASS/FAIL  

---

### 7. Environment
Connects all verification components.

Contains:
- Generator  
- Driver  
- Monitor  
- Scoreboard  

---

### 8. Test
Controls verification execution.

---

## Verification Flow

```text
Generator → Driver → DUT → Monitor → Scoreboard
```

1. Generator creates random SRAM transactions  
2. Driver applies operations to DUT  
3. DUT performs read/write  
4. Monitor captures outputs  
5. Scoreboard compares with reference model  

---

## Functional Coverage

Coverage is collected using covergroups.

### Coverpoints
- Write Enable  
- Read Enable  
- Write Address  
- Read Address  
- Write Data  
- Reset  

### Address Bins
Addresses are grouped into:
- LOW (0–63)
- MID (64–127)
- HIGH (128–255)

### Cross Coverage
Cross coverage between:
- Read/Write operations  
- Read/Write address regions  

This ensures broad verification across operational scenarios.

---

## Features
- Dual-port SRAM design  
- Simultaneous read/write support  
- Layered SV testbench architecture  
- Clocking block usage  
- Randomized constrained stimulus  
- Functional coverage  
- Self-checking scoreboard  
- Reference memory model  

---

## Simulation Example

```text
========== SRAM VERIFICATION START ==========
|TIME=120| PASS | RD_ADDR=45 | DATA=AF |
```

Failure example:

```text
|TIME=140| FAIL | RD_ADDR=90 | EXP=3C | GOT=00 |
```

Coverage example:

```text
========== COVERAGE REPORT ==========
Functional Coverage = 97.25 %
```

---

## Tools Used
- **Language:** Verilog + SystemVerilog  
- **Simulator:** AMD Vivado Simulator  

---

## Learning Outcomes
This project helps in understanding:
- Dual-port SRAM design  
- Memory verification methodologies  
- Clocking blocks in SystemVerilog  
- Functional coverage  
- Coverage-driven verification  
- Reference model based verification  
- Self-checking testbench design  

---

This project provides strong practical exposure to memory verification using advanced SystemVerilog testbench architecture.
