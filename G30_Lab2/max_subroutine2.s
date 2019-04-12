			.text
			.global _start

MAX:
			STMDB SP!, {R4-R7} 		
			LDR R4, [R1]			
			MOV R5, R2	  			
			MOV R6, R1				
LOOP: 		SUBS R5, R5, #1     	
			BEQ DONE            	
			LDR R7, [R6, #4]!   	
			CMP R4, R7          	
			BGE LOOP            	
			MOV R4, R7         		
			B LOOP              	
DONE:		MOV R0, R4				
			LDMIA SP!, {R4-R7}		
			BX LR					

_start:								
			LDR R1, =NUMBERS		
			LDR R2, N 				
			LDR R3, =RESULT     	
			STR LR, [SP], #4				
			BL MAX				
			LDR LR, [SP, #4]!
			STR R0, [R3]        	 

END: 		B END               	

RESULT:	.word 0           
N: 			.word 8           	
NUMBERS: 	.word 4, -5, 3, 6  		
            .word 1, 8, 2, 9
