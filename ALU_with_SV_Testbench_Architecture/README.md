# Project 3: ALU with SV Testbench Architecture

## Overview
This project implements a **4-bit Arithmetic Logic Unit (ALU)** in Verilog and verifies it using a structured **SystemVerilog testbench architecture**.

The verification environment follows a layered architecture using:
- Transaction
- Generator
- Driver
- Monitor
- Scoreboard
- Environment
- Test

The testbench also includes **functional coverage** to measure verification completeness.

---

## Design Description

The DUT is a **4-bit ALU** capable of performing arithmetic and logical operations based on a 3-bit select signal.

### Inputs
- `a [3:0]` → Operand A  
- `b [3:0]` → Operand B  
- `s [2:0]` → Operation select  

### Output
- `y [7:0]` → ALU output  

---

## Supported Operations

| Select | Operation |
|--------|-----------|
| `000` | Addition (`a + b`) |
| `001` | Subtraction (`a - b`) |
| `010` | Multiplication (`a * b`) |
| `011` | Division (`a / b`) |
| `100` | Bitwise AND |
| `101` | Bitwise OR |
| `110` | Bitwise NAND |
| `111` | Bitwise NOR |

---

## Verification Architecture

### 1. Interface
Encapsulates DUT signals:
- Inputs
- Outputs
- Clock

---

### 2. Transaction
Represents randomized ALU stimulus.

Contains:
- Random operands
- Operation select
- DUT output
- Expected output

Constraints:
- Operands within valid range (0–15)
- Division by zero avoided

---

### 3. Generator
Generates randomized transactions and sends them to driver.

---

### 4. Driver
Applies randomized stimulus to DUT through virtual interface.

---

### 5. Monitor
Observes DUT behavior and captures:
- Inputs
- Outputs
- Operation select

Also samples functional coverage.

---

### 6. Scoreboard
Implements reference model for ALU operations.

Responsibilities:
- Compute expected output
- Compare DUT output with reference model
- Report PASS/FAIL

---

### 7. Environment
Connects all components using mailboxes.

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

1. Generator creates random ALU transactions  
2. Driver applies stimulus  
3. DUT performs selected operation  
4. Monitor captures results  
5. Scoreboard validates output  

---

## Functional Coverage

Coverage is implemented using covergroups.

### Coverpoints
- Operand A ranges:
  - LOW
  - MID
  - HIGH

- Operand B ranges:
  - LOW
  - MID
  - HIGH

- Operation type:
  - Arithmetic operations
  - Logical operations

### Cross Coverage
Cross coverage between:
- Operand A
- Operand B
- Operation type

This ensures broad verification across input combinations and operation classes.

---

## Features
- Layered SV testbench architecture  
- Randomized constrained stimulus  
- Functional coverage  
- Coverage-driven verification  
- Self-checking scoreboard  
- Mailbox-based communication  
- Virtual interface usage  

---

## Simulation Example

```text
==============SCOREBOARD=============
PASS FOR:
A = 0101 | B = 0011 | S = 000 | Y = 00001000 | EXPECTED = 00001000
```

Coverage example:

```text
==============COVERAGE=============
FUNCTIONAL COVERAGE = 96.50 %
```

---

## Tools Used
- **Language:** Verilog + SystemVerilog  
- **Simulator:** AMD Vivado Simulator  

---

## Learning Outcomes
This project helps in understanding:
- ALU design  
- SystemVerilog OOP concepts  
- Layered verification architecture  
- Functional coverage  
- Coverage-driven verification  
- Self-checking testbenches  

---

This project provides practical exposure to advanced verification methodologies beyond basic simulation-based testing.
