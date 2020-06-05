.include "p30F4013.inc"  ;añadir archivo de cabecera

;Interrupciones
.GLOBAL _iniInterrupciones
    
;Uart
.GLOBAL	_U1RXInterrupt

    .GLOBAL _dato;
    .GLOBAL _drcv;
    
; ISR externa por INT1

    _iniInterrupciones:
    BCLR IFS0,#U1RXIF
    BSET IEC0,#U1RXIE
    BSET U1MODE,#UARTEN
    RETURN
    
    
__U1RXInterrupt:
    PUSH    W0
    CLR W0
    MOV	    U1RXREG,	W0
    MOV.B   WREG,_dato
 
    BSET   _drcv,#0
    BCLR    IFS0,#U1RXIF
    POP	    W0
    RETFIE
    