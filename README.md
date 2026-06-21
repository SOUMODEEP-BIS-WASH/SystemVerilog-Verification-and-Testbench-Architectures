# SystemVerilog-Verification-and-Testbench-Architectures

## Overview
This repository contains a collection of **SystemVerilog-based verification projects** focused on modern digital design verification methodologies.

The repository demonstrates verification approaches ranging from **assertion-based verification** to **layered SystemVerilog testbench architectures**, covering combinational and sequential digital designs such as flip-flops, arithmetic circuits, memory blocks, and FIFO buffers.

These projects were developed using **AMD Vivado** and are intended to strengthen understanding of RTL verification, constrained random testing, functional coverage, assertions, and scoreboard-based validation.

---

## Repository Objectives
- Learn modern digital verification methodologies
- Build reusable SystemVerilog verification environments
- Practice assertion-based verification
- Implement layered testbench architecture
- Use constrained random stimulus generation
- Perform functional coverage analysis
- Validate DUT behavior using reference models and scoreboards

---

# Projects Included

## 1. T_Flip_Flop_with_Assertion_Based_Testbench
Verification of a T Flip-Flop using **SystemVerilog Assertions (SVA)**.

### Key Concepts
- Assertion-Based Verification (ABV)
- Toggle property checking
- Hold property checking
- Reset verification
- Randomized stimulus generation

### Assertions Implemented
- Toggle behavior
- Hold behavior
- Reset behavior

---

## 2. RCA_with_SV_Testbench_Architecture
Verification of a **4-bit Ripple Carry Adder** using layered SV testbench architecture.

### Key Concepts
- Interface-based connectivity
- Transaction modeling
- Generator
- Driver
- Monitor
- Scoreboard

### Verification Features
- Random stimulus generation
- Expected sum computation using reference model
- PASS/FAIL reporting

---

## 3. ALU_with_SV_Testbench_Architecture
Verification of a **4-bit Arithmetic Logic Unit (ALU)**.

### Supported Operations
- Addition
- Subtraction
- Multiplication
- Division
- AND
- OR
- NAND
- NOR

### Key Concepts
- Constrained random verification
- Functional coverage
- Coverage bins
- Scoreboard-based verification

---

## 4. Dual_Port_SRAM_with_SV_Testbench_Architecture
Verification of a **256x8 Dual Port SRAM**.

### Features
- Simultaneous read/write support
- Separate read/write addresses
- Memory reference model
- Functional coverage for:
  - Addresses
  - Data ranges
  - Read/Write operations

### Verification Features
- Random memory transactions
- Coverage analysis
- Read-data validation

---

## 5. Synchronous_FIFO_with_SV_Testbench_Architecture
Verification of a **256x8 Synchronous FIFO**.

### Features
- Single clock FIFO
- Full/Empty flag generation
- Read/Write pointer logic
- Circular buffer implementation

### Verification Features
- Reference FIFO model
- Functional coverage
- Scoreboard checking
- Read-data validation

---

# Verification Architecture

Most projects follow a layered verification architecture:

```text
Generator → Driver → DUT → Monitor → Scoreboard
```

### Components

## Interface
Encapsulates DUT signals and clocking blocks.

## Transaction
Stores transaction-level stimulus and response data.

## Generator
Produces randomized test scenarios.

## Driver
Applies transactions to DUT.

## Monitor
Captures DUT behavior.

## Scoreboard
Compares DUT output with reference model.

## Environment
Integrates all verification components.

## Test
Controls simulation execution.

---

# Verification Methodologies Covered

- Assertion-Based Verification (ABV)
- Constrained Random Verification (CRV)
- Functional Coverage
- Scoreboard Verification
- Reference Model Validation
- Layered Testbench Architecture

---

# Tools Used
- **AMD Vivado**
- Verilog HDL
- SystemVerilog
- SystemVerilog Assertions (SVA)

---

# Key Learning Outcomes
This repository helped in understanding:

- Writing reusable verification environments
- Designing transaction-based testbenches
- Assertion writing in SystemVerilog
- Functional coverage collection
- Scoreboard and reference model creation
- Verification of memory and FIFO architectures
- Verification of combinational and sequential circuits

---

# Repository Structure

```text
systemverilog-verification-projects/
│
├── 01_T_Flip_Flop_with_Assertion_Based_Testbench/
├── 02_RCA_with_SV_Testbench_Architecture/
├── 03_ALU_with_SV_Testbench_Architecture/
├── 04_Dual_Port_SRAM_with_SV_Testbench_Architecture/
└── 05_Synchronous_FIFO_with_SV_Testbench_Architecture/
```

---

