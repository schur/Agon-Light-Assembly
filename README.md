# Agon-Light-Assembly
Software for the Agon Light™ written in eZ80 Assembly

The source .asm files syntax is for [spasm-ng](https://github.com/alberthdev/spasm-ng)

-The file init.asm in the include directory provides the necessary header for an assembly program to work with the MOS.
- The file helper_functions.asm has some essentiual functions (Work in Progress- to be expanded)

Feel free to contribute.

## Instructions

1. Clone the git repo to your local

        git clone https://github.com/schur/Agon-Light-Assembly/

2. Assemble the desired programs with

        spasm -E -T <filename>
   [spasm-ng Manual](#spasm-ng-manual)

## Coding Guidelines

If you would like to write your own programs, feel free to use the include files from this repository.

1. Make sure to include the following lines at the top of your main.asm:
        
        ; uncomment one of the below to chose between ADL (24-bit) or Z80 legacy (16-bit) mode
        ; if nothing is uncommented, Z80 legacy mode will be used
        ;   #define ADL
        ;   #undefine ADL
        
        #include "../include/init.asm"
        #include "../include/helper_functions.asm"

2. Write your own code with the main function labelled "MAIN"

        MAIN:
                 <your code here>
                CALL	<your helper function calls here>
                RET

### ADL (24-bit) vs Z80 legacy (16-bit) mode

In ADL mode, the program is aware of the full address space. The Agon MOS loads programs by default to address $40000, so if ADL mode is set (#define ADL), the init.asm include file will set the .org $40000 directive.

In Z80 legacy mode, the program will, from its point of view, be located from address $0000.  The program will have the 16-bit address space to $FFFF available to itself.

### Assembling as MOS (*) commands

If you want to use your assembled program as a MOS command (saved in the /mos folder of the SD card), you must use Z80 legacy (16-bit) mode. This is because the MOS will load your program, if executed as a MOS command, to $B0000. Please note, your assembled program must be 32kb or less. 

## spasm-ng Manual

There is no manual for the spasm-ng assembler itself. However, the syntax for assembler directives follows tasm, so you can refer to the Source File Format, Expressions and Assembler Directives sections of the [TASM Manual](http://www.s100computers.com/Software%20Folder/6502%20Monitor/The%20Telemark%20Assembler%20Manual.pdf)

## Resources

- [eZ80 Heaven](https://ez80.readthedocs.io/en/latest/)
- [TASM Manual](http://www.s100computers.com/Software%20Folder/6502%20Monitor/The%20Telemark%20Assembler%20Manual.pdf)
- [MOS Information and Memory Map](https://github.com/breakintoprogram/agon-mos)
- [MOS API](https://github.com/breakintoprogram/agon-mos/blob/main/API.md)
- [VDP Commands](https://github.com/breakintoprogram/agon-vdp/blob/main/MANUAL.md)
