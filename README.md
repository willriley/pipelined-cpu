# pipelined-cpu
3-stage Pipelined RISC-V Microprocessor. The stages are fetch/decode, execute, and mem/writeback. Supports the following instructions: add, addi, sw, lw, add, sub, and, or, slli, mul, beq, bne, jal, jalr.

### Building/Running
TODO

### Improvements
* Add more test programs
* Use Altera RAM module instead of a custom module for instruction mem. (Probably need to switch to 4-stage with separate fetch/decode stages)
* Add branch prediction
* Add caching
