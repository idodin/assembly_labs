			.text
			.global _start

_start:
			LDR R4, =N			// Compute base address
			ADD R3, R4, #4		// Compute address of first number
			LDR R7, =SORTED		// Load sorted boolean
			LDR R5, [R7]
			LDR R2, [R4]		// Load N
			ADD R2, R2, #1		// Compute N+1

SORT:		CMP R5, #1			// Check if sorted = true
			BEQ END
			LDR R7, =TRUE		// Reset sorted to true
			LDR R5, [R7]
			LDR R7, =COUNTER	// Reset counter
			LDR R6, [R7]
			ADD R3, R4, #4		// Reset address of first number
INNER:		ADD R6, R6, #1		// Increment counter
			ADD R3, R3, #4		// Increment pointer to next element
			CMP R6, R2			// if counter = N+1 we loop again
			BEQ SORT			// Loop again
			LDR R0, [R3, #-4]	// Load previous number in list
			LDR R1, [R3]		// Load next number in list
			CMP R0, R1			// Compare previous number with next number
			BLT INNER			// Move onto next number
			STR R0, [R3]		// Swap elements
			STR R1, [R3, #-4]	// Swap elements
			LDR R7, =SORTED		// Set sorted to false
			LDR R5, [R7]
			B INNER				// Loop again
			
END:		B END				// Infinite loop
			

N:			.word	7
NUMBERS:	.word	4, 5, 3, 6
			.word	1, 8, 2
SORTED:		.word 	0
COUNTER:	.word	1
TRUE:		.word	1

// R0 = Value of previous number in list
// R1 = Value of next element in list.
// R2 = N counter
// R3 = Address of next element in list.
// R4 = Address of N (Base Address)
// R5 = Sorted boolean
// R6 = Up counter
// R7 = Temporary Address store
