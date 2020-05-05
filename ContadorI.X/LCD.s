
.include "p30F4013.inc"

; FUNCIONES DE INICIALIZACIÓN.
.GLOBAL	_iniInterrupciones

; FUNCIONES DEL LCD.
.GLOBAL	_writeStringToLCD
.GLOBAL	_comandoLCD
.GLOBAL	_datoLCD
.GLOBAL _imprimeLCD
.GLOBAL	_busyFlagLCD
.GLOBAL	_iniLCD8Bits

; VARIABLES DE CONTEO DE INTERRUPCIONES.
.GLOBAL _units
.GLOBAL _tens
.GLOBAL _hundreds
.GLOBAL _thousands

; MAPEO PARA BANDERAS DEL LCD.
.EQU RS_LCD, RF2
.EQU RW_LCD, RF3
.EQU E_LCD, RD2
    
; Imprime en el LCD una cadena de caracteres.
_imprimeLCD:
    PUSH W1
    MOV W0, W1
COUNT:
    MOV.B [W1++], W0
    CP0.B W0
    BRA Z, END_imprimeLCD
    CALL _busyFlagLCD
    CALL _datoLCD
    GOTO COUNT
END_imprimeLCD:
    POP W1
    return

; Ejecuta un comando del LCD.
_comandoLCD:
    CLR	    TRISD
    NOP
    BCLR    PORTF,  #RS_LCD
    NOP
    BCLR    PORTF,  #RW_LCD
    NOP
    BSET    PORTD,  #E_LCD
    NOP
    
    MOV.B    WREG,    PORTB
    NOP  
    
    BCLR     PORTD, #RD2
    NOP
    return

; Escribe un dato en el LCD.
_datoLCD:
    CLR    TRISF
    CLR    TRISD
    BSET   PORTF,  #RS_LCD
    NOP
    BCLR    PORTF,  #RW_LCD
    NOP
    BSET    PORTD,  #E_LCD
    NOP
    
    MOV.B    WREG,    PORTB
    NOP
    
    BCLR    PORTD, #E_LCD
    NOP
    
    return

; Se ejecuta mientras el LCD no está listo para recibir un nuevo dato o comando.
_busyFlagLCD:
    PUSH    W0
    CLR    TRISF
    CLR    TRISD
    BCLR    PORTF,  #RS_LCD
    NOP
    
    SETM.B  TRISB
    NOP
    
    BSET    PORTF,  #RW_LCD
    NOP
    
    BSET    PORTD,  #E_LCD
    NOP
PROCESA:
    BTSC    PORTB,  #RB7
    GOTO    PROCESA
    
    BCLR    PORTD,#E_LCD
    NOP
    BCLR    PORTF,  #RW_LCD
    NOP
    
    SETM    TRISB
    NOP
    CLR.B   TRISB
    NOP
    
    POP	    W0
    return
 
; Inicializa el LCD para escribir en él.
_iniLCD8Bits:
    CLR	    W0
    CALL    RETARDO_15ms
    MOV	    #0x30,  W0
    CALL    _comandoLCD
    
    CALL    RETARDO_15ms
    MOV	    #0x30,  W0
    CALL    _comandoLCD
    
    CALL    RETARDO_15ms
    MOV	    #0x30,  W0
    CALL    _comandoLCD
    
    CALL    _busyFlagLCD
    MOV	    #0x38,  W0
    CALL    _comandoLCD
    
    CALL    _busyFlagLCD
    MOV	    #0x08,  W0
    CALL    _comandoLCD
    
    CALL    _busyFlagLCD
    MOV	    #0x01,  W0
    CALL    _comandoLCD
    
    CALL    _busyFlagLCD
    MOV	    #0x06,  W0
    CALL    _comandoLCD
    
    CALL    _busyFlagLCD
    MOV	    #0x0F,  W0
    CALL    _comandoLCD
  
    return 
; Retardo de 15ms.
RETARDO_15ms:
    PUSH    W0
    PUSH    W1	
    CLR	    W0
CICLO1_1S:
    DEC	    W0,	    W0
    BRA	    NZ,	    CICLO1_1S

    POP	    W1
    POP	    W0
    RETURN

; ISR externa por INT0
__INT0Interrupt:
    ; Guardamos W0 en la pila.
    PUSH	W0
    ; Guardamos 10 en W0 para las comparaciones.
    MOV		#10,    W0
    ; Incrementamos y verificamos variables de conteo.
    INC.B	_units
    CP.B	_units
    BRA		NZ, END__INT0Interrupt
    CLR.B	_units
    
    INC.B	_tens
    CP.B	_tens
    BRA		NZ, END__INT0Interrupt
    CLR.B	_tens
    
    INC.B	_hundreds
    CP.B	_hundreds
    BRA		NZ, END__INT0Interrupt
    CLR.B	_hundreds
    
    INC.B	_thousands
    CP.B	_thousands
    BRA		NZ, END__INT0Interrupt
    CLR.B	_thousands
    
END__INT0Interrupt:
    ; Apagamos la bandera de activación de la interrupción.
    BCLR    IFS0,   #INT0IF
    ; Restauramos el valor de W0
    POP	    W0
    ; Retornamos de la rutina de interrupción.
    retfie

_iniInterrupciones:
    BCLR IFS0, #INT0IF
    BCLR INTCON2, #INT0EP
    BSET IEC0, #INT0IE
    return