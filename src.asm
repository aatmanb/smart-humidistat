    #MAKE_BIN#
    
    #LOAD_SEGMENT=FFFFH#
    #LOAD_OFFSET=0000H#
    
    #CS=0000H#
    #IP=0000H#
    
    #DS=0000H#
    #ES=0000H#
    
    #SS=0000H#
    #SP=FFFEH#
    
    #AX=0000H#
    #BX=0000H#
    #CX=0000H#
    #DX=0000H#
    #SI=0000H#
    #DI=0000H#
    #BP=0000H#
    
    T_TABLE     DB  0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,21,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,87,89,90,91,92,93,94,95,96,97,98,99,100
                
    INPUT       DB  00H,02H,05H,08H,0AH,0DH,0FH,12H,14H,17H,1AH,1CH,1FH,21H,24H,26H,29H,2BH,2EH,30H,33H,36H,38H,3BH,3DH,40H,42H,45H,47H,4AH,4DH,4FH,52H,54H,57H,59H,5CH,5EH,61H,63H,66H,69H,6BH,6EH,70H,73H,75H,78H,7AH,7DH,7FH,82H,85H,87H,8AH,8CH,8FH,91H,94H,96H,99H,9CH,9EH,0A1H,0A3H,0A6H,0A8H,0ABH,0ADH,0B0H,0B2H,0B5H,0B8H,0BAH,0BDH,0BFH,0C2H,0C4H,0C7H,0C9H,0CCH,0CFH,0D1H,0D4H,0D6H,0D9H,0DBH,0DEH,0E0H,0E3H,0E5H,0E8H,0EBH,0EDH,0F0H,0F2H,0F5H,0F7H,0FAH,0FCH,0FFH
                
    TEMP_T      DB  ?
    TEMP_H      DB  ?
    
            JMP     ST1 
                DB     1024     DUP(0)
    
    ST1:    CLI 
    		
    	;INTIALIZE DS, ES,SS TO START OF RAM
            MOV     AX,0000H
            MOV     DS,AX
            MOV     ES,AX
            MOV     SS,AX
            MOV     SP,0FFFEH
              
;-----------------------------------------------------------------------------              
    	; INITIALIZATION OF 8255 BEGINS HERE
    	
           	STI	  	
        	MOV     AL,89H  	; CONTROL WORD FOR 8255-2
        	OUT     0EH,AL    
        	
        	MOV     AL,89H	    ; CONTROL WORD FOR 8255-1
        	OUT     06H,AL
        	
            MOV     AL,00H 	    ;DEFAULT LOW OUTPUT FROM 8255-2 UPPER PORT C
        	OUT     0CH,AL
        	
       	;INITIALIZATION OF 8255 ENDS HERE
;-----------------------------------------------------------------------------



;-----------------------------------------------------------------------------
    	    
    	;LCD INITIALIZATION BEGINS
    	
        	CALL    DELAY_20MS 
        	MOV     AL,04H      
        	OUT     02H,AL
        	CALL    DELAY_20MS
        	MOV     AL,00H      ; TO MAKE RS=0 AND R/W=0
        	OUT     02H,AL
        	
        	MOV     AL,38H      ;FUNCTION SET
        	OUT     00H,AL
        	
        	MOV     AL,04H      
        	OUT     02H,AL
        	CALL    DELAY_20MS
        	MOV     AL,00H      ; TO MAKE RS=0 AND R/W=0
        	OUT     02H,AL
        	CALL    DELAY_20MS
        	MOV     AL,0CH      ; DISP ON
        	OUT     00H,AL
        	MOV     AL,04H
        	OUT     02H,AL
        	CALL    DELAY_20MS
        	MOV     AL,00H      ; TO MAKE RS=0 AND R/W=0
        	OUT     02H,AL
        	
        	MOV     AL,06H      ; SET ENTRY MODE
        	OUT     00H,AL
        	CALL    DELAY_20MS
        	MOV     AL,04H
        	OUT     02H,AL
        	CALL    DELAY_20MS
        	MOV     AL,00H      ; TO MAKE RS=0 AND R/W=0
        	OUT     02H,AL
        	MOV     AL,4CH
        	OUT     00H,AL
        	CALL    DELAY_20MS  
        	
        ;LCD INITIALIZATION ENDS
        		
;-----------------------------------------------------------------------------

        	
          	
    	
;-----------------------------------------------------------------------------

; MAIN PROGRAM BEGINS HERE
    		
        	CALL    OFF_BOTH
            CALL    CLEAR_LCD
            CALL    WELCOME_MSG
    	    CALL    DELAY_MAX
    BEGIN:	CALL    HUM
            CALL    TEMP
            CALL    CLEAR_LCD
            CALL    DISP
            MOV     AL,TEMP_T
            MOV     BL,TEMP_H
            CMP     AL,BL
            JA      INC_HUM
            JB      DEC_HUM
            CALL    OFF_BOTH
            JMP     RESTART
            
INC_HUM:    CALL    ON_HUMIDIFIER
            JMP     RESTART
                
DEC_HUM:    CALL    ON_DEHUMIDIFIER
            JMP     RESTART
               
RESTART:    CALL    DELAY_MAX
            JMP     BEGIN

;MAIN PROGRAM ENDS

;-----------------------------------------------------------------------------



                                                                              
                                                                              
;-----------------------------------------------------------------------------                
;                               PROCEDURES
;-----------------------------------------------------------------------------

;DELAY PROCEDURES
           
;DELAY OF 20MS           	
    DELAY_20MS  PROC	NEAR
        
    	        MOV    	CH,5
    	X4:	    NOP
    		    NOP
    		    DEC 	CH
    		    JNZ 	X4
    		    
    	        RET
    DELAY_20MS  ENDP
    
    
;DELAY OF 0.04S    
    DELAY_0.04S PROC	NEAR
        
    	        MOV 	CX,4FFFH
    	X17:	NOP
    		    NOP
    		    DEC 	CX
    		    JNZ 	X17
    		    
    	        RET
    DELAY_0.04S ENDP
    
    
;MAXIMUM DELAY    
    DELAY_MAX   PROC	NEAR
        
    	        MOV 	CX,0FFFFH
    	X16:    NOP
    		    NOP
    		    DEC 	CX
    		    JNZ 	X16
    		    
    	        RET
    DELAY_MAX   ENDP
;----------------------------------------------------------------------    


;LCD PROCEDURES
    
;CLEAR DISPLAY    
    CLEAR_LCD   PROC	NEAR
        
                MOV     AL,00H
    	        OUT     02H,AL
    	        CALL    DELAY_20MS
    	        MOV     AL,01H			
    	        OUT     00H,AL
    	        CALL    DELAY_20MS
    	        MOV     AL,04H
    	        OUT     02H,AL
    	        CALL    DELAY_20MS
    	        MOV     AL,00H
    	        OUT     02H,AL
    	          
                RET
    CLEAR_LCD   ENDP
    
    
    
;PROCUDURE TO DISPLAY TEMPERATURE AND HUMIDITY
    
    DISP        PROC    NEAR
        
                MOV     AL,0A0H
        	    OUT     00H,AL
        	    CALL    DELAY_20MS
        	    MOV     AL,05H
        	    OUT     02H,AL
        	    CALL    DELAY_20MS
        	    MOV     AL,01H
        	    OUT     02H,AL  ;PRINTS SPACE
        	
            	MOV     AL,0A0H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS SPACE
            	
            	MOV     AL,54H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS 'T'
            	
            	MOV     AL,3DH
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS '='
            	
            	MOV     AL,BH
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS NUMBER STORED IN BH
            	
            	MOV     AL,BL
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS NUMBER STORE IN BL
            	
            	MOV     AL,0DFH
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS 'DEG'
            	
            	MOV     AL,43H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS 'C'
            	
            	MOV     AL,0A0H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS SPACE	
            	
            	MOV     AL,52H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS 'R'
            	
            	MOV     AL,48H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS 'H'
            	
            	MOV     AL,3DH
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS '='
            	
            	MOV     AL,DH
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS CHARACTER IN DH
            	
            	MOV     AL,DL
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS CHARACTER IN DL
            	
            	MOV     AL,25H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS '%'
            	
            	RET
        DISP    ENDP
    
    
    
;WELCOME MESSAGE
    	
    WELCOME_MSG PROC	NEAR
        
            	MOV     AL,0A0H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS SPACE
            	
            	MOV     AL,0A0H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS SPACE
            	        
            	MOV     AL,0A0H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS SPACE
            	
            	MOV     AL,0A0H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS SPACE
            	
            	MOV     AL,0A0H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS SPACE
            	
            	MOV     AL,57H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS W
            	
            	MOV     AL,45H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS E
            	
            	MOV     AL,4CH
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS L
            		
            	MOV     AL,43H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS C
            	
            	MOV     AL,4FH
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS O
            	
            	MOV     AL,4DH
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS M
            	
            	MOV     AL,45H
            	OUT     00H,AL
            	CALL    DELAY_20MS
            	MOV     AL,05H
            	OUT     02H,AL
            	CALL    DELAY_20MS
            	MOV     AL,01H
            	OUT     02H,AL  ;PRINTS E
            
                RET
    WELCOME_MSG ENDP
;----------------------------------------------------------------------------    

 
;BINARY TO BCD
    
    BIN2BCD     PROC 	NEAR
        
                MOV     BX,0FFFFH
    BACK:       INC     BL
                SUB     AL,64H
                JNC     BACK
                ADD     AL,64H
    BACK1:      INC     BH
                SUB     AL,0AH
                JNC     BACK1
                ADD     AL,0AH
                MOV     BL,30H
                ADD     BH,BL
                ADD     BL,AL
                
                RET
    BIN2BCD     ENDP
;-----------------------------------------------------------------------------
    
;INPUT PROCEDURES    
    
;GET TEMP

    TEMP        PROC    NEAR
        
                MOV     AL,00H
                OUT     0EH,AL    ; PC0=0
            
                CALL    DELAY_MAX       
                        
                IN      AL,04H
                LEA     SI,INPUT
                LEA     DI,T_TABLE
                DEC     SI
            
     L1:        INC     SI
                CMP     AL,[SI]
                JNZ     L1
                SUB     SI,OFFSET INPUT        
                ADD     DI,SI
                MOV     AL,[DI]
                MOV     TEMP_T,AL       
                CALL    BIN2BCD
                
                RET
    TEMP        ENDP
    
    
    
;GET HUMIDITY

    HUM         PROC    NEAR
        
                MOV     AL,01H
                OUT     0EH,AL    ; PC0=1
                
                CALL    DELAY_MAX
               
                IN      AL,04H
               
                LEA     SI,INPUT
                LEA     DI,T_TABLE
                DEC     SI
            
    L2:         INC     SI
            
                MOV     BL,[SI]
                CMP     AL,BL
                JNZ     L2
                SUB     SI,OFFSET INPUT        
                ADD     DI,SI
                MOV     AL,[DI]
                MOV     TEMP_H,AL
                CALL    BIN2BCD
                MOV     DX,BX
                
                RET
    HUM         ENDP
;-------------------------------------------------------------------------------

    	
;HUMIDIFIER PROCEDURES    
    
;SWITCH OFF BOTH

    OFF_BOTH    PROC    NEAR  
    
                MOV     AL,0EH
                OUT     0EH,AL    ;SWITCH OFF DEHUMIDIFIER
                
                MOV     AL,0CH
                OUT     0EH,AL    ;SWITCH OFF HUMIDIFIER
                
                RET
    OFF_BOTH    ENDP
    
    
    
;SWITCH ON HUMIDIFIER AND SWITCH OFF DEHUMIDIFIER

    ON_HUMIDIFIER   PROC    NEAR  
        
                    MOV     AL,0EH
                    OUT     0EH,AL    ;SWITCH OFF DEHUMIDIFIER
                    
                    MOV     AL,0DH
                    OUT     0EH,AL    ;SWITCH ON HUMIDIFIER
                    CALL    DELAY_MAX
                    
                    RET
    ON_HUMIDIFIER   ENDP
    
    
    
;SWITCH ON DEHUMIDIFIER AND SWITCH OFF HUMIDIFIER

    ON_DEHUMIDIFIER PROC    NEAR  
        
                    MOV     AL,0CH
                    OUT     0EH,AL    ;SWITCH OFF HUMIDIFIER
                    
                    MOV     AL,0FH
                    OUT     0EH,AL    ;SWITCH ON DEHUMIDIFIER
                    CALL    DELAY_MAX
                    
                    RET
    ON_DEHUMIDIFIER ENDP