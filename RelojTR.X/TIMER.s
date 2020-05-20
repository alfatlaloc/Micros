    .include "p30F4013.inc"
    .GLOBAL _enLPOSC

    _enLPOSC:
	MOV #0X46, W0 ; W0 = 0X46
	MOV #0X57, W1 ; W1 = 0X57
	MOV #OSCCONL, W2 ; W2 = &OSCCONL
	MOV.B W0, [W2]
	MOV.B W1, [W2]
	BSET OSCCONL, #LPOSCEN
    return
    
    