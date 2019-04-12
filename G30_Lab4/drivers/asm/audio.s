	.text
	.equ CONTROL, 0xFF203040
	.equ FIFOSPACE, 0xFF203044
	.equ LEFT_FIFO, 0xFF203048
	.equ RIGHT_FIFO,0xFF20304C
	.global audio_ASM


audio_ASM:
			PUSH {R1-R8}
			LDR R1, =FIFOSPACE
			LDR R2, [R1]				// Read in FIFO Space
			AND R3, R2, #0xFF000000		// Left Channel
			AND R4, R2, #0x00FF0000		// Right Channel
			LSR R4, #16
			LSR R3, #24
			CMP R3, #128					// CHeck if Left Channel can handle more data
			BNE EXIT
			CMP R4, #128					// Check if RIght Channel can handle more data
			BNE EXIT
			LDR R3,	=LEFT_FIFO			
			LDR R4, =RIGHT_FIFO			
			STR R0, [R3]				// Store data in left channel
			STR R0, [R4]				// Store data in right channel
			MOV R0, #1					// Return Success
			POP {R1-R8}
			BX LR
	

EXIT:
			MOV R0, #0					// Return Failure
			POP {R1-R8}
			BX LR
	

// sampling rate is 48k/s

// frequency = 100 hz

//	period = 1/100 = 0.01 seconds

// half-period = 0.005 seconds

// number of samples  48000 * 0.005 = 240
	

	
	
