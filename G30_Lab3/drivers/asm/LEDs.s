	.text
	.equ LED_BASE, 0xFF200000
	.global read_LEDs_ASM
	.global write_LEDs_ASM

read_LEDs_ASM: // This returns contents of address of LED_BASE
	LDR R1, =LED_BASE
	LDR R0, [R1]
	BX LR

write_LEDs_ASM: // This writes to contents of address of LED_BASE
	LDR R1, =LED_BASE
	STR R0, [R1]
	BX LR

	.end
