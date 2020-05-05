.include "p30F4013.inc"  ;añadir archivo de cabecera

;Funciones LCD
.GLOBAL _datoLCD
.GLOBAL _comandoLCD
.GLOBAL _BFLCD
.GLOBAL _iniLCD8bits
.GLOBAL _RETARDO_15ms
.GLOBAL _imprimeLCD
    
;Interrupciones
.GLOBAL _iniInterrupciones

    
; VARIABLES DE CONTEO DE INTERRUPCIONES.
.GLOBAL _units
.GLOBAL _tens
.GLOBAL _hundreds
.GLOBAL _thousands

; VARIABLES DE CONTEO DE INTERRUPCIONES.
.GLOBAL _units
.GLOBAL _tens
.GLOBAL _hundreds
.GLOBAL _thousands

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
    BCLR IFS1, #INT1IF
    BCLR INTCON2, #INT1EP
    BSET IEC1, #INT1IE
    RETURN

; ISR externa por INT1
__INT1Interrupt:
    ; Guardamos W0 en la pila.
    PUSH	W0
    ; Guardamos 10 en W0 para las comparaciones.
    MOV		#10,    W0
    ; Incrementamos y verificamos variables de conteo.
    INC.B	_units
    CP.B	_units
    BRA		NZ, END__INT1Interrupt
    CLR.B	_units
    
    INC.B	_tens
    CP.B	_tens
    BRA		NZ, END__INT1Interrupt
    CLR.B	_tens
    
    INC.B	_hundreds
    CP.B	_hundreds
    BRA		NZ, END__INT1Interrupt
    CLR.B	_hundreds
    
    INC.B	_thousands
    CP.B	_thousands
    BRA		NZ, END__INT1Interrupt
    CLR.B	_thousands
    
    END__INT1Interrupt:
	; Apagamos la bandera de activación de la interrupción.
	BCLR    IFS1,   #INT1IF
	; Restauramos el valor de W0
	POP	    W0
	; Retornamos de la rutina de interrupción.
        retfie
    