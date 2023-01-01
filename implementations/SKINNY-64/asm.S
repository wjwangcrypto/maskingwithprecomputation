	.syntax unified
	.cpu cortex-m4
	.set ORDER, 1
	.code 16
	.set WIDTHBYTE, 2

	.macro matrosecandnew oxaddr, oyaddr, xaddr, yaddr, traddr, zaddr, temp1, temp2, temp3, x, y, z, kvalue, precomp,randomtableaddr,flag
		.if \kvalue == 1 
			MOV \temp1, #0
			MOV \temp2 ,#0
			//temp1 = xaddr[0]
			LDRH \temp1, [\xaddr]
			// temp2 = yaddr[0]
			LDRH \temp2, [\yaddr]
			//temp1 = xaddr[0]
			AND  \temp1, \temp2
			//when k == 1
			// zaddr[0] = xaddr[0]yaddr[0]
			STRH \temp1, [\zaddr]
			.set ii, 0
			.if \flag == 1 && \precomp == 1
				LDRH \temp3, [\randomtableaddr], #2 //random bits
				// temp2 = zaddr[ii]
				LDRH \temp2, [\zaddr,#ii]
				STRH \temp3, [\zaddr,#ii]
				// temp2 = r xor zaddr[ii]
				EOR  \temp2, \temp3
				// traddr[ii] = r xor  zaddr[ii]
				STRH \temp2, [\traddr,#ii]
			.endif
			// exit  macro
			.exitm
		.endif
		.if \kvalue > 1
			.if \precomp==1
				matrosecandnew \oxaddr, \oyaddr, \xaddr, \yaddr, \traddr, \zaddr, \temp1, \temp2, \temp3, \x, \y, \z, \kvalue-1, \precomp,\randomtableaddr,\flag
			.endif
			LDRH \x, [\oxaddr,#(\kvalue-1)*WIDTHBYTE*\precomp]
			LDRH \y, [\oyaddr,#(\kvalue-1)*WIDTHBYTE*\precomp]
			AND  \z, \x, \y
			.if \precomp == 1
				.set ii, 0
				.rept  \kvalue-1
					//temp3 = r
					//MOV  \temp3, #1 //random bits
					LDRH \temp3, [\randomtableaddr], #2 //random bits
					// temp2 = zaddr[ii]
					LDRH \temp2, [\zaddr,#ii]
					STRH \temp3, [\zaddr,#ii]
					// temp2 = r xor zaddr[ii]
					EOR  \temp2, \temp3
					// traddr[ii] = r xor  zaddr[ii]
					STRH \temp2, [\traddr,#ii]
					.set ii, ii+1 * WIDTHBYTE
				.endr
			.endif
			.set ii, 0
			// repeat \kvalue-1 times
			.rept  \kvalue-1
				MOV \temp1, #0
				MOV \temp2, #0
				//temp1 = xaddr[ii]
				LDRH \temp1, [\xaddr,#ii]
				// temp2 = traddr[ii]
				LDRH \temp2, [\traddr,#ii]
				EOR \temp1, \temp2
				AND \temp1, \y
				MVN \y, \y
				AND \temp2, \y
				EOR \temp2, \temp1
				MVN \y, \y
				MOV \temp1, #0
				LDRH \temp1, [\yaddr, #ii]
				EOR \temp1, \temp2
				AND \temp1, \x
				MVN \x, \x
				AND \temp2, \x
				EOR \temp2, \temp1
				MVN \x, \x
				EOR \z, \temp2
				// ii ++ 
				.set ii, ii+1 * WIDTHBYTE
			.endr
			// store z[k-1] = z
			STRH \z, [\zaddr,#(\kvalue-1)*WIDTHBYTE*\precomp]
			.if \kvalue == ORDER && \precomp == 1
				.set ii, 0
				.rept  \kvalue
					//temp3 = r
					LDRH \temp3, [\randomtableaddr], #2 //random bits
					// temp2 = zaddr[ii]
					LDRH \temp2, [\zaddr,#ii]
					STRH \temp3, [\zaddr,#ii]
					// temp2 = r xor zaddr[ii]
					EOR  \temp2, \temp3
					// traddr[ii] = r xor  zaddr[ii]
					STRH \temp2, [\traddr,#ii]
					// ii ++ 
					.set ii, ii+1 * WIDTHBYTE
				.endr
				.exitm
			.endif
		.endif
	.endm	
	.macro matrosecandnew_ oxlabel, oylabel, xlabel, ylabel, zlabel, trlabel, kvalue, precomp,randomtable,flag
		LDR r6, =\oxlabel
		LDR r7, =\oylabel
		LDR r11, =\zlabel
		LDR r8, =\xlabel
		LDR r9, =\ylabel
		LDR r10, =\trlabel
	//  matrosecandnew oxaddr, oyaddr, xaddr, xaddr, traddr, zaddr, temp1, temp2, temp3, x  , y , z , kvalue , precomp , randomtableaddr, flag
		matrosecandnew r6    , r7    , r8   , r9   , r10   , r11  , r0   , r1   , r2   , r3 , r4, r5, \kvalue, \precomp, \randomtable   , \flag
		.ltorg
	.endm
	
	.macro matrosecxor xaddr, yaddr, txaddr, tyaddr, traddr, zaddr, temp1, temp2, temp3, kvalue, precomp
		.if \kvalue == 1
			LDRH \temp1, [\xaddr]
			LDRH \temp2, [\yaddr]
			EOR  \temp1, \temp1, \temp2
			//zaddr[0] = xaddr[0] xor yaddr[0]
			STRH \temp1, [\zaddr]
			.exitm
		.endif
		.if \kvalue > 1
			.if \precomp==1
				matrosecxor \xaddr, \yaddr, \txaddr, \tyaddr, \traddr, \zaddr, \temp1, \temp2, \temp3, \kvalue-1, \precomp
			.endif
			//temp1 = xaddr[k-1]
			//temp2 = yaddr[k-1]
			LDRH \temp1, [\xaddr,#(\kvalue-1)*WIDTHBYTE*\precomp]
			LDRH \temp2, [\yaddr,#(\kvalue-1)*WIDTHBYTE*\precomp]
			
			// \temp1 =  xaddr[] xor yaddr[]
			EOR  \temp1, \temp1, \temp2
			// STRH R0,[R1]         R0 to [R1]
			//zaddr[k-1] = xaddr[k-1] xor yaddr[k-1]
			STRH \temp1, [\zaddr,#(\kvalue-1)*WIDTHBYTE*\precomp]
		.endif
	.endm
	
	.macro matrosecxor_ xlabel, ylabel, zlabel, kvalue, precomp
		LDR r6, =\xlabel
		LDR r7, =\ylabel
		LDR r11, =\zlabel
	//	matrosecxor xaddr, yaddr, txaddr, tyaddr, traddr, zaddr, temp1, temp2, temp3, kvalue, precomp
		matrosecxor r6   , r7   , r8    , r9    , r10   , r11  , r0   , r1   , r2   , \kvalue, \precomp
		.ltorg
	.endm
	.macro mAC_ SKINNY_sby0_addr, SKINNY_sby1_addr, SKINNY_sby2_addr, SKINNY_sby3_addr,SKINNY_ART_constants_array_addr,round, kvalue
		LDR r0, =\SKINNY_sby0_addr
		LDR r1, =\SKINNY_sby1_addr
		LDR r2, =\SKINNY_sby2_addr
		LDR r3, =\SKINNY_sby3_addr
		LDR r4, =\SKINNY_ART_constants_array_addr
		mAC r0, r1, r2, r3,r4,\round, \kvalue,r5,r6
		.ltorg
	.endm
	
	.macro mAC SKINNY_sby0_addr, SKINNY_sby1_addr, SKINNY_sby2_addr, SKINNY_sby3_addr,SKINNY_ART_constants_array_addr,round, kvalue,temp0,const
		.set ii, 0	
		.rept \kvalue
			LDRB \const, [\SKINNY_ART_constants_array_addr,#\round]
			AND \const, \const , #0x8
			LDRH \temp0, [\SKINNY_sby0_addr, #ii]
			EOR \temp0, \temp0, \const, LSL #12
			STRH \temp0, [\SKINNY_sby0_addr, #ii]		
			LDRB \const, [\SKINNY_ART_constants_array_addr,#\round]
			AND \const,\const , #0x4
			LDRH \temp0, [\SKINNY_sby1_addr, #ii]
			EOR \temp0, \temp0, \const, LSL #13
			STRH \temp0, [\SKINNY_sby1_addr, #ii]
			LDRB \const, [\SKINNY_ART_constants_array_addr,#\round]
			AND \const,\const , #0x2
			LDRH \temp0, [\SKINNY_sby2_addr, #ii]
			EOR \temp0, \temp0, \const, LSL #14
			STRH \temp0, [\SKINNY_sby2_addr, #ii]		
			LDRB \const, [\SKINNY_ART_constants_array_addr,#\round]
			AND \const,\const , #0x1
			LDRH \temp0, [\SKINNY_sby3_addr, #ii]
			EOR \temp0, \temp0, \const, LSL #15
			STRH \temp0, [\SKINNY_sby3_addr, #ii]
			LDRB \const, [\SKINNY_ART_constants_array_addr,#\round]
			AND \const, \const , #0x20
			LDRH \temp0, [\SKINNY_sby2_addr, #ii]
			EOR \temp0, \temp0, \const, LSL #6
			STRH \temp0, [\SKINNY_sby2_addr, #ii]
			LDRB \const, [\SKINNY_ART_constants_array_addr,#\round]
			AND \const, \const , #0x10
			LDRH \temp0, [\SKINNY_sby3_addr, #ii]
			EOR \temp0, \temp0, \const, LSL #7
			STRH \temp0, [\SKINNY_sby3_addr, #ii]
			MOV \const, #0x2
			LDRH \temp0, [\SKINNY_sby2_addr, #ii]
			EOR \temp0, \temp0, \const, LSL #6
			STRH \temp0, [\SKINNY_sby2_addr, #ii]
			.set ii, ii+1 * WIDTHBYTE
		.endr
	.endm
	.macro mART_ xaddr,keyaddr,kvalue
		LDR r0, =\xaddr
		LDR r1, =\keyaddr
		mART r0,r1,\kvalue,r2,r3
		.ltorg
	.endm
	
	.macro mART xaddr,keyaddr,kvalue,temp0,temp1
		.set ii, 0
		.rept \kvalue
			LDRH \temp0, [\xaddr, #ii]		
			LDRH \temp1, [\keyaddr, #ii]
			AND \temp1,\temp1, #0xFF00
			EOR \temp0, \temp0, \temp1
			STRH \temp0, [\xaddr, #ii]		
			LDRH \temp1, [\keyaddr, #ii]	
			LSR \temp1,\temp1, #8
			LDRB \temp0, [\keyaddr, #ii]
			AND \temp0, \temp0, #0x40
			EOR \temp1,\temp1,\temp0, LSL #9	
			LDRB \temp0, [\keyaddr, #ii]
			AND \temp0,\temp0,#1
			EOR \temp1,\temp1,\temp0, LSL #14
			LDRB \temp0, [\keyaddr, #ii]
			AND \temp0,\temp0,#0x80
			EOR \temp1,\temp1,\temp0, LSL #6
			LDRB \temp0, [\keyaddr, #ii]
			AND \temp0,\temp0,#0x4
			EOR \temp1,\temp1,\temp0, LSL #10
			LDRB \temp0, [\keyaddr, #ii]
			AND \temp0,\temp0,#0x20
			EOR \temp1,\temp1,\temp0, LSL #6
			LDRB \temp0, [\keyaddr, #ii]
			AND \temp0,\temp0,#0x2
			EOR \temp1,\temp1,\temp0, LSL #9
			LDRB \temp0, [\keyaddr, #ii]
			AND \temp0,\temp0,#0x8
			EOR \temp1,\temp1,\temp0, LSL #6
			LDRB \temp0, [\keyaddr, #ii]
			AND \temp0,\temp0,#0x10
			EOR \temp1,\temp1,\temp0, LSL #4
			STRH \temp1, [\keyaddr, #ii]
			.set ii, ii+1 * WIDTHBYTE
		.endr
	
	.endm
	.macro ROR_ON_16BIT dst_number, number, d, temp1,  temp2
		LSR \temp1, \number, \d
		LSL \temp2, \number, #(16 - (\d))
		ORR \temp1, \temp2, \temp1
		LDR \temp2, =0xFFFF
		AND \dst_number, \temp1, \temp2 
	.endm
									
	.macro ROL_ON_16BIT dst_number, number,d
		PUSH {r11,r12}
		ROR_ON_16BIT \dst_number, \number, 16-\d, r11, r12
		POP {r11,r12}
		.ltorg
	.endm
	
	.macro ROR_ON_16BIT_ dst_number, number, d
		PUSH {r11,r12}
		ROR_ON_16BIT \dst_number, \number, \d, r11, r12
		POP {r11,r12}
		.ltorg
	.endm

	.macro SKINNY_shiftrows_ xaddr,  yaddr, kvalue
		LDR r4, =\xaddr
		LDR r5, =\yaddr
		SKINNY_shiftrows r4, r5, r0, r2,r3,\kvalue
		.ltorg
	.endm
	.macro SKINNY_shiftrows xaddr,  yaddr,      temp0, temp2, temp3,kvalue
		.set ii, 0
		.rept \kvalue
			LDRH \temp3, [\xaddr,#ii]	
			AND \temp0 , \temp3 , #0x0F00
			AND \temp2 , \temp0 , #0x0100
			BIC \temp0 , \temp0 , #0x0100
			EOR \temp0 , \temp0 , \temp2 , LSL #0x4
			BIC \temp3 , #0x0F00
			EOR \temp3, \temp3 , \temp0 , LSR #0x1
			AND \temp0 , \temp3 , #0x00F0 
			AND \temp2 , \temp0 , #0xC0
			BIC \temp0 , \temp0 , #0xC0
			EOR \temp0 , \temp0 , \temp2 , LSR #0x4 
			BIC \temp3 , #0x00F0
			EOR \temp3, \temp3 , \temp0 , LSL #0x2
			AND \temp0 , \temp3 , #0x000F 
			AND \temp2 , \temp0 , #0x8   
			BIC \temp0 , \temp0 , #0x8   
			EOR \temp0 , \temp2 , \temp0 , LSL #0x4 
			BIC \temp3 , #0x000F 
			EOR \temp3, \temp3 , \temp0 , LSR #0x3
			STRH \temp3, [\yaddr,#ii]
			.set ii, ii+1 * WIDTHBYTE
		.endr
	.endm
	.macro mSKINNY_mixcolumns_ wkaddr,SKINNY_after_mixcolumn_addr,kvalue
		LDR r0, =\wkaddr
		LDR r1, =\SKINNY_after_mixcolumn_addr
		mSKINNY_mixcolumns r0,r2,r3,r4,r1,\kvalue
		.ltorg
	.endm
	
	.macro mSKINNY_mixcolumns wkaddr,temp0,temp1,temp2,SKINNY_after_mixcolumn_addr,kvalue
		.set ii, 0
		PUSH {r12}
		.rept \kvalue
			LDRH \temp0, [\wkaddr,#ii]			
			ROL_ON_16BIT \temp1, \temp0,12
			EOR \temp2, \temp0, \temp1
			MOV r12, 0xF000
			AND \temp2, r12
			ROR_ON_16BIT_ \temp1,\temp0, 4
			MOV r12, 0x0F00
			AND \temp1, r12
			EOR  \temp2, \temp1
			ROR_ON_16BIT_ \temp1, \temp0,4
			EOR \temp1, \temp0
			AND \temp1,0x00F0
			EOR \temp2, \temp1
			ROR_ON_16BIT_ \temp1, \temp0,12
			ROR_ON_16BIT_ \temp0, \temp0,4
			EOR \temp1, \temp0
			AND \temp1, 0x000F
			EOR \temp2, \temp1		
			STRH \temp2, [\SKINNY_after_mixcolumn_addr,#ii]
			.set ii, ii+1 * WIDTHBYTE
		.endr
		POP {r12}
		
	.endm

	.global SKINNY_asmprecom
	.global SKINNY_asmonline
	.global SKINNY_AC_precompute
	.global SKINNY_AC_online
	.global SKINNY_ART_precompute
	.global SKINNY_ART_online
	.global SKINNY_shiftrows_precompute
	.global SKINNY_shiftrows_online
	.global SKINNY_mixcolumns_precompute
	.global SKINNY_mixcolumns_online

	.global random_table
	.section .text
	.align 4
	
// def sboxfunc(x0,x1,x2,x3):
//     m0 = (x0 | x1) ^ 0xFFFF
//     m1 = (x1 | x2) ^ 0xFFFF
//     y0 = m0 ^ x3
//     m2 = (x2 | y0) ^ 0xFFFF
//     y1 = x0 ^ m1
//     m3 =  (y0 | y1) ^ 0xFFFF
//     y2 = x1 ^ m2
//     y3 = x2 ^ m3
//     return y0,y1,y2,y3
SKINNY_asmprecom:
	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	LDR r12, =random_table
	LDR r6, =SKINNY_sbx0
	LDRH r0, [r6]
	MVN r0,r0
	STRH r0, [r6]
	
	LDR r6, =SKINNY_sbx1
	LDRH r0, [r6]
	MVN r0, r0
	STRH r0, [r6]
	matrosecandnew_ SKINNY_sbx0, SKINNY_sbx1, SKINNY_sbx0, SKINNY_sbx1,SKINNY_sbm0, SKINNY_sband1tr, ORDER, 1, r12, ORDER
	LDR r6, =SKINNY_sbx0
	LDRH r0, [r6]
	MVN r0,r0
	STRH r0, [r6]
	

	LDR r6, =SKINNY_sbx1
	LDRH r0, [r6]
	MVN r0, r0
	STRH r0, [r6]
	
	LDR r6, =SKINNY_sbx1
	LDRH r0, [r6]
	MVN r0,r0
	STRH r0, [r6]
	
	LDR r6, =SKINNY_sbx2
	LDRH r0, [r6]
	MVN r0, r0
	STRH r0, [r6]
	
	matrosecandnew_ SKINNY_sbx1, SKINNY_sbx2, SKINNY_sbx1, SKINNY_sbx2,SKINNY_sbm1, SKINNY_sband2tr, ORDER, 1, r12, ORDER
	LDR r6, =SKINNY_sbx1
	LDRH r0, [r6]
	MVN r0,r0
	STRH r0, [r6]
	
	LDR r6, =SKINNY_sbx2
	LDRH r0, [r6]
	MVN r0, r0
	STRH r0, [r6]
	//     y0 = m0 ^ x3
	matrosecxor_ SKINNY_sbm0, SKINNY_sbx3, SKINNY_sby0, ORDER, 1
	
	LDR r6, =SKINNY_sbx2
	LDRH r0, [r6]
	MVN r0,r0
	STRH r0, [r6]
	
	LDR r6, =SKINNY_sby0
	LDRH r0, [r6]
	MVN r0, r0
	STRH r0, [r6]
	matrosecandnew_ SKINNY_sbx2, SKINNY_sby0, SKINNY_sbx2, SKINNY_sby0, SKINNY_sbm2, SKINNY_sband3tr, ORDER, 1, r12, ORDER

	LDR r6, =SKINNY_sbx2
	LDRH r0, [r6]
	MVN r0,r0
	STRH r0, [r6]
	
	LDR r6, =SKINNY_sby0
	LDRH r0, [r6]
	MVN r0, r0
	STRH r0, [r6]
	
	//     y1 = x0 ^ m1
	matrosecxor_ SKINNY_sbx0, SKINNY_sbm1, SKINNY_sby1, ORDER, 1
	
	LDR r6, =SKINNY_sby0
	LDRH r0, [r6]
	MVN r0, r0
	STRH r0, [r6]
	
	LDR r6, =SKINNY_sby1
	LDRH r0, [r6]
	MVN r0, r0
	STRH r0, [r6]
	matrosecandnew_ SKINNY_sby0, SKINNY_sby1, SKINNY_sby0, SKINNY_sby1,SKINNY_sbm3, SKINNY_sband4tr, ORDER, 1, r12, ORDER
	LDR r6, =SKINNY_sby0
	LDRH r0, [r6]
	MVN r0,r0
	STRH r0, [r6]
	
	LDR r6, =SKINNY_sby1
	LDRH r0, [r6]
	MVN r0, r0
	STRH r0, [r6]
	
	//     y2 = x1 ^ m2
	matrosecxor_ SKINNY_sbx1, SKINNY_sbm2, SKINNY_sby2, ORDER, 1
	//    y3 = x2 ^ m3
	matrosecxor_ SKINNY_sbx2, SKINNY_sbm3, SKINNY_sby3, ORDER, 1
	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr

SKINNY_AC_precompute:
	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	mAC_ SKINNY_sby0, SKINNY_sby1, SKINNY_sby2, SKINNY_sby3, SKINNY_ART_constants_array,0,ORDER
	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr

SKINNY_ART_precompute:
	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	
	mART_ SKINNY_sby0,SKINNY_key0,ORDER
	mART_ SKINNY_sby1,SKINNY_key1,ORDER
	mART_ SKINNY_sby2,SKINNY_key2,ORDER
	mART_ SKINNY_sby3,SKINNY_key3,ORDER
	
	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr
	

SKINNY_shiftrows_precompute:
	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}

	SKINNY_shiftrows_ SKINNY_sby0, SKINNY_after_shiftrows_sby0,ORDER 
	SKINNY_shiftrows_ SKINNY_sby1, SKINNY_after_shiftrows_sby1,ORDER
	SKINNY_shiftrows_ SKINNY_sby2, SKINNY_after_shiftrows_sby2,ORDER
	SKINNY_shiftrows_ SKINNY_sby3, SKINNY_after_shiftrows_sby3,ORDER

	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr


SKINNY_mixcolumns_precompute:
	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	
	mSKINNY_mixcolumns_ SKINNY_after_shiftrows_sby0, SKINNY_after_mixcolumns_sby0,ORDER
	mSKINNY_mixcolumns_ SKINNY_after_shiftrows_sby1, SKINNY_after_mixcolumns_sby1,ORDER
	mSKINNY_mixcolumns_ SKINNY_after_shiftrows_sby2, SKINNY_after_mixcolumns_sby2,ORDER
	mSKINNY_mixcolumns_ SKINNY_after_shiftrows_sby3, SKINNY_after_mixcolumns_sby3,ORDER
	
	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr
SKINNY_asmonline:

	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}

	matrosecandnew_ SKINNY_online_sbx0, SKINNY_online_sbx1, SKINNY_sbx0, SKINNY_sbx1, SKINNY_online_sbm0, SKINNY_sband1tr, ORDER+1, 0, r12, ORDER
	matrosecandnew_ SKINNY_online_sbx1, SKINNY_online_sbx2, SKINNY_sbx1, SKINNY_sbx2, SKINNY_online_sbm1, SKINNY_sband2tr, ORDER+1, 0, r12, ORDER
	matrosecxor_ SKINNY_online_sbm0, SKINNY_online_sbx3, SKINNY_online_sby0, ORDER, 0
	matrosecandnew_ SKINNY_online_sbx2, SKINNY_online_sby0, SKINNY_sbx2, SKINNY_sby0, SKINNY_online_sbm2, SKINNY_sband3tr, ORDER+1, 0, r12, ORDER
	matrosecxor_ SKINNY_online_sbx0, SKINNY_online_sbm1, SKINNY_online_sby1, ORDER, 0
	matrosecandnew_ SKINNY_online_sby0, SKINNY_online_sby1, SKINNY_sby0, SKINNY_sby1, SKINNY_online_sbm3, SKINNY_sband4tr, ORDER+1, 0, r12, ORDER
	matrosecxor_ SKINNY_online_sbx1, SKINNY_online_sbm2, SKINNY_online_sby2, ORDER, 0
	matrosecxor_ SKINNY_online_sbx2, SKINNY_online_sbm3, SKINNY_online_sby3, ORDER, 0
	
	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr
		

SKINNY_AC_online:
	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	mAC_ SKINNY_online_sby0, SKINNY_online_sby1, SKINNY_online_sby2, SKINNY_online_sby3, SKINNY_ART_constants_array,0,1
	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr
SKINNY_ART_online:
	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	
	mART_ SKINNY_online_sby0,SKINNY_online_key0,1
	mART_ SKINNY_online_sby1,SKINNY_online_key1,1
	mART_ SKINNY_online_sby2,SKINNY_online_key2,1
	mART_ SKINNY_online_sby3,SKINNY_online_key3,1
	
	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr

SKINNY_shiftrows_online:
	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	SKINNY_shiftrows_ SKINNY_online_sby0, SKINNY_online_after_shiftrows_sby0,1
	SKINNY_shiftrows_ SKINNY_online_sby1, SKINNY_online_after_shiftrows_sby1,1
	SKINNY_shiftrows_ SKINNY_online_sby2, SKINNY_online_after_shiftrows_sby2,1
	SKINNY_shiftrows_ SKINNY_online_sby3, SKINNY_online_after_shiftrows_sby3,1
	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr


SKINNY_mixcolumns_online:
	PUSH {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	
	mSKINNY_mixcolumns_ SKINNY_online_after_shiftrows_sby0, SKINNY_online_after_mixcolumns_sby0,1
	mSKINNY_mixcolumns_ SKINNY_online_after_shiftrows_sby1, SKINNY_online_after_mixcolumns_sby1,1
	mSKINNY_mixcolumns_ SKINNY_online_after_shiftrows_sby2, SKINNY_online_after_mixcolumns_sby2,1
	mSKINNY_mixcolumns_ SKINNY_online_after_shiftrows_sby3, SKINNY_online_after_mixcolumns_sby3,1
	
	POP {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12}
	bx lr
.end
