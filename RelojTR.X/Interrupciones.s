.include "p30F4013.inc"  ;añadir archivo de cabecera

;Funciones TIMER
.GLOBAL _datoLCD
.GLOBAL	__T1Interrupt
    
    .GLOBAL dhr;
    .GLOBAL uhr;
    .GLOBAL dmin;
    .GLOBAL umin;
    .GLOBAL dseg;
    .GLOBAL useg;

__T1Interrupt:
	PUSH	W0
	
	INC.B	_useg
	MOV	#10,	W0
	CP.B	_useg
	BRA	NZ,	FIN_ISR_T1
	CLR.B	_useg
	
	
	INC.B	_dseg
	MOV	#6,W0
	CP.B	_dseg
	BRA	NZ,	FIN_ISR_T1
	CLR.B	_dseg
	
	INC.B	_umin
	MOV	#10,W0
	CP.B	_umin
	BRA	NZ,	FIN_ISR_T1
	CLR.B	_umin
	
	INC.B	_dmin
	MOV	#6,W0
	CP.B	_dmin
	BRA	NZ,	FIN_ISR_T1
	CLR.B	_dmin
	
	INC.B	_uhr
	MOV	#4,W0
	CP.B	_uhr
	BRA	Z,CheckHrs
	MOV	#10,W0
	CP.B	_uhr
	BRA	NZ,	FIN_ISR_T1
	CLR.B	_uhr
	
	INC.B _dhr
	MOV #3,w0
	BRA	NZ,	FIN_ISR_T1
	CLR.B _dhr
	
	CheckHrs:
	MOV #2,W0
	CP.B _dhr
	BRA Z, RESETR
	
	RESETR:
	CLR.B _uhr
	CLR.B _dhr
	BRA FIN_ISR_T1
	
FIN_ISR_T1:
    POP	W0
    BCLR    IFS0,   #T1IF
    retfie
