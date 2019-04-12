			.text
			.global _start

_start:			MOV R0, #3
				MOV R1, #4
				MOV R2, #5

PUSH_METHOD:	STR R0, [SP, #-4]! // Push onto stack

POP_METHOD:		LDMIA SP!,{R0-R2}

END:			B END               // infinite loop!

