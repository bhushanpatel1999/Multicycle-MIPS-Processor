# Lab 5

## Assignment

The microprocessor at the heart of any computer system may have
previously seemed like a mystical device controlled inside by an army of
miniature clones of Professor Reddi. As it so happens, that theory was
disproven just last semester. In this assignment, you will implement a
multicycle processor supporting a significant subset of the MIPS
instruction set architecture.  

<span id="introduction">

<span><span>**Introduction**</span></span>

In the prior labs, you have learned the ins-and-outs of `SystemVerilog`
and, more generally, digital design. In fact, you have learned all that
you need to know to build your own processor. The combinational and
sequential logic needed for arithmetic circuits, memory, and timing are
familiar to you having designed an arithmetic logic unit, various finite
state automata, and even a MIPS-architecture-specific assembler.
Naturally, your efforts should culminate in a capstone project:
**designing, testing, and synthesizing a MIPS multicycle processor**.

<span> </span> <span> </span>

>We highly
recommend reading Chapter 7 (especially sections 7.4) in Harris & Harris
as you complete the lab. Additionally, we recommend closely examining
the handout code before starting.

**Please read the lab guide carefully.** The examples shown are just
that—*examples*. Your processor and states might look different, and you
will undoubtedly need to expand upon what is shown to support all
instructions required.  

<div id="retrieving-handout">

<span><span>**Retrieving
Handout**</span></span>

</div>

>Please click this [link](https://classroom.github.com/a/AGLODV8a) to clone the Lab 5
handout code repository.

<div id="spec">

### Specification

</div>

Your multicycle processor should support the following MIPS
instructions:

| R-types | I-types | J-types |
| :------ | :------ | :------ |
| `and`   | `andi`  | `j`     |
| `or`    | `ori`   | `jal`   |
| `xor`   | `xori`  | `jr`    |
| `nor`   | `slti`  |         |
| `sll`   | `addi`  |         |
| `srl`   | `beq`   |         |
| `sra`   | `bne`   |         |
| `slt`   | `lw`    |         |
| `add`   | `sw`    |         |
| `sub`   |         |         |
| `nop`   |         |         |

Note that although `jr` is actually an R-type we include it in the
J-type section because it uses the processor’s jump functionality.

<div id="simulation">

### Simulation

</div>

Your design should work correctly in simulation. We have provided a
template testbench for you to extend with your own tests in `cpu_tb.sv`.
You *may* want to create tests in phases as you bring new functionality
online (e.g., an initial test for fetching instructions).

<div id="synthesis">

### Synthesis

</div>

The top module (found in `cpu_top.sv`) will instantiate your processor
design and connect it to the seven-segment display and on-board
switches. A clock divider is used to slow the clock down so that the
processor can run at a slower speed for debugging.

<span> </span> <span> </span>

> The first
six switches (`sw[5:0]`) on the board determine the clock divisor (i.e.,
turning on more switches will make the processor run slower). The first
LED (`led[0]`) displays the divided clock signal (`clk_en`) so you can
visually inspect the speed.

During the operation of your processor, you might want to see the
instruction running in the current set of clock cycles (your multicycle
processor is **not** pipelined, so instructions complete one at a time).

<span> </span> <span> </span>

> If `sw[14]` is high, then the seven-segment display digits will show the
currently executing instruction.

You may *also* want to inspect the data in memory or a given register as
your processor runs through your pre-loaded instructions.

<span> </span> <span> </span>

> If `sw[14]` is **low**, then the seven-segment display digits will show the
data retrieved as determined by a read address given on the eight switches `sw[13:6]`:
>  - If `sw[15]` is high, then the read address will be used to read data
    from main memory (shared instruction and data memory—von Neumann
    architecture discussed later in section [1.4](#testing) as well as
    section [2.1](#memory) of the guide). Those 8 address bits on
    `sw[13:6]` are used to address a specific *word* in memory (thereby
    giving you access to 256 words).
>  - If `sw[15]` is low, then the lower bits of the read address
    (`sw[10:6]`) will be used to read from the register file—which has
    32 registers and thereby only needs 5 address bits.

**Note:** the MIPS ISA is *byte*-addressable and so the lower two bits
of any address are \(0\) to remain divisible by \(4\). When writing your
assembly, your direct memory accesses via base-addressing should adhere
to this constraint; however, even if you don’t, a closer look at the
provided `rw_ram.sv` module (discussed in section [2.1](#memory)) would
indicate that the lower two bits are actually entirely ignored for the
aforementioned reason.

> When debugging on your development board, though, to extend the
accessible range of memory, we have made **your switches address an
entire *word* of memory**, thereby appending `4’b0000` to the end of
your address entry on `sw[13:6]`. We do this because your seven-segment
display digits show the full word (4 bytes, 32 bits) pulled from memory
(no matter a given byte offset—remember, MIPS is *byte*-addressable), so
it’s better to extend the range of addresses you can access through
physical debugging.

<div id="testing">

### Testing

</div>

> To load data into the memory before the processor is started, put your
hexadecimal instruction memory values in `asm/instr.mem` and your
hexadecimal data memory values in `asm/data.mem` (you might not have any
data memory in your tests and that’s fine).

To generate the `instr.mem` hexadecimal machine code file from a MIPS
assembly code file, you may use your assembler from Lab 4, or you may
use the MARS MIPS assembler which has been provided in the `asm`
directory. Use `./assemble.sh test.asm` (where `test.asm` holds your
assembly in the `hdl/asm/` directory) to create the `instr.mem` file.
(**Note:** it requires Java runtime environment to execute, but we’ve
already installed `jre` on your VM.)

See section [1.3](#synthesis) for tips on using your FPGA to debug while
testing, in concert with a wide array of accompanying simulation-based
tests.

## Processor elements

The three main components of the processor are the datapath, control
unit, and the memory.

The control unit and datapath, together, constitute the processor itself
while the memory is external and allows the processor to interact with
other devices and peripherals. These main components, as well as their
internal elements, are outlined below.

<div id="memory">

### Memory

</div>

> We provide a synchronous single-port RAM implementation in the
`rw_ram.sv` file.

It includes an additional “debug” read port for viewing RAM contents
while the design is running on the FPGA. (During simulation, this port
can be ignored.) The RAM module should not be an internal part of your
processor—it is an external element and should be instantiated
separately and connected through the input and output ports of your
processor. (See the `SystemVerilog` course reader for more details on
modeling memory.)  

In the \(2^{32}\) bytes (4GB) address space of the MIPS memory map, the
*text segment*, which stores the machine language program (**instruction
memory**) begins at address `0x00400000` (as was the specification for
your assembler in Lab 4) and stretches to an upper bound limited such
that the `j` instruction can directly jump to any address in the program
(\~256MB). In this lab, we place **data memory** in the lower MIPS
*reserved segment* which starts at address `0x0`.  

Thanks to the MIPS-enforced address separation, we are able to provide
you a single memory module which supports **both** memory regions in the
same module (a *von Neumann* architecture—as opposed to a *Harvard*
architecture with separate memories, like the one employed in the
Harvard Mark I on display in the Allston Science & Engineering Complex).

<div id="datapath">

### Datapath

</div>

The datapath is where the main computations are performed in your
processor. It consists of different stages separated by internal
registers (the the *multicycle* aspect of the processor). Since certain
instructions may only need to use a subset of the available stages, the
staged design allows additional efficiency over the single-cycle
processor where the clock frequency governing every instruction must be
chosen based on the slowest instruction.

Note that the datapath shown in the textbook only implements a subset of the instructions we ask you to implement. **You will have to modify it.**

Within the datapath, you will need to use components such as a register
file, an ALU, multiplexers, a sign-extender, and various internal
registers.

> For internal registers, we provide the file, `reg_en.sv` which is an
implementation of a register with reset and synchronous enable (use with
your divided `clk_en`).

You may find it useful or necessary to modify the register implementation or create your own.

<div id="alu">

#### Arithmetic Logic Unit (ALU)

</div>

> A provided ALU is defined in `alu.sv` and supports a zero flag as well as the operations listed below (opcode `` `defines `` shown in parentheses are included in `cpu.svh`).

  - and (`ALU_AND`)

  - or (`ALU_OR`)

  - xor (`ALU_XOR`)

  - nor (`ALU_NOR`)

  - signed addition (`ALU_ADD`)

  - signed subtraction (`ALU_SUB`)

  - signed “set less than” (`ALU_SLT`)

  - shift right logical (`ALU_SRL`)

  - shift left logical (`ALU_SLL`)

  - shift right arithmetic (`ALU_SRA`)

<div id="register-file">

#### Register file

</div>

> A provided register file is defined in `reg_file.sv` and supports two
read ports and one write port.

It also supports one additional “debug” read port for displaying the
contents of a register when running on the FPGA. (During simulation this
port can be ignored.) The register file is parameterized, but by default
it is specified to be \(32\times32\) (the size of a standard 32-bit MIPS
processor register file).

<div id="control">

### Control

</div>

The control unit generates the select and control signals that govern
*how* the datapath performs its computation for a given instruction.
Since the processor is multicycle, as the instruction advances through
the stages of the datapath, the control unit must continuously update
the control signalsṄote that multiple stages in your datapath may be put
to use simultaneously; for example, you might compute the next
instruction location (using the ALU) while simultaneously reading data
from the register file into an internal register. Since the control
signals must update over time, we implement the control unit as an FSM.

The FSM shown in the textbook only supports a subset of the instructions we ask
you to implement. **You will need to modify it**. You may choose to
implement your control unit in a separate module (for modular, readable
code purposes). Use `typedef enum` to make state enumeration
self-adjusting (bitwidth).

<div id="clock-divider">

### Clock divider

</div>

> A provided clock divider is defined in `clk\_divider.sv`.

As in Lab 3, to maintain the synchronous nature of the design, your
processor should accept a high-speed clock (`clk_100M`) **and** the
divided version (`clk_en`). When using flip flops in your design, the
high-speed clock should be used as the clock input, and the divided
clock should be used as the enable. This ensures that our flip flops are
fully synchronous but will only operate at the divided clock speed. If
we connected the divided clock directly to the clock input of the flip
flop, this may result in additional clock skew. In general, one single
clock should be used for all flip flops.

## Hints & Tips

  - A simple test can make use of the `NOR`   instruction to get
    `0xFFFFFFFF` (`-1` in decimal) into any register, i.e. `NOR \$1,
    \$0, \$0` will put the value `-1` into register `$1`.

>  - The first thing your processor should be
    able to do is **fetch
    instructions**. Prioritize implementing your fetch unit and make
    sure that the `IR` (instruction register) gets loaded with the
    correct instruction each fetch state. Additionally, make sure that
    your `PC` increments by 4 at the completion of an instruction (of
    course, a non-control flow, non-jump instruction).

>  - Implement a decoder module that converts the 32-bits of the current
    instruction (in your `IR`) into meaningful sub-fields (`opcode`,
    `funct`, `rs`, `rt`, `rd`, `imm`, etc.).

>  - Implement another decoder module to translate `funct` codes into
    actions for the ALU.

  - We strongly recommend making liberal use of header files (`*.svh`)
    for defining various constants. This will make your code readable
    and easy to debug.

  - When debugging, consider inspecting signals internal to your
    control/datapath (e.g., your state machine registers, the `PC`
    register, `IR` register). Make this easy for yourself during
    repeated simulations by saving custom waveform configurations.

## Deliverable

<div id="part-1">

<span><span>**Part 1**</span> (Due April 8,
2022)

</div>

Design, implement, and test the MIPS multicycle processor with support for the following R-Type instructions:

  - `and`

  - `or`

  - `xor`

  - `nor`

  - `sll`

  - `srl`

  - `sra`

  - `slt`

  - `add`

  - `sub`

  - `nop`

There is nothing special to do to support `nop`, as long as you support
`sll`.  

> Alongside a sketch of your datapath and control unit FSM, create a MIPS
assembly test and provide a description of your testing methodology.

<div id="part-2">

<span><span>**Part 2**</span> (Due April 15,
2022)

</div>

Extend your MIPS multicycle processor to support the following I-Type
and J-type instructions (and `jr`):

  - `andi`

  - `ori`

  - `xori`

  - `slti`

  - `addi`

  - `beq`

  - `bne`

  - `lw`

  - `sw`

  - `j`

  - `jal`

  - `jr`

Remember to update your datapath sketch, FSM, and submit an updated (or
wholly separate) assembly test and description of your testing
methodology.

<div id="Submission">

**Submission**

</div>

For each part (both weeks), submit the following via GitHub Classroom
and Gradescope:

1.  HDL Code (keep your code organized and modular by having one module
    for each source file), synthesized bitstream and utilization report,
    and our handout files (constraint file, Tcl scripts).

2.  A detailed sketch of your datapath (like that shown in section
    [2.2](#datapath))—you can hand-draw and scan these, draw them in
    LaTeX using the `circuitikz` package, or use a different editor such
    as `diagrams.net`.

3.  A high-level state transition diagram for your control unit’s FSM
    (like that shown in section [2.3](#control)).

4.  A MIPS assembly test file (in `hdl/asm/test.asm`) that verifies the
    functionality of the supported instructions **and a description**
    (not more than a few typed paragraphs) of your testing methodology
    (assembly and simulation) for each part.

<span> </span> <span> </span>

Because this is a two part, two week lab, we will use the same repository and GitHub Classroom assignment for both portions. 

> **For Part 1 only**, place your ***grading*** commit on the `main` branch of the
repository auto-generated when you accepted the GitHub Classroom assignment repository ***with*** the following commit message: `PART 1
SUBMISSION` <br><br> Then submit via Gradescope to the correponding assignment (Lab 5.1).
**Add your lab partner** as a group member, and remember that updates aren’t auto-pulled in Gradescope (you *may* need to manually resubmit if you make changes after your initial submission).

**For Part 2**, submit via Gradescope to the corresponding, separate
assignment (Lab 5.2). We expect that this submission will match your
latest commit to the `main` branch of the repository auto-generated when
you accepted the GitHub Classroom assignment and joined a team. **Add
your lab partner** as a group member, and remember that updates aren’t
auto-pulled in Gradescope.

Your repository should have the following structure (with the addition
of some other handout files):

    <LAB5_REPO_NAME>/
        constraint/
            Nexys_A7.xdc
        hdl/
            *.sv
            asm/
                test.asm
                instr.mem
                data.mem
        tcl/
            *.tcl
        synth_output/
            cpu.bit
            post_route_util.rpt
        sketches/
            datapath.png or datapath.pdf
            fsm.png or fsm.pdf
        description.txt or description.pdf

Specifically, **your submission should contain**:

  - Your SystemVerilog files

  - Your synthesized bitstream

  - A post-route utilization report

  - The provided constraint file

  - The provided Tcl scripts

  - Datapath schematic

  - FSM diagram (high-level)

  - Assembly test (`test.asm`)

  - Testing methodology description

If you have any questions, please come to office hours or post on
Ed.

## (Tentative) Rubric

| Component                                              | Part 1 Points | Part 2 Points |
| :----------------------------------------------------- | :-----------: | :-----------: |
| Datapath Schematic                                     |      10       |      10       |
| FSM Diagram                                            |       5       |      10       |
| Fetch                                                  |      10       |       –       |
| Decode                                                 |      15       |       –       |
| Execute                                                |      15       |       –       |
| Writeback                                              |      15       |       –       |
| R-types                                                |      20       |       –       |
| `nop`                                                  |       5       |       –       |
| Simple I-types (`andi`, `ori`, `xori`, `slti`, `addi`) |       –       |      20       |
| `lw`                                                   |       –       |      10       |
| `sw`                                                   |       –       |      10       |
| `j`                                                    |       –       |       5       |
| `jr`                                                   |       –       |      10       |
| `jal`                                                  |       –       |      10       |
| `beq`                                                  |       –       |       5       |
| `bne`                                                  |       –       |       5       |
| `test.asm` and methodology description                 |      10       |      15       |
| Student code simulates (with no warnings)              |      10       |      10       |
| Student code synthesizes (with no warnings)            |      10       |      10       |

<br> <br>

> *Updated March 26, 2022, Dhilan Ramaprasad*
