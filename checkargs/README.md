# checkargs

A test program to demonstrate the READ_ARG helper function in [helper_functions.asm](https://github.com/schur/Agon-Light-Assembly/blob/main/include/helper_functions.asm) written as a 16-bit Z80 application

## Installation

Compile it with [spasm-ng](https://github.com/alberthdev/spasm-ng)

Then put the file checkargs.bin in the /mos directory of your SD card. It can now be used like any other MOS command.

## Usage

Usage: `checkargs <argument 1> <argument 2>`

The program outputs the arguments entered, stripping any whitespaces

## Credit

Used some code from memdump by Dean Belfield.
