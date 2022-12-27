# Notes on writing MOS (*) commands

If you want to use your assembled program as a MOS command (saved in the /mos folder of the SD card of the Agon Light), there are some special issues to pay attention to. These are described below.

### Why write MOS commands in Assembly?

The main reason for writing MOS commands in assembly, rather than for example C, is program size. There is only 32kb of address space available for MOS commands, including stack and internal variables and buffers. Compiled C code can quickly get bloated, 


## Z80 Legacy (16-bit) mode

The Agon Light MOS spawns MOS commands in Z80 legacy (16-bit) mode.

To be precise, to spawn the program constituting the MOS command, the MOS first loads the program to the address $0B0000 and then uses the CALL.IS $0000 instruction with MB set to $0B to spwan the program.  Amongst other things, the CALL.IS instruction resets the ADL mode bit to 0.

This means that from the program's point of view, it will be located from address $0000 within a 16-bit address space. All CPU instructions will be executed in Z80 legacy (16-bit) mode and will thus, unless the instruction is suffixed with .L, .IL or .LIL in the source code. 
Think of it as the program running inside a matrix that looks like a 64kb address space to the program, when in reality, the program resides in the 64k page $0Bxxxx of the larger 24-bit address space.

This has various consequences and effects and need to be taken into consideration when writing assembly code specifically for MOS commands on the Agon Light. These are discussed below.

## Program Size

Your 

## Stack


The program will have 32kb of address space to $7FFF available to itself. Note, the SPS stack expands downwards from $7FFF, so if your assembled code is very large, you need to make sure it doesn't clas with the stack. 


This is because the MOS will load your program, if executed as a MOS command, to $B0000. Please note, your assembled program must be 32kb or less. 

In addition, the SPS stack pointer needs to be set to $7FFE before starting to push any values onto the SPS, otherwise the MOS command's SPS will conflict with the global SPL. Note: This is already taken care of by the [init.inc](https://github.com/schur/Agon-Light-Assembly/blob/main/include/init.inc) include file in this repository.  See the [stacktest](https://github.com/schur/Agon-Light-Assembly/tree/main/stacktest) example program for more details on this.



Software for the Agon Light™ written in eZ80 Assembly for the [spasm-ng](https://github.com/alberthdev/spasm-ng) assembler. (no need for the rather bloated Zilog Developer Studio)

- The file init.asm in the [include directory](https://github.com/schur/Agon-Light-Assembly/tree/main/include) provides the necessary header for an assembly program to work with the MOS.
- The file helper_functions.asm has some essential functions (work in Progress - to be expanded)

Feel free to contribute.

## Instructions

1. Clone this git repo to your local machine

        git clone https://github.com/schur/Agon-Light-Assembly/

2. Download and compile [spasm-ng](https://github.com/alberthdev/spasm-ng)

3. Assemble the desired programs with

        spasm -E -T <filename>
   [spasm-ng Manual](#spasm-ng-manual)

## Coding Guidelines

If you would like to write your own programs, feel free to use the [include files](https://github.com/schur/Agon-Light-Assembly/tree/main/include) from this repository.

1. Make sure to include the following lines at the top of your main.asm:
        
        ; uncomment one of the below to chose between ADL (24-bit) or Z80 legacy (16-bit) mode
        ; if nothing is uncommented, Z80 legacy mode will be used
        ;   #define ADL
        ;   #undefine ADL
        
        #include "../include/init.inc"
        #include "../include/mos_api.inc"
        #include "../include/helper_functions.asm"

2. Write your own code with the main function labelled "MAIN"

        MAIN:
                 <your code here>
                CALL	<your helper function calls here>
                RET

### ADL (24-bit) vs Z80 legacy (16-bit) mode

In ADL mode, the program is aware of the full address space. The Agon MOS loads programs by default to address $40000, so if ADL mode is set (#define ADL), the init.asm include file will set the .org $40000 directive.

In Z80 legacy mode, the program will, from its point of view, be located from address $0000.  The program will have 32kb of address space to $7FFF available to itself. Note, the SPS stack expands downwards from $7FFF, so if your assembled code is very large, you need to make sure it doesn't clas with the stack. 

### Assembling as MOS (*) commands

If you want to use your assembled program as a MOS command (saved in the /mos folder of the SD card), you must use Z80 legacy (16-bit) mode. This is because the MOS will load your program, if executed as a MOS command, to $B0000. Please note, your assembled program must be 32kb or less. 

