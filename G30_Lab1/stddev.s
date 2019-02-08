			.text
			.global _start

_start:
			LDR R4, =RESULT			// R4 contains address of RESULT.
			LDR R2, [R4, #4]		// Load contents of RESULTLOCATION + 4 (i.e. N - no. elements in list).
			ADD R3, R4, #8			// Compute address of first number.
			LDR R0, [R3]			// Dereference address of first number.
			LDR R5, [R3]

LOOP:		SUBS R2, R2, #1			// Decrement value of N ( n acts as our loop counter) Note: S -> stores into condition code. (flags)
			BEQ DONE				// If last computation gave me a zero result, break into DONE.
			ADD R3, R3, #4			// Compute address of next number into R3.
 			LDR R1, [R3]			// Load next number into R1 (dereference R3).
			CMP R0, R1				// Compare R0 with R1 (next number). 
			BGE MIN					// If R0 > = R1, Loop again.
			MOV R0, R1				// Otherwise, update R0 with value of R1 ==> implies that R0 is finding the max. 
			B LOOP					// Loop again.

MIN:		CMP R5, R1				// Compare R5 with R1
			BLT LOOP				// If R5 (current min) is less than R1 - no new min. Loop again.
			MOV R5, R1				// Else, update R5 with new min.
			B LOOP					// Loop again

DONE:		SUB R6, R0, R5			// R6 = R0 (max) - R6 (min)
			ASR R6, R6, #2
			STR R6, [R4]			// Store value in R0 into address in R4.

END:		B END					// Infinite loop.

RESULT:		.word	0
N:			.word	7
NUMBERS:	.word	4, 5, 3, 6
			.word	1, 8, 2

// R0 = Current max.
// R1 = Value of next element in list.
// R2 = N counter.
// R3 = Address of next element in list.
// R4 = Address of RESULT (also Base address).
// R5 = Current min.
// R6 = Standard Dev
