.include "p30F4013.inc"  ;añadir archivo de cabecera
.GLOBAL _datoLCD
.GLOBAL _comandoLCD
.GLOBAL _BFLCD
.GLOBAL _iniLCD8bits
    
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
    MOV	    #0X00FF, W1	    ;W1= 0X00FF
    MOV	    TRISB, W2
    IOR	    W1, W2, W2; TRISB= TRISB OR W1 --> Configurar puerto b como entrada
    MOV	    W2, TRISB
    NOP
    BCLR    PORTD,  #RS_LCD
    NOP
    BSET    PORTD,  #RW_LCD ;Read-write en 1 para leer de la LCD
    NOP
    CICLO:
    BTSC    PORTB,  #RB7
    NOP
    GOTO    CICLO
    NOP
    BCLR    PORTD,  #E_LCD  ;Enable en 0
    NOP
    BCLR    PORTD,  #RW_LCD 
    NOP
    MOV	    #0XFF00, W1
    MOV	    TRISB, W2
    AND	    W2, W1, W1 ; TRISB= TRISB AND W1 --> Configurar puerto b como salida
    MOV	    W2, TRISB
    RETURN
    
    
 _iniLCD8bits:
    CALL    _RETARDO15ms
    MOV	    #0X30,	W0
    CALL    _comandoLCD
    
    RETURN
    
_RETARDO15ms:
	PUSH	W0  ; PUSH.D W0
	PUSH	W1
CICLO1_1S:	
	DEC	W0,	    W0
	BRA	NZ,	    CICLO1_1S	
	
	POP	W1	    ; POP.D W0
	POP	W0
	RETURN
	



