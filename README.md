
# 🧠 Simple Microprocessor in Verilog

This project implements a basic **microprocessor** using Verilog, including:
- An ALU (Arithmetic Logic Unit)
- A register file with 32 registers
- A top-level control module (`mp_top`)

The design supports a variety of arithmetic and logical operations and includes testbenches to verify each module.

---

## 📂 Project Structure

| File             | Description                                         |
|------------------|-----------------------------------------------------|
| `mp_top.v`       | Top-level module integrating ALU & register file    |
| `alu_tb.v`       | Testbench for ALU module                            |
| `reg_file_tb.v`  | Testbench for register file                         |
| `assi_1212397.pdf`| Project report / assignment PDF                     |

---

## ⚙️ Supported Instructions (Opcodes)

| Operation        | Opcode (6 bits) | Description                       |
|------------------|-----------------|-----------------------------------|
| ADD              | `000100`        | `a + b`                           |
| SUB              | `001110`        | `a - b`                           |
| ABS              | `001000`        | `|a|`                             |
| NEGATE           | `001011`        | `-a`                              |
| MAX              | `001010`        | `max(a, b)`                       |
| MIN              | `000001`        | `min(a, b)`                       |
| AVERAGE          | `001101`        | `(a + b) / 2`                     |
| NOT              | `000110`        | `~a`                              |
| OR               | `001001`        | `a | b`                           |
| AND              | `000101`        | `a & b`                           |
| XOR              | `000111`        | `a ^ b`                           |

---

## 🧪 How to Simulate

You can run the testbenches with any Verilog simulator like **ModelSim**, **Icarus Verilog**, or **Vivado Simulator**.

### 🔹 ALU Test
```bash
iverilog alu_tb.v -o alu_test
./alu_test
```

### 🔹 Register File Test
```bash
iverilog reg_file_tb.v -o reg_test
./reg_test
```

### 🔹 Full Processor Test
```bash
iverilog mp_top.v -o mp_test
./mp_test
```

---

## 🧠 Example Instruction (32-bit)

Each instruction contains:
- `[5:0]`   Opcode
- `[10:6]`  Source Register 1
- `[15:11]` Source Register 2
- `[20:16]` Destination Register

For example:

```
instruction = 32'b000000_00001_00010_00011_XXXX_XXXX
```

Performs an operation on registers `R1`, `R2` and stores result in `R3`.

---

## 📚 Author

Developed as part of an academic project for digital design.

---

## 📝 License

MIT License (or specify if it's a university assignment with different terms).
# ALU-MP
