## Supper MOSFET Calculator(SMC)
### Triode Mode: (𝑉𝐺𝑆−1>𝑉𝐷𝑆)
Current and Gain Calculation: 
```math
𝐼_𝐷=13⋅𝑊⋅(2(𝑉_{𝐺𝑆}−1)𝑉_{𝐷𝑆}−𝑉_{𝐷𝑆2})
𝑔_𝑚=23⋅𝑊⋅𝑉_{𝐷𝑆}
```
### Saturation mode: 𝑉𝐺𝑆−1≤𝑉𝐷𝑆
Current and Gain Calculation:
- $$𝐼_𝐷=13⋅𝑊⋅(𝑉_{𝐺𝑆}−1)2$$
- $$𝑔_𝑚=23⋅𝑊⋅(𝑉_{𝐺𝑆}−1) $$

Step 1: Calculate Current or Gain for 6 Inputs
- Observe the common factors: W, division by 3, and $$𝑉_{GS}−1𝑉_{GS} - 1V_{GS}−1$$.
- Optimize by factoring out common terms and deferring the division by 3 until after sorting.

Step 2: Sort 6 Results
Implemented with “6-input sorting network". 

Step 3: Compute Average
Use a multiplexer (MUX) to select either the top 3 or bottom 3 values.
### Current Calculation:
Top 3 : 𝐼𝑎𝑣𝑔=112⋅(3×𝑛0+4×𝑛1+5×𝑛2)
Bottom 3 : 𝐼𝑎𝑣𝑔=112⋅(3×𝑛3+4×𝑛4+5×𝑛5)
### Gain Calculation:
Top 3 : 𝑔𝑎𝑣𝑔=13⋅(𝑛0+𝑛1+𝑛2)
Bottom 3 : 𝑔𝑎𝑣𝑔=13⋅(𝑛3+𝑛4+𝑛5)

Key Learnings:
- Factor out common operations to reduce hardware usage.
- Delay costly operations like multiplication and division until necessary. E.g. The division can be postponed until after sorting, reducing the number of dividers from 6 (one for each input) to 3 (only for the sorted results).
- You can use a Multiplexer to select operand A and operand B before performing multiplication. This approach helps to save one multiplier.
- Multiplication optimized by the Design Compiler usually has better performance than trying to optimize it manually. Simplify logic to make it easier for the Design Compiler to optimize.
- Avoid premature optimization in simple designs; focus on understanding the synthesis report.
- You can replace dividers with a lookup table (case statement) to lower cell area, but I didn’t implement it in my attempt.

|234|456|
|:---|---:|
|456|47883|

`1298940`

- [x] 234
- [ ] 65uytuy
