			.text
			.global _start

_start:
		LDR R1, NUMBER 		
		LDR R2, =RESULT		
		PUSH {LR}			
		BL	FIBONACCI		
		STR R0, [R2]		
		POP {LR}			
		B DONE				

FIBONACCI:					
		PUSH {LR}			
		BL INIT				
		POP {R4-R5}			 
		POP {LR}			
		BX LR				

INIT:	PUSH {R4-R5}		.
		MOV R4, R1			
BASE:	PUSH {LR} 			
		CMP R4, #2 			
		BGE	RECURSE			
		MOV R0, #1			
		POP {LR}			
		BX LR				
RECURSE:
		SUB R4, R4, #1 		
		PUSH {R4}			
		BL BASE				
		POP {R4} 			
		SUB R4, R4, #1 		
		PUSH {R0}			
		BL BASE 			
		POP {R5} 			
		ADD R0, R0, R5 		
		POP {LR} 			
		BX LR				

DONE:	B DONE

NUMBER:		.word 11
RESULT:		.word 0
			.end
