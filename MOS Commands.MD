# Writing MOS (*) commands for the Agon Light in Assembly 

If you want to use your assembled program as a MOS command (saved in the /mos folder of the SD card of the Agon Light), there are some special issues to pay attention to. These are described below.

### Why write MOS commands in Assembly?

The main reason for writing MOS commands in assembly, rather than for example C, is program size. There is only 32kb of address space available for MOS commands, including stack and internal variables and buffers. Even a simple utility program, such as an editor, could quickly exceed that size when written in C. An assembly program, on the other hand, will rarely exceed a few kb in size if no graphics are involved.

## Z80 Legacy (16-bit) mode

The Agon Light MOS spawns MOS commands in Z80 legacy (16-bit) mode.

To be precise, to spawn the program constituting the MOS command, the MOS first loads the program to address $0B0000 and then uses the CALL.IS $0000 instruction with the MB (upper byte) set to $0B to spwan the program.  Amongst other things, the CALL.IS instruction resets the ADL mode bit to 0.

This means that from the program's own point of view, it is located from address $0000 within a 16-bit address space. All CPU instructions will be executed in Z80 legacy (16-bit) mode, unless the instruction is suffixed with .L, .IL or .LIL in the source code (more about that below). 
Think of it as the program running inside a "Matrix" that looks like a 64kb address space to the program, when in reality, the program resides in the 64k page $0Bxxxx of the larger 24-bit address space.

This has various consequences and effects and need to be taken into consideration when writing assembly code specifically for MOS commands on the Agon Light. These are discussed below.

## Coding Guidelines

When writing an assembly program that is to be used as a MOS command, make sure to include the following lines at the top of your main.asm:
        
    #undefine ADL
        
This tells the [init.inc](https://github.com/schur/Agon-Light-Assembly/blob/main/include/init.inc) include file (and other helper functions) in this repository that the code is written in Z80 legacy mode. In addition, the init.inc file contains initialisation code that automatically makes the necessary adjustments for MOS commands if it detects that the program is being run in Z80 legacy (16-bit) mode and MB (Upper Byte) is set to $0B. 

## Program Size and usable Address Space

The address space available to the MOS command is $0B0000-$0B7FFF in the 24-bit memory map of the Agon Light, or $0000-$7FFF from the programs own point of view. This means that there is only 32kb of address space available for MOS commands, including stack and internal variables and buffers. The program code is located from adress $0000, the stack descends down from $7FFF (see section on stack below) and the space between the end of the program code and lowest point of the stack can be used for internal data (such as variables and buffers).

The MOS command must not write anything outside of this address space, as this could overwrite other data or programs loaded into the Agon Light's RAM with unpredictable results, since the MOS command does not have knowledge about which addresses in RAM might be being used by MOS or other programs.

It is the programmers responsibilty to manage the available address space of 32kb.

## Stack

The eZ80 has two separate stack pointer (SP) registers: a 16-bit SPS register (with MB as uper byte) and a 24-bit SPL register. These two stack pointers operate completly independently and both stacks can be accessed by a program written in assembly. The [stacktest](https://github.com/schur/Agon-Light-Assembly/tree/main/stacktest) program demonstrates and illustrates this behaviour.

In the Agon Light MOS, the global stack (SPL) descends down from $0BFFFF. When the MOS spwans a program in Z80 (16-bit) mode, the SPS defaults to descend from $FFFF. This is a problem, as it creates an immediate stack conflict between the two stacks when a MOS command is spawned at $0B0000. 

Therefore, for a MOS command, the SPS stack needs to descend from $7FFF (from the program's point of view - in absolute terms from $0B7FFF). This needs to be explicitly set at the beginning of the code of the MOS command  before starting to push any values onto the SPS, otherwise the MOS command's SPS will conflict with the global SPL. Note: This is already taken care of by the [init.inc](https://github.com/schur/Agon-Light-Assembly/blob/main/include/init.inc) include file in this repository.

PUSH/POP instructions within a program running as a MOS command will use the SPS and will therefore eat (from above) into the available 32kb address space. It is possible to use the SPL instead via the PUSH.L/POP.L instructions.

## Escaping the Matrix

As discussed above, the MOS command runs in Z80 legacy (16-bit) mode within the address space $0000-$7FFF from its own perspective (absolute address space $0B0000-$0B7FFF). This is the "Matrix" within which the MOS command operates.

### Writing outside the Matrix is verboten

The MOS command must not write anything outside of this address space, as this could overwrite other data or programs loaded into the Agon Light's RAM with unpredictable results, since the MOS command does not have knowledge about which addresses in RAM might be being used by MOS or other programs.

The only valid way for a MOS program to write anything outside of its "Matrix" address space is by using the SPL via the PUSH.L/POP.L instructions.

### Reading from outside the Matrix 
However, it may be necessary for a MOS program to read data from outside its "Matrix" address space. For example, the [memdump](https://github.com/schur/Agon-Light-Assembly/tree/main/memory_dump) command can read and display the contents of any address within the entire 24-bit address space. Doing so is posible, but not trivial.

To read from any memory address outside of the "Matrix", the LD instruction must be used with the .L suffix in the source code. This tells the eZ80 to use ADL (24-bit) mode just for the one instruction to which the .L suffix is added.

When the memory address from which data is to be read is known at the time of writing the code, then it can be hardcoded into the code as an immediate value:

              LD.L      HL,$040000
              LD.L      A,(HL)
              CALL      Print_Hex8
              PRT_CRLF

This loads the contents of address $040000 into the Accumulator and prints the value.

By using the IX or IY register it is also possible to load from an offset from an address:

              LD        B,$0F
              LD.L      IX,$040000
    _LOOP:    LD.L      A,(IX)
              CALL      Print_Hex8
              PRT_CRLF
              INC       IX
              DJNZ      _LOOP

This prints the contents of address $040000-$04000F.

When the memory address from which data is to be read will only be known at runtime, the full 24-bit address needs to be calculated using .L suffixes as necessary.  The AtoI function in [helper_functions.asm](https://github.com/schur/Agon-Light-Assembly/blob/main/include/helper_functions.asm) provides a good example.

              LD        DE,Buffer               ; set DE to point to buffer
              CALL      READ_ARG                ; read argument (from HL to DE)
              EX        DE,HL                   ; move DE (ptr to parsed ergument) to HL (input for AtoI)
              CALL      AtoI                    ; Convert to hex, result in DEU
              EX.L      DE,HL                   ; move DEU to HLU
              LD.L      A,(HL)
              CALL      Print_Hex8
              PRT_CRLF                

The first 4 lines of the above code use helper functions to read an argument (a 24-bit address) from the MOS command line and convert it to a 24-bit hex value. The result of the conversion after AtoI is in DEU. The EX.L instruction transfers the full 24-bit value to HL and then content of the address HL points to can finally be read with the LD.L instruction.

## Managing internal data

As discussed above, the MOS command runs in Z80 legacy (16-bit) mode within the address space $0000-$7FFF (from its own perspective), and it needs to store any internal data (such as variables and buffers) within that space. Typically, space for data can be made using assembler directives such as labels and .BLOCK or .DB or .ORG directives.

     variables:        .BLOCK	$10		; reserve 16 bytes for storing data

This reserves space within the program code for data. It does count towards the size of the binary executable file, so it should only be used when 
