			.text
			.global _start

_start:
			LDR R4, =N			// Compute base address
			LDR R9, =COUNTER	// Load 
			LDR R6, [R9]
			LDR R9, =POWER2		// Load current power of 2
			LDR R7, [R9]
			LDR R9, =SHIFTS		// Load shifts number
			LDR R8, [R9]
			ADD R3, R4, #4		// Compute address of first number
			LDR R5, [R3]		// Initialize sum to first number
			LDR R2, [R4]		// Load N count

SUM:		ADD R6, R6, #1		// Increment upcounter
			CMP R6, R7			// Did we reach next power of 2?
			BEQ SHIFT			// If we did, increment shift counter and update next power of 2
CONT:		CMP R6, R2			// Have we iterated on all numbers?
			BEQ AVG				// If so - compute average
			ADD R3, R3, #4		// Increment pointer to next element
			LDR R1, [R3]		// Load next element
			ADD R5, R5, R1		// Increment sum
			B SUM				// Loop again

SHIFT:		ADD R8, R8, #1		// Increment shift count
			LSL R7, R7, #1		// Compute next power of 2
			B CONT				// Continue loop where we left off

AVG:		ASR R5, R5, R8		// Shift right to divide by 2^n
			ADD R2, R2, #1		// Increment counter by 1 to ensure we iterate over all elements
			LDR R3, =N			// Initialize R3 to base address

CENTER:		SUBS R2, R2, #1		// Decrement counter
			BEQ	 END			// Break to end if counter has reached end.
			ADD R3, R3, #4		// Increment pointer to next element (since R3 starts at base address, at first iteration, this is first element)
			LDR R1, [R3]		// Load next element
			SUB R1, R1, R5		// Subtract average from next element
			STR R1, [R3]		// Store new value into memory
			B CENTER			// Loop again

END:		B END
			

N:			.word	8
NUMBERS:	.word	4, 5, 3, 6
			.word	1, 8, 2, 9
COUNTER:	.word 	0
POWER2:		.word	2
SHIFTS:		.word	0

// R1 = Value of next element in list.
// R2 = N counter
// R3 = Address of next element in list.
// R4 = Address of N (Base Address)
// R5 = Sum --> Average
// R6 = Up counter
// R7 = Power of 2
// R8 = Shifts required
// R9 = Temporary Address store
