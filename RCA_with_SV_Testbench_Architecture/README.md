# RCA with SV Testbench Architecture

## Overview
This project implements a **4-bit Ripple Carry Adder (RCA)** in Verilog and verifies its functionality using a **SystemVerilog layered testbench architecture**.

The design demonstrates how a structured SV verification environment can be built using reusable components such as:
- Transaction
- Generator
- Driver
- Monitor
- Scoreboard
- Environment
- Test

The verification flow follows a simplified UVM-style architecture using **mailboxes** and **virtual interfaces** for communication between components.

---

## Design Description

The DUT is a **4-bit Ripple Carry Adder**, built using four cascaded Full Adders.

### Inputs
- `a [3:0]` → 4-bit input operand A  
- `b [3:0]` → 4-bit input operand B  
- `cin` → Carry input  

### Outputs
- `sum [3:0]` → Sum output  
- `cout` → Carry output  

### Functional Equation
```text
Result = A + B + Cin
```

---

## Verification Architecture

The testbench uses a layered SV architecture.

### 1. Interface
Encapsulates DUT signals:
- Inputs
- Outputs
- Clock

---

### 2. Transaction
Defines randomized stimulus packet.

Contains:
- Random inputs
- Captured DUT outputs

---

### 3. Generator
Generates randomized transactions.

Responsibilities:
- Randomize input operands
- Send transactions to driver via mailbox

---

### 4. Driver
Applies generated stimulus to DUT.

Responsibilities:
- Receive transaction
- Drive DUT signals using virtual interface

---

### 5. Monitor
Observes DUT behavior.

Responsibilities:
- Capture DUT inputs/outputs
- Forward observed data to scoreboard

---

### 6. Scoreboard
Performs verification.

Responsibilities:
- Compute expected result
- Compare DUT output vs expected output
- Report PASS/FAIL

---

### 7. Environment
Connects all verification components.

Contains:
- Generator
- Driver
- Monitor
- Scoreboard
- Mailboxes

---

### 8. Test
Top-level controller for verification execution.

---

## Verification Flow

```text
Generator → Driver → DUT → Monitor → Scoreboard
```

1. Generator creates random test vectors  
2. Driver applies vectors to DUT  
3. DUT computes outputs  
4. Monitor captures outputs  
5. Scoreboard compares with expected result  

---

## Features
- Modular SV testbench architecture  
- Mailbox-based communication  
- Virtual interface usage  
- Random stimulus generation  
- Self-checking scoreboard  
- Clear separation of verification components  

---

## Simulation Example

Example scoreboard output:

```text
=========SCOREBOARD=========
PASS FOR:
A = 0101 | B = 0011 | Cin = 1
SUM = 1001 | Cout = 0 | EXPECTED = 01001
```

---

## Tools Used
- **Language:** Verilog + SystemVerilog  
- **Simulator:** AMD Vivado Simulator  

---

## Learning Outcomes
This project helps in understanding:
- Ripple Carry Adder design  
- SystemVerilog OOP concepts  
- Layered testbench architecture  
- Mailbox communication  
- Virtual interfaces  
- Functional verification methodology  

---

This project serves as a strong foundation before moving to advanced methodologies like **UVM**.
