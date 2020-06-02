.include "p30F4013.inc"  ;añadir archivo de cabecera

;Interrupciones
.GLOBAL _iniInterrupciones
    
;Uart
.GLOBL	_U1RXInterrupt

    .GLOBAL dato
    .GLOBAL drcv
    
; ISR externa por INT1
    
_U1RXInterrupt:
    PUSH    W0
    MOV	    U1RXREG,	W0
    MOV.B   WREG,_dato
    MOV	    #1,W0
    MOV.B   WREG,_drcv
    BCLR    IFS0,#U1RXIF
    POP	    W0
    RETFIE
    
;__INT1Interrupt:
;    BCLR IFS0,#U1RXIF
;    BSET IEC0,#U1RXIE
;    BSET U1MODE,#UARTEN
;    retfie
    