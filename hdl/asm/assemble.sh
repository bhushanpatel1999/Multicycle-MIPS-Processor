#!/bin/bash

# Usage: ./assemble.sh program.asm

java -jar ./bin/Mars4_5.jar nc a dump .text HexText instr.mem $1
