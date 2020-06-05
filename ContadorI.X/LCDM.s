.include "p30F4013.inc"  ;añadir archivo de cabecera

;Funciones LCD
.GLOBAL _datoLCD
.GLOBAL _comandoLCD
.GLOBAL _BFLCD
.GLOBAL _iniLCD8bits
.GLOBAL _RETARDO_15ms
.GLOBAL _imprimeLCD

.EQU	RS_LCD,	    RD0	    ;EQUIVALENCIA
.EQU	RW_LCD,	    RD1	    ;EQUIVALENCIA
.EQU	E_LCD,	    RD2	    ;EQUIVALENCIA
    
    
;This function supposes that W0 already contains the data that we want to set 
   
;** @brief: manda un dato al LCD
;* @param W0 tiene el dato a enviar
; * @return: ninguno
_datoLCD:
    BSET    PORTD,  #RS_LCD 
    NOP
    BCLR    PORTD,  #RW_LCD ;Read-write en 0 para poder hacer la escritura
    NOP
    BSET    PORTD,  #E_LCD  ;Enable en 1 
    NOP
    MOV.B   WREG,   PORTB   ;Note W0=WREG
    NOP
    BCLR    PORTD,  #E_LCD    
    RETURN

; Imprime en el LCD una cadena de caracteres.
_imprimeLCD:
    PUSH W1
    MOV W0, W1
    COUNT:
	MOV.B [W1++], W0
	CP0.B W0
	BRA Z, END_imprimeLCD
	CALL _BFLCD
	CALL _datoLCD
	GOTO COUNT
    END_imprimeLCD:
	POP W1
    RETURN
    
 
_comandoLCD:
    BCLR    PORTD,  #RS_LCD 
    NOP
    BCLR    PORTD,  #RW_LCD ;Read-write en 0 para poder hacer la escritura
    NOP
    BSET    PORTD,  #E_LCD  ;Enable en 1 
    NOP
    MOV.B   WREG,   PORTB   ;Note W0=WREG
    NOP
    BCLR    PORTD,  #E_LCD 
    RETURN
    
   ;--------P.D: no se si es puerto d o puerto b 
 _BFLCD:
    CLR	    TRISD
    NOP
    CLR	    TRISB
    NOP
    BCLR    PORTD,#RS_LCD ; RS=0
    NOP
    SETM.B  TRISB
    NOP
    BSET    PORTD,#RW_LCD
    NOP
    BSET    PORTD,#E_LCD
    NOP
    CICLO:
    BTSC    PORTB,  #RB7
    GOTO    CICLO
    BCLR    PORTD,  #E_LCD  ;Enable en 0
    NOP
    BCLR    PORTD,  #RW_LCD 
    NOP
    SETM    TRISB
    NOP
    CLR.B   TRISB
    RETURN
    
    
 _iniLCD8bits:
    CALL    _RETARDO_15ms
    MOV	    #0X30,  W0
    CALL    _comandoLCD
    
    CALL    _RETARDO_15ms
    MOV	    #0X30,  W0
    CALL    _comandoLCD
    
    CALL    _RETARDO_15ms
    MOV	    #0X30,  W0
    CALL    _comandoLCD
    
    CALL    _BFLCD
    MOV	    #0X38,  W0
    CALL    _comandoLCD
    
    CALL    _BFLCD
    MOV	    #0X38,  W0
    CALL    _comandoLCD
    
    CALL    _BFLCD
    MOV	    #0X08,  W0
    CALL    _comandoLCD
    
    CALL    _BFLCD
    MOV	    #0X01,  W0
    CALL    _comandoLCD
    
    CALL    _BFLCD
    MOV	    #0X06,  W0
    CALL    _comandoLCD
    
    CALL    _BFLCD
    MOV	    #0X0F,  W0
    CALL    _comandoLCD
    
    RETURN 
  
_RETARDO_15ms:
	PUSH	W0  ; PUSH.D W0
	PUSH	W1
CICLO1_1S:	
	DEC	W0,	    W0
	BRA	NZ,	    CICLO1_1S	
	
	POP	W1	    ; POP.D W0
	POP	W0
	RETURN
	
_iniInterrupciones:
    BCLR IFS0,#U1RXIF
    BSET IEC0,#U1RXIE
    BSET U1MODE,#UARTEN
    RETURN
