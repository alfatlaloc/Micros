.include "p30F4013.inc"  ;añadir archivo de cabecera
    
;Uart
.GLOBAL	__ADCInterrupt
.GLOBAL _T3Interrupt
    
__T3Interrupt:
    BTG	    LATD,	#LATD3
    NOP
    BCLR    IFS0,	#T3IF
    retfie
    
__ADCInterrupt:
    PUSH    W0
    PUSH    W1
    
    CLR	    W0
    MOV	    #ADCBUF0, W1    ;W1=&ADCBUF0
    
    REPEAT  #15
    ADD	    W0,[W1++],  W0  ;W0= W0+[W1++]
    
    LSR	    W0,	    #4,	W0  ;W0=W0>>4
    
    MOV.B	    WREG,	    U1TXREG ;enviar parte baja
    LSR	    W0,	    #8,	W0  ;W0=W0>>8
    MOV.B	    WREG,	    U1TXREG ;enviar parte alta
     
    BCLR    IFS0,   #ADIF
    
    POP	    W1
    POP	    W0
    
    RETFIE
    
    