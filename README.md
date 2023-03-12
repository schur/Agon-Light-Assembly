# Agon-Light-Assembly
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

In addition, the SPS stack pointer needs to be set to $7FFE before starting to push any values onto the SPS, otherwise the MOS command's SPS will conflict with the global SPL. Note: This is already taken care of by the [init.inc](https://github.com/schur/Agon-Light-Assembly/blob/main/include/init.inc) include file in this repository.  See the [stacktest](https://github.com/schur/Agon-Light-Assembly/tree/main/stacktest) example program for more details on this.


### The MOS executable format

The MOS header is stored from bytes 64 in the executable and consists of the following:

- A three byte ASCII representation of the word MOS
- A single byte for the header version
- A single byte for the executable type: 0 = Z80, 1 = ADL

Note: This is already taken care of by the [init.inc](https://github.com/schur/Agon-Light-Assembly/blob/main/include/init.inc) include file in this repository.

## spasm-ng Manual

There is no manual for the spasm-ng assembler itself. However, the syntax for assembler directives follows tasm, so you can refer to the Source File Format, Expressions and Assembler Directives sections of the [TASM Manual](http://www.s100computers.com/Software%20Folder/6502%20Monitor/The%20Telemark%20Assembler%20Manual.pdf)

## Resources

- [eZ80 Heaven](https://ez80.readthedocs.io/en/latest/)
- [TASM Manual](http://www.s100computers.com/Software%20Folder/6502%20Monitor/The%20Telemark%20Assembler%20Manual.pdf)
- [MOS Information and Memory Map](https://github.com/breakintoprogram/agon-mos)
- [MOS API](https://github.com/breakintoprogram/agon-mos/blob/main/API.md)
- [VDP Commands](https://github.com/breakintoprogram/agon-vdp/blob/main/MANUAL.md)
- [Learn eZ80 Assembly](https://www.chibiakumas.com/ez80/)
- [Zilog eZ80 Manual](https://www.manualslib.com/manual/2210443/Zilog-Ez80.html#manual)

convert .hex files to .bin files:

        objcopy --input-target=ihex --output-target=binary <filename>.hex <filename>.bin 
