	.text
	.equ SW_BASE, 0xFF200040 // Switch circuit interface.
	.global read_slider_switches_ASM // Define global name for subroutine to be accessed.

read_slider_switches_ASM: // This returns contents of Slider Switch Address.
	LDR R1, =SW_BASE
	LDR R0, [R1]
	BX LR

	.end 
