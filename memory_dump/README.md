# memdump

## Installation

A simple memory dump to screen utility written as a 16-bit Z80 application

Compile it yourself with [spasm-ng](https://github.com/alberthdev/spasm-ng) or download the binary [memdump.bin](https://github.com/schur/Agon-Light-Assembly/raw/main/memory_dump/memdump.bin).

Then put the file memdump.bin in the /mos directory of your SD card. It can now be used like any other MOS command.

## Usage

Usage: `memdump start_address (number of bytes)`

- Start address and number of bytes can be specified in decimal, or hexadecimal if prefixed with an `&`
- Number of bytes is optional, and defaults to 256

## Credit

Original Author Dean Belfield.
