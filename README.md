# IC Lab – Lab01: Supper MOSFET Calculator (SMC)

**NCTU-EE IC LAB**  
**Fall 2023**

## Introduction
This lab focuses on designing a Supper MOSFET Calculator (SMC) to calculate the drain current (ID) and transconductance (gm) for different MOSFET configurations. Additionally, the system computes weighted or average results from multiple MOSFET combinations to find either the largest or smallest result.

## MOSFET Background
- **Triode Region (Linear):**  
  `ID = (1/3) * W * [2(VGS-1)VDS - VDS²]`  
  `gm = (2/3) * W * VDS`

- **Saturation Region:**  
  `ID = (1/3) * W * (VGS-1)²`  
  `gm = (2/3) * W * (VGS-1)`

- **Constants Assumed:**  
  `Kn = 1/3`, `Vth = 1`, No body effect or channel length modulation.  
  All calculations use integer math, rounded down.

## Project Description
- **Inputs:** 6 sets of combinations, `{W, VGS, VDS}`. Each input in range `[1,7]`.
- **Mode [1:0]:**
  - `mode[0]`: 1 = calculate current (ID), 0 = calculate transconductance (gm)
  - `mode[1]`: 1 = output larger, 0 = output smaller
- **Output:** 8-bit result ranging `[0,255]`

### Operations
1. **Determine Region** (Triode or Saturation) based on `(VGS - 1)` vs `VDS`
2. **Calculate** each ID or gm using the correct formula.
3. **Sort** the 6 calculated values in descending order.
4. **Compute Result**
   - If `mode[0] == 1` (ID):  
     `Iavg = (3*n0 + 4*n1 + 5*n2) / 12` for larger (mode[1] = 1)  
     `Iavg = (3*n3 + 4*n4 + 5*n5) / 12` for smaller (mode[1] = 0)
   - If `mode[0] == 0` (gm):  
     `gmavg = (n0 + n1 + n2) / 3` for larger (mode[1] = 1)  
     `gmavg = (n3 + n4 + n5) / 3` for smaller (mode[1] = 0)

### Example
- `{mode, W, VGS, VDS}` = `2'b11, {7,3,1}, ...`  → Computes Iavg using the top 3 IDs.
- **Output**: 8-bit unsigned integer result.

## I/O Specification
| Signal | Width | Description |
|--------|-------|-------------|
| W_n, VGS_n, VDS_n | 3 each | Six sets, each value in range [1,7] |
| mode  | 2     | Controls calculation and output |
| out_n | 8     | Output result |

## Specifications
1. **Top Module Name:** `SMC.v`
2. **Synthesis Constraints:**
   - Must have "MET" slack at end of timing report.
   - No latches allowed.
3. **Performance:** Area is the primary optimization target for efficiency in this lab.

## Simulation and Testing
The project includes multiple verification steps:
- **RTL Simulation**: The RTL simulation is performed using Synopsys VCS.
- **Synthesis**: The design is synthesized using Synopsys Design Compiler with TSMC 40nm technology.
- **Gate-Level Simulation**: The synthesized design is simulated using Synopsys VCS.
- **Waveform Debugging**: Synopsys Verdi is used to inspect signals and debug the design.

## Hints
- Prefer behavioral modeling.
- Use submodules to simplify design.
- Design for hardware sharing between operations.

---
