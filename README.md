# laptopfddEMU
AVR based laptop floppy drive emulator

Consists of 2 MCUs:
- ATmega328PB - runs the actual floppy drive emulator
- ATmega16A - serves as a serial terminal, interfaces to 3x 7-segment displays and 5 buttons

The PCB design with the ATmega328PB (TQFP32) is available in the [kicad](/kicad) directory
(note: the design is bad, the electrolytic cap needs to be as close to the MCU as possible, the current placement causes unexpected issues where the MCU resets randomly - 
just solder another cap directly to the MCU's legs from the programmer/serial side, as you've got nice big pads there).

The "PCB design" with the ATmega16A (DIP40) was improvised and cut out on a piece of raw copper PCB with a knife. No designs available for that, I'm afraid.

Apologies for the lack of documentation on this project, but I was improvising almost everything (as I needed to get this project done extra quick)
and did not keep track of progress very well. Consider building this only if you feel brave enough for it.
