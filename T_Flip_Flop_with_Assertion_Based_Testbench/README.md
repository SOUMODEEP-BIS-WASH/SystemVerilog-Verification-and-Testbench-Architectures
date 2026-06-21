# T Flip-Flop with Assertion-Based Testbench

## Overview
This project implements a **T Flip-Flop (Toggle Flip-Flop)** in SystemVerilog and verifies its functionality using an **Assertion-Based Testbench**.

The verification environment includes:
- Interface-based DUT connection
- SystemVerilog Assertions (SVA)
- Randomized stimulus generation
- Assertion-based validation of toggle, hold, and reset behavior

This project demonstrates how assertions can be used to automatically verify sequential logic behavior.

---

## Features
- T Flip-Flop RTL implementation
- Interface-based verification setup
- Assertion-Based Verification (ABV)
- Randomized stimulus generation
- Automatic pass/fail reporting
- Functional validation of:
  - Toggle operation
  - Hold operation
  - Reset behavior

---

## Design Specifications

### Inputs
- `clk` → Clock signal  
- `rst` → Reset signal  
- `T` → Toggle input  

### Output
- `Q` → Flip-flop output  

---

## DUT Behavior

### Reset Condition
When reset is active:
```text
Q = 0
```

---

### Toggle Condition
When:
```text
T = 1
```

Output toggles on clock edge:

```text
Q(next) = ~Q(current)
```

---

### Hold Condition
When:
```text
T = 0
```

Output remains unchanged:

```text
Q(next) = Q(current)
```

---

## Verification Architecture

```text
assertion_tb
│
├── Interface
├── DUT (TFF)
├── Assertions Module
└── Transaction Class
```

---

## Components

### 1. DUT (`TFF`)
Implements the T Flip-Flop logic.

---

### 2. Interface (`intf`)
Provides a structured connection between DUT and testbench.

Signals included:
- `clk`
- `rst`
- `T`
- `Q`

---

### 3. Assertions Module (`tff_assertions`)
Contains SystemVerilog Assertions to verify DUT behavior.

---

### 4. Transaction Class (`toggle_trans`)
Generates randomized toggle input values.

```systemverilog
randc bit T;
```

---

## Assertions Implemented

---

### Toggle Assertion
Checks that output toggles when `T = 1`.

```text
If T = 1
→ Q(next) must equal NOT Q(current)
```

---

### Hold Assertion
Checks that output remains unchanged when `T = 0`.

```text
If T = 0
→ Q(next) must equal Q(current)
```

---

### Reset Assertion
Checks that output resets properly.

```text
If rst = 1
→ Q must be 0
```

---

## Testbench Flow

1. Initialize testbench  
2. Apply reset  
3. Release reset  
4. Generate randomized toggle inputs  
5. Assertions automatically validate behavior  
6. Print pass/fail messages  

---

## Sample Verification Output

```text
TOGGLE TEST PASSED AT TIME = ...
HOLD TEST PASSED AT TIME = ...
RESET TEST PASSED AT TIME = ...
```

Any failure triggers an error message.

---

## Learning Outcomes
This project demonstrates:
- Assertion-Based Verification (ABV)
- SystemVerilog Assertions (SVA)
- Sequential logic verification
- Interface-based testbench design
- Random stimulus generation
- Automated verification methodology

---

## Tools Used
- SystemVerilog
- AMD Vivado
