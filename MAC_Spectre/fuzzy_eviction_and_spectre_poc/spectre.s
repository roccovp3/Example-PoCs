
spectre:	file format mach-o arm64

Disassembly of section __TEXT,__text:

00000001000005e8 <__maccess>:
1000005e8: b9400008    	ldr	w8, [x0]
1000005ec: d65f03c0    	ret

00000001000005f0 <_fence>:
1000005f0: d65f03c0    	ret

00000001000005f4 <__time_maccess>:
1000005f4: d100c3ff    	sub	sp, sp, #0x30
1000005f8: a9014ff4    	stp	x20, x19, [sp, #0x10]
1000005fc: a9027bfd    	stp	x29, x30, [sp, #0x20]
100000600: 910083fd    	add	x29, sp, #0x20
100000604: aa0003f3    	mov	x19, x0
100000608: d5033fdf    	isb
10000060c: 94000238    	bl	0x100000eec <_timer_now>
100000610: aa0003f4    	mov	x20, x0
100000614: d5033fdf    	isb
100000618: 39400268    	ldrb	w8, [x19]
10000061c: 39003fe8    	strb	w8, [sp, #0xf]
100000620: 39403fe8    	ldrb	w8, [sp, #0xf]
100000624: d5033fdf    	isb
100000628: 94000231    	bl	0x100000eec <_timer_now>
10000062c: d5033fdf    	isb
100000630: 4b140000    	sub	w0, w0, w20
100000634: a9427bfd    	ldp	x29, x30, [sp, #0x20]
100000638: a9414ff4    	ldp	x20, x19, [sp, #0x10]
10000063c: 9100c3ff    	add	sp, sp, #0x30
100000640: d65f03c0    	ret

0000000100000644 <_cselect>:
100000644: 7100005f    	cmp	w2, #0x0
100000648: 9a811000    	csel	x0, x0, x1, ne
10000064c: d65f03c0    	ret

0000000100000650 <_decode_flush_reload_state>:
100000650: d10203ff    	sub	sp, sp, #0x80
100000654: a90367fa    	stp	x26, x25, [sp, #0x30]
100000658: a9045ff8    	stp	x24, x23, [sp, #0x40]
10000065c: a90557f6    	stp	x22, x21, [sp, #0x50]
100000660: a9064ff4    	stp	x20, x19, [sp, #0x60]
100000664: a9077bfd    	stp	x29, x30, [sp, #0x70]
100000668: 9101c3fd    	add	x29, sp, #0x70
10000066c: 52801008    	mov	w8, #0x80               ; =128
100000670: f102005f    	cmp	x2, #0x80
100000674: 9a883048    	csel	x8, x2, x8, lo
100000678: 90000037    	adrp	x23, 0x100004000 <_thread_policy_set+0x100004000>
10000067c: f94002f7    	ldr	x23, [x23]
100000680: b4000362    	cbz	x2, 0x1000006ec <_decode_flush_reload_state+0x9c>
100000684: d2800015    	mov	x21, #0x0               ; =0
100000688: d2800016    	mov	x22, #0x0               ; =0
10000068c: d2800009    	mov	x9, #0x0                ; =0
100000690: 52800018    	mov	w24, #0x0               ; =0
100000694: 52800014    	mov	w20, #0x0               ; =0
100000698: f869782b    	ldr	x11, [x1, x9, lsl #3]
10000069c: eb16017f    	cmp	x11, x22
1000006a0: 9a96816c    	csel	x12, x11, x22, hi
1000006a4: 1a98812d    	csel	w13, w9, w24, hi
1000006a8: eb15017f    	cmp	x11, x21
1000006ac: 9a959196    	csel	x22, x12, x21, ls
1000006b0: 1a9491b8    	csel	w24, w13, w20, ls
1000006b4: 1a899294    	csel	w20, w20, w9, ls
1000006b8: 9a8b92b5    	csel	x21, x21, x11, ls
1000006bc: 91000529    	add	x9, x9, #0x1
1000006c0: eb09011f    	cmp	x8, x9
1000006c4: 54fffea1    	b.ne	0x100000698 <_decode_flush_reload_state+0x48>
1000006c8: 12001e93    	and	w19, w20, #0xff
1000006cc: 363801b4    	tbz	w20, #0x7, 0x100000700 <_decode_flush_reload_state+0xb0>
1000006d0: aa0003f9    	mov	x25, x0
1000006d4: aa1303e0    	mov	x0, x19
1000006d8: 52a00081    	mov	w1, #0x40000            ; =262144
1000006dc: 940003ea    	bl	0x100001684 <_thread_policy_set+0x100001684>
1000006e0: aa0003e8    	mov	x8, x0
1000006e4: aa1903e0    	mov	x0, x25
1000006e8: 14000009    	b	0x10000070c <_decode_flush_reload_state+0xbc>
1000006ec: 52800013    	mov	w19, #0x0               ; =0
1000006f0: d2800015    	mov	x21, #0x0               ; =0
1000006f4: d2800016    	mov	x22, #0x0               ; =0
1000006f8: 52800018    	mov	w24, #0x0               ; =0
1000006fc: 52800014    	mov	w20, #0x0               ; =0
100000700: 8b340ae8    	add	x8, x23, w20, uxtb #2
100000704: b9403d08    	ldr	w8, [x8, #0x3c]
100000708: 120e0108    	and	w8, w8, #0x40000
10000070c: 528007e9    	mov	w9, #0x3f               ; =63
100000710: 7100011f    	cmp	w8, #0x0
100000714: 1a940139    	csel	w25, w9, w20, eq
100000718: 39000019    	strb	w25, [x0]
10000071c: 12001f14    	and	w20, w24, #0xff
100000720: 373800b8    	tbnz	w24, #0x7, 0x100000734 <_decode_flush_reload_state+0xe4>
100000724: 8b344ae8    	add	x8, x23, w20, uxtw #2
100000728: b9403d08    	ldr	w8, [x8, #0x3c]
10000072c: 120e0100    	and	w0, w8, #0x40000
100000730: 14000004    	b	0x100000740 <_decode_flush_reload_state+0xf0>
100000734: aa1403e0    	mov	x0, x20
100000738: 52a00081    	mov	w1, #0x40000            ; =262144
10000073c: 940003d2    	bl	0x100001684 <_thread_policy_set+0x100001684>
100000740: 13001e88    	sxtb	w8, w20
100000744: 528007e9    	mov	w9, #0x3f               ; =63
100000748: 7100001f    	cmp	w0, #0x0
10000074c: 1a880128    	csel	w8, w9, w8, eq
100000750: a9025bf4    	stp	x20, x22, [sp, #0x20]
100000754: 93401f29    	sxtb	x9, w25
100000758: a9004fe9    	stp	x9, x19, [sp]
10000075c: a90123f5    	stp	x21, x8, [sp, #0x10]
100000760: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100000764: 911ec000    	add	x0, x0, #0x7b0
100000768: 940003f7    	bl	0x100001744 <_thread_policy_set+0x100001744>
10000076c: a9477bfd    	ldp	x29, x30, [sp, #0x70]
100000770: a9464ff4    	ldp	x20, x19, [sp, #0x60]
100000774: a94557f6    	ldp	x22, x21, [sp, #0x50]
100000778: a9445ff8    	ldp	x24, x23, [sp, #0x40]
10000077c: a94367fa    	ldp	x26, x25, [sp, #0x30]
100000780: 910203ff    	add	sp, sp, #0x80
100000784: d65f03c0    	ret

0000000100000788 <_naive_victim>:
100000788: d10043ff    	sub	sp, sp, #0x10
10000078c: b000000a    	adrp	x10, 0x100001000 <_calibrate_latency+0x68>
100000790: 9129c14a    	add	x10, x10, #0xa70
100000794: 91003feb    	add	x11, sp, #0xf
100000798: aa0103e8    	mov	x8, x1
10000079c: 92401d09    	and	x9, x8, #0xff
1000007a0: d37ae529    	lsl	x9, x9, #6
1000007a4: 38696809    	ldrb	w9, [x0, x9]
1000007a8: 92401d29    	and	x9, x9, #0xff
1000007ac: d37ae529    	lsl	x9, x9, #6
1000007b0: 38696809    	ldrb	w9, [x0, x9]
1000007b4: 92401d29    	and	x9, x9, #0xff
1000007b8: d37ae529    	lsl	x9, x9, #6
1000007bc: 38696809    	ldrb	w9, [x0, x9]
1000007c0: 92401d29    	and	x9, x9, #0xff
1000007c4: d37ae529    	lsl	x9, x9, #6
1000007c8: 38696809    	ldrb	w9, [x0, x9]
1000007cc: ca090108    	eor	x8, x8, x9
1000007d0: f100211f    	cmp	x8, #0x8
1000007d4: 5400008a    	b.ge	0x1000007e4 <_naive_victim+0x5c>
1000007d8: 38686948    	ldrb	w8, [x10, x8]
1000007dc: d372c508    	lsl	x8, x8, #14
1000007e0: 38686808    	ldrb	w8, [x0, x8]
1000007e4: 52800000    	mov	w0, #0x0                ; =0
1000007e8: 910043ff    	add	sp, sp, #0x10
1000007ec: d65f03c0    	ret

00000001000007f0 <_naive_attacker>:
1000007f0: a9ba6ffc    	stp	x28, x27, [sp, #-0x60]!
1000007f4: a90167fa    	stp	x26, x25, [sp, #0x10]
1000007f8: a9025ff8    	stp	x24, x23, [sp, #0x20]
1000007fc: a90357f6    	stp	x22, x21, [sp, #0x30]
100000800: a9044ff4    	stp	x20, x19, [sp, #0x40]
100000804: a9057bfd    	stp	x29, x30, [sp, #0x50]
100000808: 910143fd    	add	x29, sp, #0x50
10000080c: d115c3ff    	sub	sp, sp, #0x570
100000810: 910143f3    	add	x19, sp, #0x50
100000814: 90000028    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100000818: f9401108    	ldr	x8, [x8, #0x20]
10000081c: f9400108    	ldr	x8, [x8]
100000820: f81983a8    	stur	x8, [x29, #-0x68]
100000824: 1e6e1000    	fmov	d0, #1.00000000
100000828: 52800020    	mov	w0, #0x1                ; =1
10000082c: 94000136    	bl	0x100000d04 <_timer_init>
100000830: 940001da    	bl	0x100000f98 <_calibrate_latency>
100000834: aa0003f5    	mov	x21, x0
100000838: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
10000083c: 9125f400    	add	x0, x0, #0x97d
100000840: 940003d0    	bl	0x100001780 <_thread_policy_set+0x100001780>
100000844: 910563e0    	add	x0, sp, #0x158
100000848: 52808001    	mov	w1, #0x400              ; =1024
10000084c: 94000394    	bl	0x10000169c <_thread_policy_set+0x10000169c>
100000850: 6f00e400    	movi.2d	v0, #0000000000000000
100000854: ad070260    	stp	q0, q0, [x19, #0xe0]
100000858: ad060260    	stp	q0, q0, [x19, #0xc0]
10000085c: ad050260    	stp	q0, q0, [x19, #0xa0]
100000860: ad040260    	stp	q0, q0, [x19, #0x80]
100000864: ad0583e0    	stp	q0, q0, [sp, #0xb0]
100000868: ad0483e0    	stp	q0, q0, [sp, #0x90]
10000086c: ad0383e0    	stp	q0, q0, [sp, #0x70]
100000870: ad0283e0    	stp	q0, q0, [sp, #0x50]
100000874: d2800000    	mov	x0, #0x0                ; =0
100000878: 52a00401    	mov	w1, #0x200000           ; =2097152
10000087c: 52800062    	mov	w2, #0x3                ; =3
100000880: 52820043    	mov	w3, #0x1002             ; =4098
100000884: 12800004    	mov	w4, #-0x1               ; =-1
100000888: d2800005    	mov	x5, #0x0                ; =0
10000088c: 9400039f    	bl	0x100001708 <_thread_policy_set+0x100001708>
100000890: b100041f    	cmn	x0, #0x1
100000894: 54001500    	b.eq	0x100000b34 <_naive_attacker+0x344>
100000898: aa0003f4    	mov	x20, x0
10000089c: f9001bf5    	str	x21, [sp, #0x30]
1000008a0: 52800021    	mov	w1, #0x1                ; =1
1000008a4: 52a00402    	mov	w2, #0x200000           ; =2097152
1000008a8: 94000395    	bl	0x1000016fc <_thread_policy_set+0x1000016fc>
1000008ac: 52801008    	mov	w8, #0x80               ; =128
1000008b0: f90003e8    	str	x8, [sp]
1000008b4: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
1000008b8: 91203c00    	add	x0, x0, #0x80f
1000008bc: 940003a2    	bl	0x100001744 <_thread_policy_set+0x100001744>
1000008c0: b0000013    	adrp	x19, 0x100001000 <_calibrate_latency+0x68>
1000008c4: 9129c273    	add	x19, x19, #0xa70
1000008c8: b0000015    	adrp	x21, 0x100001000 <_calibrate_latency+0x68>
1000008cc: 9129e2b5    	add	x21, x21, #0xa78
1000008d0: a9004ff5    	stp	x21, x19, [sp]
1000008d4: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
1000008d8: 91207c00    	add	x0, x0, #0x81f
1000008dc: 9400039a    	bl	0x100001744 <_thread_policy_set+0x100001744>
1000008e0: cb1302b6    	sub	x22, x21, x19
1000008e4: a900dbf3    	stp	x19, x22, [sp, #0x8]
1000008e8: f90003f5    	str	x21, [sp]
1000008ec: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
1000008f0: 91211800    	add	x0, x0, #0x846
1000008f4: 94000394    	bl	0x100001744 <_thread_policy_set+0x100001744>
1000008f8: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
1000008fc: 9125f400    	add	x0, x0, #0x97d
100000900: 940003a0    	bl	0x100001780 <_thread_policy_set+0x100001780>
100000904: d2800015    	mov	x21, #0x0               ; =0
100000908: 93407ec8    	sxtw	x8, w22
10000090c: f90013e8    	str	x8, [sp, #0x20]
100000910: 9000005a    	adrp	x26, 0x100008000 <_page_size>
100000914: 32194bf7    	mov	w23, #0x3ffff80         ; =67108736
100000918: 9000005b    	adrp	x27, 0x100008000 <_page_size>
10000091c: 910133fc    	add	x28, sp, #0x4c
100000920: 90000049    	adrp	x9, 0x100008000 <_page_size>
100000924: 9100a129    	add	x9, x9, #0x28
100000928: d280000a    	mov	x10, #0x0               ; =0
10000092c: f90017f5    	str	x21, [sp, #0x28]
100000930: f94013e8    	ldr	x8, [sp, #0x20]
100000934: 8b0802b5    	add	x21, x21, x8
100000938: f9001ff5    	str	x21, [sp, #0x38]
10000093c: f90023ea    	str	x10, [sp, #0x40]
100000940: d2800016    	mov	x22, #0x0               ; =0
100000944: f1007edf    	cmp	x22, #0x1f
100000948: 9a9f02b9    	csel	x25, x21, xzr, eq
10000094c: f9401748    	ldr	x8, [x26, #0x28]
100000950: b50001c8    	cbnz	x8, 0x100000988 <_naive_attacker+0x198>
100000954: aa0903f8    	mov	x24, x9
100000958: aa0903e0    	mov	x0, x9
10000095c: 52800801    	mov	w1, #0x40               ; =64
100000960: 52a08002    	mov	w2, #0x4000000          ; =67108864
100000964: 94000375    	bl	0x100001738 <_thread_policy_set+0x100001738>
100000968: 35001060    	cbnz	w0, 0x100000b74 <_naive_attacker+0x384>
10000096c: f9400300    	ldr	x0, [x24]
100000970: b4001020    	cbz	x0, 0x100000b74 <_naive_attacker+0x384>
100000974: 528014a1    	mov	w1, #0xa5               ; =165
100000978: 52a08002    	mov	w2, #0x4000000          ; =67108864
10000097c: 94000360    	bl	0x1000016fc <_thread_policy_set+0x1000016fc>
100000980: f9401748    	ldr	x8, [x26, #0x28]
100000984: aa1803e9    	mov	x9, x24
100000988: aa0903f8    	mov	x24, x9
10000098c: d2800009    	mov	x9, #0x0                ; =0
100000990: b9004fff    	str	wzr, [sp, #0x4c]
100000994: 3869690a    	ldrb	w10, [x8, x9]
100000998: b9404feb    	ldr	w11, [sp, #0x4c]
10000099c: 0b0a016a    	add	w10, w11, w10
1000009a0: b9004fea    	str	w10, [sp, #0x4c]
1000009a4: 9102012a    	add	x10, x9, #0x80
1000009a8: eb17013f    	cmp	x9, x23
1000009ac: aa0a03e9    	mov	x9, x10
1000009b0: 54ffff23    	b.lo	0x100000994 <_naive_attacker+0x1a4>
1000009b4: b9404fe8    	ldr	w8, [sp, #0x4c]
1000009b8: f9401360    	ldr	x0, [x27, #0x20]
1000009bc: 94000169    	bl	0x100000f60 <_touch>
1000009c0: aa1903e8    	mov	x8, x25
1000009c4: 92401d09    	and	x9, x8, #0xff
1000009c8: d37ae529    	lsl	x9, x9, #6
1000009cc: 38696a89    	ldrb	w9, [x20, x9]
1000009d0: 92401d29    	and	x9, x9, #0xff
1000009d4: d37ae529    	lsl	x9, x9, #6
1000009d8: 38696a89    	ldrb	w9, [x20, x9]
1000009dc: 92401d29    	and	x9, x9, #0xff
1000009e0: d37ae529    	lsl	x9, x9, #6
1000009e4: 38696a89    	ldrb	w9, [x20, x9]
1000009e8: 92401d29    	and	x9, x9, #0xff
1000009ec: d37ae529    	lsl	x9, x9, #6
1000009f0: 38696a89    	ldrb	w9, [x20, x9]
1000009f4: ca090108    	eor	x8, x8, x9
1000009f8: f100211f    	cmp	x8, #0x8
1000009fc: 5400008a    	b.ge	0x100000a0c <_naive_attacker+0x21c>
100000a00: 38686a68    	ldrb	w8, [x19, x8]
100000a04: d372c508    	lsl	x8, x8, #14
100000a08: 38686a88    	ldrb	w8, [x20, x8]
100000a0c: 910006d6    	add	x22, x22, #0x1
100000a10: f10082df    	cmp	x22, #0x20
100000a14: aa1803e9    	mov	x9, x24
100000a18: 54fff961    	b.ne	0x100000944 <_naive_attacker+0x154>
100000a1c: 528001b9    	mov	w25, #0xd               ; =13
100000a20: 5280101b    	mov	w27, #0x80              ; =128
100000a24: f9401bfc    	ldr	x28, [sp, #0x30]
100000a28: 910563f5    	add	x21, sp, #0x158
100000a2c: 92401b3a    	and	x26, x25, #0x7f
100000a30: d372c753    	lsl	x19, x26, #14
100000a34: d5033fdf    	isb
100000a38: 9400012d    	bl	0x100000eec <_timer_now>
100000a3c: aa0003f6    	mov	x22, x0
100000a40: d5033fdf    	isb
100000a44: 38736a88    	ldrb	w8, [x20, x19]
100000a48: 390133e8    	strb	w8, [sp, #0x4c]
100000a4c: 394133e8    	ldrb	w8, [sp, #0x4c]
100000a50: d5033fdf    	isb
100000a54: 94000126    	bl	0x100000eec <_timer_now>
100000a58: d5033fdf    	isb
100000a5c: f87a7aa8    	ldr	x8, [x21, x26, lsl #3]
100000a60: 4b160009    	sub	w9, w0, w22
100000a64: eb09039f    	cmp	x28, x9
100000a68: 9a889508    	cinc	x8, x8, hi
100000a6c: f83a7aa8    	str	x8, [x21, x26, lsl #3]
100000a70: 91009f39    	add	x25, x25, #0x27
100000a74: f100077b    	subs	x27, x27, #0x1
100000a78: 54fffda1    	b.ne	0x100000a2c <_naive_attacker+0x23c>
100000a7c: a943abf5    	ldp	x21, x10, [sp, #0x38]
100000a80: 9100054a    	add	x10, x10, #0x1
100000a84: f103215f    	cmp	x10, #0xc8
100000a88: b0000013    	adrp	x19, 0x100001000 <_calibrate_latency+0x68>
100000a8c: 9129c273    	add	x19, x19, #0xa70
100000a90: 9000005a    	adrp	x26, 0x100008000 <_page_size>
100000a94: 9000005b    	adrp	x27, 0x100008000 <_page_size>
100000a98: 910133fc    	add	x28, sp, #0x4c
100000a9c: aa1803e9    	mov	x9, x24
100000aa0: 54fff4e1    	b.ne	0x10000093c <_naive_attacker+0x14c>
100000aa4: 910143e8    	add	x8, sp, #0x50
100000aa8: f94017f5    	ldr	x21, [sp, #0x28]
100000aac: 8b150100    	add	x0, x8, x21
100000ab0: 910563e1    	add	x1, sp, #0x158
100000ab4: 52801002    	mov	w2, #0x80               ; =128
100000ab8: 97fffee6    	bl	0x100000650 <_decode_flush_reload_state>
100000abc: 910563e0    	add	x0, sp, #0x158
100000ac0: 52808001    	mov	w1, #0x400              ; =1024
100000ac4: 940002f6    	bl	0x10000169c <_thread_policy_set+0x10000169c>
100000ac8: aa1803e9    	mov	x9, x24
100000acc: 910006b5    	add	x21, x21, #0x1
100000ad0: f1004abf    	cmp	x21, #0x12
100000ad4: 54fff2a1    	b.ne	0x100000928 <_naive_attacker+0x138>
100000ad8: 9400011b    	bl	0x100000f44 <_timer_shutdown>
100000adc: 910143e8    	add	x8, sp, #0x50
100000ae0: f90003e8    	str	x8, [sp]
100000ae4: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100000ae8: 9121a000    	add	x0, x0, #0x868
100000aec: 94000316    	bl	0x100001744 <_thread_policy_set+0x100001744>
100000af0: aa1403e0    	mov	x0, x20
100000af4: 52a00401    	mov	w1, #0x200000           ; =2097152
100000af8: 94000307    	bl	0x100001714 <_thread_policy_set+0x100001714>
100000afc: f85983a8    	ldur	x8, [x29, #-0x68]
100000b00: 90000029    	adrp	x9, 0x100004000 <_thread_policy_set+0x100004000>
100000b04: f9401129    	ldr	x9, [x9, #0x20]
100000b08: f9400129    	ldr	x9, [x9]
100000b0c: eb08013f    	cmp	x9, x8
100000b10: 54000341    	b.ne	0x100000b78 <_naive_attacker+0x388>
100000b14: 9115c3ff    	add	sp, sp, #0x570
100000b18: a9457bfd    	ldp	x29, x30, [sp, #0x50]
100000b1c: a9444ff4    	ldp	x20, x19, [sp, #0x40]
100000b20: a94357f6    	ldp	x22, x21, [sp, #0x30]
100000b24: a9425ff8    	ldp	x24, x23, [sp, #0x20]
100000b28: a94167fa    	ldp	x26, x25, [sp, #0x10]
100000b2c: a8c66ffc    	ldp	x28, x27, [sp], #0x60
100000b30: d65f03c0    	ret
100000b34: f85983a8    	ldur	x8, [x29, #-0x68]
100000b38: 90000029    	adrp	x9, 0x100004000 <_thread_policy_set+0x100004000>
100000b3c: f9401129    	ldr	x9, [x9, #0x20]
100000b40: f9400129    	ldr	x9, [x9]
100000b44: eb08013f    	cmp	x9, x8
100000b48: 54000181    	b.ne	0x100000b78 <_naive_attacker+0x388>
100000b4c: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100000b50: 91202800    	add	x0, x0, #0x80a
100000b54: 9115c3ff    	add	sp, sp, #0x570
100000b58: a9457bfd    	ldp	x29, x30, [sp, #0x50]
100000b5c: a9444ff4    	ldp	x20, x19, [sp, #0x40]
100000b60: a94357f6    	ldp	x22, x21, [sp, #0x30]
100000b64: a9425ff8    	ldp	x24, x23, [sp, #0x20]
100000b68: a94167fa    	ldp	x26, x25, [sp, #0x10]
100000b6c: a8c66ffc    	ldp	x28, x27, [sp], #0x60
100000b70: 140002ef    	b	0x10000172c <_thread_policy_set+0x10000172c>
100000b74: 940002a2    	bl	0x1000015fc <_naive_attacker.cold.1>
100000b78: 940002c6    	bl	0x100001690 <_thread_policy_set+0x100001690>

0000000100000b7c <_main>:
100000b7c: d10183ff    	sub	sp, sp, #0x60
100000b80: a9025ff8    	stp	x24, x23, [sp, #0x20]
100000b84: a90357f6    	stp	x22, x21, [sp, #0x30]
100000b88: a9044ff4    	stp	x20, x19, [sp, #0x40]
100000b8c: a9057bfd    	stp	x29, x30, [sp, #0x50]
100000b90: 910143fd    	add	x29, sp, #0x50
100000b94: aa0103f3    	mov	x19, x1
100000b98: aa0003f4    	mov	x20, x0
100000b9c: 52a00800    	mov	w0, #0x400000           ; =4194304
100000ba0: 940002d1    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
100000ba4: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000ba8: 91018108    	add	x8, x8, #0x60
100000bac: f9000100    	str	x0, [x8]
100000bb0: 71000a9f    	cmp	w20, #0x2
100000bb4: 540000eb    	b.lt	0x100000bd0 <_main+0x54>
100000bb8: f9400660    	ldr	x0, [x19, #0x8]
100000bbc: d2800001    	mov	x1, #0x0                ; =0
100000bc0: 52800002    	mov	w2, #0x0                ; =0
100000bc4: 940002f5    	bl	0x100001798 <_thread_policy_set+0x100001798>
100000bc8: aa0003f3    	mov	x19, x0
100000bcc: 14000002    	b	0x100000bd4 <_main+0x58>
100000bd0: d2800013    	mov	x19, #0x0               ; =0
100000bd4: 90000055    	adrp	x21, 0x100008000 <_page_size>
100000bd8: f94002a1    	ldr	x1, [x21]
100000bdc: d2800000    	mov	x0, #0x0                ; =0
100000be0: 52800062    	mov	w2, #0x3                ; =3
100000be4: 52820043    	mov	w3, #0x1002             ; =4098
100000be8: 12800004    	mov	w4, #-0x1               ; =-1
100000bec: d2800005    	mov	x5, #0x0                ; =0
100000bf0: 940002c6    	bl	0x100001708 <_thread_policy_set+0x100001708>
100000bf4: 90000056    	adrp	x22, 0x100008000 <_page_size>
100000bf8: f9001ac0    	str	x0, [x22, #0x30]
100000bfc: b100041f    	cmn	x0, #0x1
100000c00: 540005e0    	b.eq	0x100000cbc <_main+0x140>
100000c04: f94002a9    	ldr	x9, [x21]
100000c08: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000c0c: f940050a    	ldr	x10, [x8, #0x8]
100000c10: 9aca0928    	udiv	x8, x9, x10
100000c14: eb13011f    	cmp	x8, x19
100000c18: 54000549    	b.ls	0x100000cc0 <_main+0x144>
100000c1c: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000c20: f9400908    	ldr	x8, [x8, #0x10]
100000c24: aa2803eb    	mvn	x11, x8
100000c28: 9b137d4a    	mul	x10, x10, x19
100000c2c: 8b0b0129    	add	x9, x9, x11
100000c30: eb09015f    	cmp	x10, x9
100000c34: 54000568    	b.hi	0x100000ce0 <_main+0x164>
100000c38: aa0003f4    	mov	x20, x0
100000c3c: 8b0a0015    	add	x21, x0, x10
100000c40: 90000057    	adrp	x23, 0x100008000 <_page_size>
100000c44: f90012f5    	str	x21, [x23, #0x20]
100000c48: b0000001    	adrp	x1, 0x100001000 <_calibrate_latency+0x68>
100000c4c: 9129e021    	add	x1, x1, #0xa78
100000c50: 91000502    	add	x2, x8, #0x1
100000c54: aa1503e0    	mov	x0, x21
100000c58: 940002a6    	bl	0x1000016f0 <_thread_policy_set+0x1000016f0>
100000c5c: b0000008    	adrp	x8, 0x100001000 <_calibrate_latency+0x68>
100000c60: 9125c908    	add	x8, x8, #0x972
100000c64: a90123f3    	stp	x19, x8, [sp, #0x10]
100000c68: a90057f4    	stp	x20, x21, [sp]
100000c6c: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100000c70: 9124d800    	add	x0, x0, #0x936
100000c74: 940002b4    	bl	0x100001744 <_thread_policy_set+0x100001744>
100000c78: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100000c7c: 91220000    	add	x0, x0, #0x880
100000c80: 940002b1    	bl	0x100001744 <_thread_policy_set+0x100001744>
100000c84: 97fffedb    	bl	0x1000007f0 <_naive_attacker>
100000c88: f9401ac0    	ldr	x0, [x22, #0x30]
100000c8c: b40000a0    	cbz	x0, 0x100000ca0 <_main+0x124>
100000c90: 52880001    	mov	w1, #0x4000             ; =16384
100000c94: 940002a0    	bl	0x100001714 <_thread_policy_set+0x100001714>
100000c98: f9001adf    	str	xzr, [x22, #0x30]
100000c9c: f90012ff    	str	xzr, [x23, #0x20]
100000ca0: 52800000    	mov	w0, #0x0                ; =0
100000ca4: a9457bfd    	ldp	x29, x30, [sp, #0x50]
100000ca8: a9444ff4    	ldp	x20, x19, [sp, #0x40]
100000cac: a94357f6    	ldp	x22, x21, [sp, #0x30]
100000cb0: a9425ff8    	ldp	x24, x23, [sp, #0x20]
100000cb4: 910183ff    	add	sp, sp, #0x60
100000cb8: d65f03c0    	ret
100000cbc: 94000257    	bl	0x100001618 <_main.cold.1>
100000cc0: 90000029    	adrp	x9, 0x100004000 <_thread_policy_set+0x100004000>
100000cc4: f9401529    	ldr	x9, [x9, #0x28]
100000cc8: f9400120    	ldr	x0, [x9]
100000ccc: d1000508    	sub	x8, x8, #0x1
100000cd0: a90023f3    	stp	x19, x8, [sp]
100000cd4: b0000001    	adrp	x1, 0x100001000 <_calibrate_latency+0x68>
100000cd8: 91232021    	add	x1, x1, #0x8c8
100000cdc: 14000007    	b	0x100000cf8 <_main+0x17c>
100000ce0: 90000028    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100000ce4: f9401508    	ldr	x8, [x8, #0x28]
100000ce8: f9400100    	ldr	x0, [x8]
100000cec: f90003f3    	str	x19, [sp]
100000cf0: b0000001    	adrp	x1, 0x100001000 <_calibrate_latency+0x68>
100000cf4: 91240021    	add	x1, x1, #0x900
100000cf8: 9400026f    	bl	0x1000016b4 <_thread_policy_set+0x1000016b4>
100000cfc: 52800020    	mov	w0, #0x1                ; =1
100000d00: 9400026a    	bl	0x1000016a8 <_thread_policy_set+0x1000016a8>

0000000100000d04 <_timer_init>:
100000d04: d10183ff    	sub	sp, sp, #0x60
100000d08: 6d0123e9    	stp	d9, d8, [sp, #0x10]
100000d0c: a9025ff8    	stp	x24, x23, [sp, #0x20]
100000d10: a90357f6    	stp	x22, x21, [sp, #0x30]
100000d14: a9044ff4    	stp	x20, x19, [sp, #0x40]
100000d18: a9057bfd    	stp	x29, x30, [sp, #0x50]
100000d1c: 910143fd    	add	x29, sp, #0x50
100000d20: 1e604008    	fmov	d8, d0
100000d24: aa0003f4    	mov	x20, x0
100000d28: 90000053    	adrp	x19, 0x100008000 <_page_size>
100000d2c: 9100e273    	add	x19, x19, #0x38
100000d30: aa1303e0    	mov	x0, x19
100000d34: 94000269    	bl	0x1000016d8 <_thread_policy_set+0x1000016d8>
100000d38: 90000055    	adrp	x21, 0x100008000 <_page_size>
100000d3c: f90022bf    	str	xzr, [x21, #0x40]
100000d40: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000d44: b900491f    	str	wzr, [x8, #0x48]
100000d48: 34000354    	cbz	w20, 0x100000db0 <_timer_init+0xac>
100000d4c: 9400028a    	bl	0x100001774 <_thread_policy_set+0x100001774>
100000d50: 94000286    	bl	0x100001768 <_thread_policy_set+0x100001768>
100000d54: 52800034    	mov	w20, #0x1               ; =1
100000d58: b90003f4    	str	w20, [sp]
100000d5c: 910003e2    	mov	x2, sp
100000d60: 52800081    	mov	w1, #0x4                ; =4
100000d64: 52800023    	mov	w3, #0x1                ; =1
100000d68: 9400028f    	bl	0x1000017a4 <_thread_policy_set+0x1000017a4>
100000d6c: 90000040    	adrp	x0, 0x100008000 <_page_size>
100000d70: 91014000    	add	x0, x0, #0x50
100000d74: 90000002    	adrp	x2, 0x100000000 <_thread_policy_set+0x100000000>
100000d78: 913ae042    	add	x2, x2, #0xeb8
100000d7c: d2800001    	mov	x1, #0x0                ; =0
100000d80: d2800003    	mov	x3, #0x0                ; =0
100000d84: 94000273    	bl	0x100001750 <_thread_policy_set+0x100001750>
100000d88: 350008e0    	cbnz	w0, 0x100000ea4 <_timer_init+0x1a0>
100000d8c: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000d90: f9402900    	ldr	x0, [x8, #0x50]
100000d94: 94000275    	bl	0x100001768 <_thread_policy_set+0x100001768>
100000d98: b90003f4    	str	w20, [sp]
100000d9c: 910003e2    	mov	x2, sp
100000da0: 52800081    	mov	w1, #0x4                ; =4
100000da4: 52800023    	mov	w3, #0x1                ; =1
100000da8: 9400027f    	bl	0x1000017a4 <_thread_policy_set+0x1000017a4>
100000dac: 14000009    	b	0x100000dd0 <_timer_init+0xcc>
100000db0: 90000040    	adrp	x0, 0x100008000 <_page_size>
100000db4: 91014000    	add	x0, x0, #0x50
100000db8: 90000002    	adrp	x2, 0x100000000 <_thread_policy_set+0x100000000>
100000dbc: 913ae042    	add	x2, x2, #0xeb8
100000dc0: d2800001    	mov	x1, #0x0                ; =0
100000dc4: d2800003    	mov	x3, #0x0                ; =0
100000dc8: 94000262    	bl	0x100001750 <_thread_policy_set+0x100001750>
100000dcc: 350006c0    	cbnz	w0, 0x100000ea4 <_timer_init+0x1a0>
100000dd0: b0000008    	adrp	x8, 0x100001000 <_calibrate_latency+0x68>
100000dd4: 912a4108    	add	x8, x8, #0xa90
100000dd8: 3dc00100    	ldr	q0, [x8]
100000ddc: 3d8003e0    	str	q0, [sp]
100000de0: 910003e0    	mov	x0, sp
100000de4: d2800001    	mov	x1, #0x0                ; =0
100000de8: 9400024e    	bl	0x100001720 <_thread_policy_set+0x100001720>
100000dec: d2d9aca8    	mov	x8, #0xcd6500000000     ; =225833675390976
100000df0: f2e839a8    	movk	x8, #0x41cd, lsl #48
100000df4: 9e670100    	fmov	d0, x8
100000df8: 1e600909    	fmul	d9, d8, d0
100000dfc: f94022b6    	ldr	x22, [x21, #0x40]
100000e00: 94000233    	bl	0x1000016cc <_thread_policy_set+0x1000016cc>
100000e04: aa0003f4    	mov	x20, x0
100000e08: 1e602108    	fcmp	d8, #0.0
100000e0c: d2dc3468    	mov	x8, #0xe1a300000000     ; =248090195918848
100000e10: f2e83628    	movk	x8, #0x41b1, lsl #48
100000e14: 9e670100    	fmov	d0, x8
100000e18: 1e60cd20    	fcsel	d0, d9, d0, gt
100000e1c: 9e790008    	fcvtzu	x8, d0
100000e20: 2940266a    	ldp	w10, w9, [x19]
100000e24: 9b087d28    	mul	x8, x9, x8
100000e28: 9aca0917    	udiv	x23, x8, x10
100000e2c: 94000228    	bl	0x1000016cc <_thread_policy_set+0x1000016cc>
100000e30: cb140008    	sub	x8, x0, x20
100000e34: eb17011f    	cmp	x8, x23
100000e38: 54ffffa3    	b.lo	0x100000e2c <_timer_init+0x128>
100000e3c: f94022b5    	ldr	x21, [x21, #0x40]
100000e40: 94000223    	bl	0x1000016cc <_thread_policy_set+0x1000016cc>
100000e44: aa0003e8    	mov	x8, x0
100000e48: 52800000    	mov	w0, #0x0                ; =0
100000e4c: cb140108    	sub	x8, x8, x20
100000e50: 29402a69    	ldp	w9, w10, [x19]
100000e54: 9b097d08    	mul	x8, x8, x9
100000e58: 9aca0908    	udiv	x8, x8, x10
100000e5c: f100051f    	cmp	x8, #0x1
100000e60: 9a9f8508    	csinc	x8, x8, xzr, hi
100000e64: cb1602a9    	sub	x9, x21, x22
100000e68: 9e630120    	ucvtf	d0, x9
100000e6c: 9e630101    	ucvtf	d1, x8
100000e70: 1e611800    	fdiv	d0, d0, d1
100000e74: 1e602008    	fcmp	d0, #0.0
100000e78: 1e6e1001    	fmov	d1, #1.00000000
100000e7c: 1e618c00    	fcsel	d0, d0, d1, hi
100000e80: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000e84: fd002d00    	str	d0, [x8, #0x58]
100000e88: a9457bfd    	ldp	x29, x30, [sp, #0x50]
100000e8c: a9444ff4    	ldp	x20, x19, [sp, #0x40]
100000e90: a94357f6    	ldp	x22, x21, [sp, #0x30]
100000e94: a9425ff8    	ldp	x24, x23, [sp, #0x20]
100000e98: 6d4123e9    	ldp	d9, d8, [sp, #0x10]
100000e9c: 910183ff    	add	sp, sp, #0x60
100000ea0: d65f03c0    	ret
100000ea4: b0000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100000ea8: 91269c00    	add	x0, x0, #0x9a7
100000eac: 94000220    	bl	0x10000172c <_thread_policy_set+0x10000172c>
100000eb0: 12800000    	mov	w0, #-0x1               ; =-1
100000eb4: 17fffff5    	b	0x100000e88 <_timer_init+0x184>

0000000100000eb8 <_timer_thread_fn>:
100000eb8: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000ebc: f900211f    	str	xzr, [x8, #0x40]
100000ec0: 90000049    	adrp	x9, 0x100008000 <_page_size>
100000ec4: b900493f    	str	wzr, [x9, #0x48]
100000ec8: b940492a    	ldr	w10, [x9, #0x48]
100000ecc: 350000ca    	cbnz	w10, 0x100000ee4 <_timer_thread_fn+0x2c>
100000ed0: 5280002a    	mov	w10, #0x1               ; =1
100000ed4: f900210a    	str	x10, [x8, #0x40]
100000ed8: b940492b    	ldr	w11, [x9, #0x48]
100000edc: 9100054a    	add	x10, x10, #0x1
100000ee0: 34ffffab    	cbz	w11, 0x100000ed4 <_timer_thread_fn+0x1c>
100000ee4: d2800000    	mov	x0, #0x0                ; =0
100000ee8: d65f03c0    	ret

0000000100000eec <_timer_now>:
100000eec: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000ef0: f9402100    	ldr	x0, [x8, #0x40]
100000ef4: d65f03c0    	ret

0000000100000ef8 <_timer_ticks_to_ns>:
100000ef8: 9e630000    	ucvtf	d0, x0
100000efc: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000f00: fd402d01    	ldr	d1, [x8, #0x58]
100000f04: 1e611800    	fdiv	d0, d0, d1
100000f08: d65f03c0    	ret

0000000100000f0c <_timer_time_maccess>:
100000f0c: d10043ff    	sub	sp, sp, #0x10
100000f10: d5033fdf    	isb
100000f14: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000f18: f9402109    	ldr	x9, [x8, #0x40]
100000f1c: d5033fdf    	isb
100000f20: 3940000a    	ldrb	w10, [x0]
100000f24: 39003fea    	strb	w10, [sp, #0xf]
100000f28: 39403fea    	ldrb	w10, [sp, #0xf]
100000f2c: d5033fdf    	isb
100000f30: f9402108    	ldr	x8, [x8, #0x40]
100000f34: d5033fdf    	isb
100000f38: cb090100    	sub	x0, x8, x9
100000f3c: 910043ff    	add	sp, sp, #0x10
100000f40: d65f03c0    	ret

0000000100000f44 <_timer_shutdown>:
100000f44: 52800028    	mov	w8, #0x1                ; =1
100000f48: 90000049    	adrp	x9, 0x100008000 <_page_size>
100000f4c: b9004928    	str	w8, [x9, #0x48]
100000f50: 90000048    	adrp	x8, 0x100008000 <_page_size>
100000f54: f9402900    	ldr	x0, [x8, #0x50]
100000f58: d2800001    	mov	x1, #0x0                ; =0
100000f5c: 14000200    	b	0x10000175c <_thread_policy_set+0x10000175c>

0000000100000f60 <_touch>:
100000f60: 3940001f    	ldrb	wzr, [x0]
100000f64: d65f03c0    	ret

0000000100000f68 <_evict_by_sweep>:
100000f68: b40000c1    	cbz	x1, 0x100000f80 <_evict_by_sweep+0x18>
100000f6c: d2800008    	mov	x8, #0x0                ; =0
100000f70: 3868681f    	ldrb	wzr, [x0, x8]
100000f74: 91020108    	add	x8, x8, #0x80
100000f78: eb01011f    	cmp	x8, x1
100000f7c: 54ffffa3    	b.lo	0x100000f70 <_evict_by_sweep+0x8>
100000f80: d65f03c0    	ret

0000000100000f84 <_smart_evict_by_sweep>:
100000f84: b4000081    	cbz	x1, 0x100000f94 <_smart_evict_by_sweep+0x10>
100000f88: 3840141f    	ldrb	wzr, [x0], #0x1
100000f8c: f1000421    	subs	x1, x1, #0x1
100000f90: 54ffffc1    	b.ne	0x100000f88 <_smart_evict_by_sweep+0x4>
100000f94: d65f03c0    	ret

0000000100000f98 <_calibrate_latency>:
100000f98: d10143ff    	sub	sp, sp, #0x50
100000f9c: a90257f6    	stp	x22, x21, [sp, #0x20]
100000fa0: a9034ff4    	stp	x20, x19, [sp, #0x30]
100000fa4: a9047bfd    	stp	x29, x30, [sp, #0x40]
100000fa8: 910103fd    	add	x29, sp, #0x40
100000fac: 52801000    	mov	w0, #0x80               ; =128
100000fb0: 72a10000    	movk	w0, #0x800, lsl #16
100000fb4: 940001cc    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
100000fb8: b4000ac0    	cbz	x0, 0x100001110 <_calibrate_latency+0x178>
100000fbc: aa0003f3    	mov	x19, x0
100000fc0: 52840008    	mov	w8, #0x2000             ; =8192
100000fc4: 52800029    	mov	w9, #0x1                ; =1
100000fc8: 5288000a    	mov	w10, #0x4000            ; =16384
100000fcc: 5290000b    	mov	w11, #0x8000            ; =32768
100000fd0: 5298000c    	mov	w12, #0xc000            ; =49152
100000fd4: aa0003ed    	mov	x13, x0
100000fd8: 382a69a9    	strb	w9, [x13, x10]
100000fdc: 382b69a9    	strb	w9, [x13, x11]
100000fe0: 390001a9    	strb	w9, [x13]
100000fe4: 382c69a9    	strb	w9, [x13, x12]
100000fe8: 914041ad    	add	x13, x13, #0x10, lsl #12 ; =0x10000
100000fec: f1001108    	subs	x8, x8, #0x4
100000ff0: 54ffff41    	b.ne	0x100000fd8 <_calibrate_latency+0x40>
100000ff4: 52800100    	mov	w0, #0x8                ; =8
100000ff8: 940001bb    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
100000ffc: b4000880    	cbz	x0, 0x10000110c <_calibrate_latency+0x174>
100001000: aa0003f4    	mov	x20, x0
100001004: d2800008    	mov	x8, #0x0                ; =0
100001008: 52807d0a    	mov	w10, #0x3e8             ; =1000
10000100c: f0000029    	adrp	x9, 0x100008000 <_page_size>
100001010: d5033fdf    	isb
100001014: f940212b    	ldr	x11, [x9, #0x40]
100001018: d5033fdf    	isb
10000101c: 3940028c    	ldrb	w12, [x20]
100001020: 39007bec    	strb	w12, [sp, #0x1e]
100001024: 39407bec    	ldrb	w12, [sp, #0x1e]
100001028: d5033fdf    	isb
10000102c: f940212c    	ldr	x12, [x9, #0x40]
100001030: d5033fdf    	isb
100001034: cb0b0108    	sub	x8, x8, x11
100001038: 8b0c0108    	add	x8, x8, x12
10000103c: 7100054a    	subs	w10, w10, #0x1
100001040: 54fffe81    	b.ne	0x100001010 <_calibrate_latency+0x78>
100001044: 5280000b    	mov	w11, #0x0               ; =0
100001048: d280000a    	mov	x10, #0x0               ; =0
10000104c: 32194fec    	mov	w12, #0x7ffff80         ; =134217600
100001050: d280000d    	mov	x13, #0x0               ; =0
100001054: 386d6a7f    	ldrb	wzr, [x19, x13]
100001058: 910201ae    	add	x14, x13, #0x80
10000105c: eb0c01bf    	cmp	x13, x12
100001060: aa0e03ed    	mov	x13, x14
100001064: 54ffff83    	b.lo	0x100001054 <_calibrate_latency+0xbc>
100001068: d5033fdf    	isb
10000106c: f940212d    	ldr	x13, [x9, #0x40]
100001070: d5033fdf    	isb
100001074: 3940028e    	ldrb	w14, [x20]
100001078: 39007fee    	strb	w14, [sp, #0x1f]
10000107c: 39407fee    	ldrb	w14, [sp, #0x1f]
100001080: d5033fdf    	isb
100001084: f940212e    	ldr	x14, [x9, #0x40]
100001088: d5033fdf    	isb
10000108c: cb0d014a    	sub	x10, x10, x13
100001090: 8b0e014a    	add	x10, x10, x14
100001094: 1100056b    	add	w11, w11, #0x1
100001098: 710fa17f    	cmp	w11, #0x3e8
10000109c: 54fffda1    	b.ne	0x100001050 <_calibrate_latency+0xb8>
1000010a0: d343fd08    	lsr	x8, x8, #3
1000010a4: d29ef9e9    	mov	x9, #0xf7cf             ; =63439
1000010a8: f2bc6a69    	movk	x9, #0xe353, lsl #16
1000010ac: f2d374a9    	movk	x9, #0x9ba5, lsl #32
1000010b0: f2e41889    	movk	x9, #0x20c4, lsl #48
1000010b4: 9bc97d08    	umulh	x8, x8, x9
1000010b8: d344fd08    	lsr	x8, x8, #4
1000010bc: d343fd4a    	lsr	x10, x10, #3
1000010c0: 9bc97d49    	umulh	x9, x10, x9
1000010c4: d344fd29    	lsr	x9, x9, #4
1000010c8: 8b09050a    	add	x10, x8, x9, lsl #1
1000010cc: d342fd55    	lsr	x21, x10, #2
1000010d0: a90027e8    	stp	x8, x9, [sp]
1000010d4: f9000bf5    	str	x21, [sp, #0x10]
1000010d8: 90000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
1000010dc: 91279800    	add	x0, x0, #0x9e6
1000010e0: 94000199    	bl	0x100001744 <_thread_policy_set+0x100001744>
1000010e4: aa1403e0    	mov	x0, x20
1000010e8: 94000176    	bl	0x1000016c0 <_thread_policy_set+0x1000016c0>
1000010ec: aa1303e0    	mov	x0, x19
1000010f0: 94000174    	bl	0x1000016c0 <_thread_policy_set+0x1000016c0>
1000010f4: aa1503e0    	mov	x0, x21
1000010f8: a9447bfd    	ldp	x29, x30, [sp, #0x40]
1000010fc: a9434ff4    	ldp	x20, x19, [sp, #0x30]
100001100: a94257f6    	ldp	x22, x21, [sp, #0x20]
100001104: 910143ff    	add	sp, sp, #0x50
100001108: d65f03c0    	ret
10000110c: 9400014a    	bl	0x100001634 <_calibrate_latency.cold.1>
100001110: 94000153    	bl	0x10000165c <_calibrate_latency.cold.2>

0000000100001114 <_shuffle_ptrs>:
100001114: f100043f    	cmp	x1, #0x1
100001118: 540003a0    	b.eq	0x10000118c <_shuffle_ptrs+0x78>
10000111c: a9bc5ff8    	stp	x24, x23, [sp, #-0x40]!
100001120: a90157f6    	stp	x22, x21, [sp, #0x10]
100001124: a9024ff4    	stp	x20, x19, [sp, #0x20]
100001128: a9037bfd    	stp	x29, x30, [sp, #0x30]
10000112c: 9100c3fd    	add	x29, sp, #0x30
100001130: aa0103f3    	mov	x19, x1
100001134: aa0003f4    	mov	x20, x0
100001138: d2800015    	mov	x21, #0x0               ; =0
10000113c: 12b00016    	mov	w22, #0x7fffffff        ; =2147483647
100001140: aa0003f7    	mov	x23, x0
100001144: 94000192    	bl	0x10000178c <_thread_policy_set+0x10000178c>
100001148: 93407c08    	sxtw	x8, w0
10000114c: 9ad30ac9    	udiv	x9, x22, x19
100001150: 91000529    	add	x9, x9, #0x1
100001154: 9ac90908    	udiv	x8, x8, x9
100001158: 8b150e89    	add	x9, x20, x21, lsl #3
10000115c: f868792a    	ldr	x10, [x9, x8, lsl #3]
100001160: f94002eb    	ldr	x11, [x23]
100001164: f828792b    	str	x11, [x9, x8, lsl #3]
100001168: f80086ea    	str	x10, [x23], #0x8
10000116c: 910006b5    	add	x21, x21, #0x1
100001170: d1000673    	sub	x19, x19, #0x1
100001174: f100067f    	cmp	x19, #0x1
100001178: 54fffe61    	b.ne	0x100001144 <_shuffle_ptrs+0x30>
10000117c: a9437bfd    	ldp	x29, x30, [sp, #0x30]
100001180: a9424ff4    	ldp	x20, x19, [sp, #0x20]
100001184: a94157f6    	ldp	x22, x21, [sp, #0x10]
100001188: a8c45ff8    	ldp	x24, x23, [sp], #0x40
10000118c: d65f03c0    	ret

0000000100001190 <_evict>:
100001190: 34000180    	cbz	w0, 0x1000011c0 <_evict+0x30>
100001194: d10043ff    	sub	sp, sp, #0x10
100001198: f0000028    	adrp	x8, 0x100008000 <_page_size>
10000119c: 9101a108    	add	x8, x8, #0x68
1000011a0: f9400108    	ldr	x8, [x8]
1000011a4: 2a0003e9    	mov	w9, w0
1000011a8: f840850a    	ldr	x10, [x8], #0x8
1000011ac: 3940014a    	ldrb	w10, [x10]
1000011b0: 39003fea    	strb	w10, [sp, #0xf]
1000011b4: f1000529    	subs	x9, x9, #0x1
1000011b8: 54ffff81    	b.ne	0x1000011a8 <_evict+0x18>
1000011bc: 910043ff    	add	sp, sp, #0x10
1000011c0: d65f03c0    	ret

00000001000011c4 <_find_eviction_set>:
1000011c4: d101c3ff    	sub	sp, sp, #0x70
1000011c8: a9016ffc    	stp	x28, x27, [sp, #0x10]
1000011cc: a90267fa    	stp	x26, x25, [sp, #0x20]
1000011d0: a9035ff8    	stp	x24, x23, [sp, #0x30]
1000011d4: a90457f6    	stp	x22, x21, [sp, #0x40]
1000011d8: a9054ff4    	stp	x20, x19, [sp, #0x50]
1000011dc: a9067bfd    	stp	x29, x30, [sp, #0x60]
1000011e0: 910183fd    	add	x29, sp, #0x60
1000011e4: aa0103f5    	mov	x21, x1
1000011e8: aa0003f3    	mov	x19, x0
1000011ec: f0000028    	adrp	x8, 0x100008000 <_page_size>
1000011f0: 9101e108    	add	x8, x8, #0x78
1000011f4: 52a10009    	mov	w9, #0x8000000          ; =134217728
1000011f8: f9000109    	str	x9, [x8]
1000011fc: 52a10000    	mov	w0, #0x8000000          ; =134217728
100001200: 94000139    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
100001204: f0000028    	adrp	x8, 0x100008000 <_page_size>
100001208: 9101c108    	add	x8, x8, #0x70
10000120c: f9000100    	str	x0, [x8]
100001210: b4000c40    	cbz	x0, 0x100001398 <_find_eviction_set+0x1d4>
100001214: aa0003f6    	mov	x22, x0
100001218: 52a01000    	mov	w0, #0x800000           ; =8388608
10000121c: 94000132    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
100001220: aa0003f4    	mov	x20, x0
100001224: 52a01000    	mov	w0, #0x800000           ; =8388608
100001228: 9400012f    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
10000122c: f0000037    	adrp	x23, 0x100008000 <_page_size>
100001230: 9101a2f7    	add	x23, x23, #0x68
100001234: f90002e0    	str	x0, [x23]
100001238: 90000008    	adrp	x8, 0x100001000 <_calibrate_latency+0x68>
10000123c: 3dc2a900    	ldr	q0, [x8, #0xaa0]
100001240: f90007f4    	str	x20, [sp, #0x8]
100001244: 91008288    	add	x8, x20, #0x20
100001248: 52802009    	mov	w9, #0x100              ; =256
10000124c: 4e080d21    	dup.2d	v1, x9
100001250: 52804009    	mov	w9, #0x200              ; =512
100001254: 4e080d22    	dup.2d	v2, x9
100001258: 52806009    	mov	w9, #0x300              ; =768
10000125c: 4e080d23    	dup.2d	v3, x9
100001260: 52a00209    	mov	w9, #0x100000           ; =1048576
100001264: 4e080ec4    	dup.2d	v4, x22
100001268: 5280010a    	mov	w10, #0x8               ; =8
10000126c: 4e080d45    	dup.2d	v5, x10
100001270: 4f475406    	shl.2d	v6, v0, #0x7
100001274: 4ee68486    	add.2d	v6, v4, v6
100001278: 4ee184c7    	add.2d	v7, v6, v1
10000127c: 4ee284d0    	add.2d	v16, v6, v2
100001280: 4ee384d1    	add.2d	v17, v6, v3
100001284: ad3f1d06    	stp	q6, q7, [x8, #-0x20]
100001288: ac824510    	stp	q16, q17, [x8], #0x40
10000128c: 4ee58400    	add.2d	v0, v0, v5
100001290: f1002129    	subs	x9, x9, #0x8
100001294: 54fffee1    	b.ne	0x100001270 <_find_eviction_set+0xac>
100001298: 12bffe16    	mov	w22, #0xfffff           ; =1048575
10000129c: 52a00218    	mov	w24, #0x100000          ; =1048576
1000012a0: 12b00019    	mov	w25, #0x7fffffff        ; =2147483647
1000012a4: f94007fa    	ldr	x26, [sp, #0x8]
1000012a8: 94000139    	bl	0x10000178c <_thread_policy_set+0x10000178c>
1000012ac: 93407c08    	sxtw	x8, w0
1000012b0: 9ad80b29    	udiv	x9, x25, x24
1000012b4: 91000529    	add	x9, x9, #0x1
1000012b8: 9ac90908    	udiv	x8, x8, x9
1000012bc: f8687b49    	ldr	x9, [x26, x8, lsl #3]
1000012c0: f940034a    	ldr	x10, [x26]
1000012c4: f8287b4a    	str	x10, [x26, x8, lsl #3]
1000012c8: f8008749    	str	x9, [x26], #0x8
1000012cc: d1000718    	sub	x24, x24, #0x1
1000012d0: d10006d6    	sub	x22, x22, #0x1
1000012d4: b5fffeb6    	cbnz	x22, 0x1000012a8 <_find_eviction_set+0xe4>
1000012d8: d2800018    	mov	x24, #0x0               ; =0
1000012dc: 2a1503f5    	mov	w21, w21
1000012e0: 14000004    	b	0x1000012f0 <_find_eviction_set+0x12c>
1000012e4: 91000718    	add	x24, x24, #0x1
1000012e8: f144031f    	cmp	x24, #0x100, lsl #12    ; =0x100000
1000012ec: 54000440    	b.eq	0x100001374 <_find_eviction_set+0x1b0>
1000012f0: 5280001b    	mov	w27, #0x0               ; =0
1000012f4: 5280001a    	mov	w26, #0x0               ; =0
1000012f8: f94007e8    	ldr	x8, [sp, #0x8]
1000012fc: f8787908    	ldr	x8, [x8, x24, lsl #3]
100001300: aa1603f9    	mov	x25, x22
100001304: f94002e9    	ldr	x9, [x23]
100001308: f8365928    	str	x8, [x9, w22, uxtw #3]
10000130c: 110006d6    	add	w22, w22, #0x1
100001310: d37d7edc    	ubfiz	x28, x22, #3, #32
100001314: 14000008    	b	0x100001334 <_find_eviction_set+0x170>
100001318: aa1303e0    	mov	x0, x19
10000131c: 97fffefc    	bl	0x100000f0c <_timer_time_maccess>
100001320: eb15001f    	cmp	x0, x21
100001324: 1a9a975a    	cinc	w26, w26, hi
100001328: 1100077b    	add	w27, w27, #0x1
10000132c: 71002b7f    	cmp	w27, #0xa
100001330: 54000140    	b.eq	0x100001358 <_find_eviction_set+0x194>
100001334: 34ffff36    	cbz	w22, 0x100001318 <_find_eviction_set+0x154>
100001338: d2800014    	mov	x20, #0x0               ; =0
10000133c: f94002e8    	ldr	x8, [x23]
100001340: f8746900    	ldr	x0, [x8, x20]
100001344: 97ffff07    	bl	0x100000f60 <_touch>
100001348: 91002294    	add	x20, x20, #0x8
10000134c: eb14039f    	cmp	x28, x20
100001350: 54ffff61    	b.ne	0x10000133c <_find_eviction_set+0x178>
100001354: 17fffff1    	b	0x100001318 <_find_eviction_set+0x154>
100001358: 12001f48    	and	w8, w26, #0xff
10000135c: 7100191f    	cmp	w8, #0x6
100001360: 54fffc29    	b.ls	0x1000012e4 <_find_eviction_set+0x120>
100001364: f94002e8    	ldr	x8, [x23]
100001368: f839591f    	str	xzr, [x8, w25, uxtw #3]
10000136c: aa1903f6    	mov	x22, x25
100001370: 17ffffdd    	b	0x1000012e4 <_find_eviction_set+0x120>
100001374: aa1603e0    	mov	x0, x22
100001378: a9467bfd    	ldp	x29, x30, [sp, #0x60]
10000137c: a9454ff4    	ldp	x20, x19, [sp, #0x50]
100001380: a94457f6    	ldp	x22, x21, [sp, #0x40]
100001384: a9435ff8    	ldp	x24, x23, [sp, #0x30]
100001388: a94267fa    	ldp	x26, x25, [sp, #0x20]
10000138c: a9416ffc    	ldp	x28, x27, [sp, #0x10]
100001390: 9101c3ff    	add	sp, sp, #0x70
100001394: d65f03c0    	ret
100001398: 52800020    	mov	w0, #0x1                ; =1
10000139c: 940000c3    	bl	0x1000016a8 <_thread_policy_set+0x1000016a8>

00000001000013a0 <_find_eviction_set_build>:
1000013a0: a9be4ff4    	stp	x20, x19, [sp, #-0x20]!
1000013a4: a9017bfd    	stp	x29, x30, [sp, #0x10]
1000013a8: 910043fd    	add	x29, sp, #0x10
1000013ac: aa0003f3    	mov	x19, x0
1000013b0: f0000028    	adrp	x8, 0x100008000 <_page_size>
1000013b4: 9101e108    	add	x8, x8, #0x78
1000013b8: 52a02809    	mov	w9, #0x1400000          ; =20971520
1000013bc: f9000109    	str	x9, [x8]
1000013c0: 52a02800    	mov	w0, #0x1400000          ; =20971520
1000013c4: 940000c8    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
1000013c8: f0000028    	adrp	x8, 0x100008000 <_page_size>
1000013cc: 9101c108    	add	x8, x8, #0x70
1000013d0: f9000100    	str	x0, [x8]
1000013d4: b4000760    	cbz	x0, 0x1000014c0 <_find_eviction_set_build+0x120>
1000013d8: 5287d000    	mov	w0, #0x3e80             ; =16000
1000013dc: 72a00280    	movk	w0, #0x14, lsl #16
1000013e0: 940000c1    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
1000013e4: f0000034    	adrp	x20, 0x100008000 <_page_size>
1000013e8: 9101a294    	add	x20, x20, #0x68
1000013ec: f9000280    	str	x0, [x20]
1000013f0: 97fffedc    	bl	0x100000f60 <_touch>
1000013f4: aa1303e0    	mov	x0, x19
1000013f8: 97fffec5    	bl	0x100000f0c <_timer_time_maccess>
1000013fc: f9400288    	ldr	x8, [x20]
100001400: f9400100    	ldr	x0, [x8]
100001404: 97fffed7    	bl	0x100000f60 <_touch>
100001408: aa1303e0    	mov	x0, x19
10000140c: 97fffec0    	bl	0x100000f0c <_timer_time_maccess>
100001410: f9400288    	ldr	x8, [x20]
100001414: f9400100    	ldr	x0, [x8]
100001418: 97fffed2    	bl	0x100000f60 <_touch>
10000141c: aa1303e0    	mov	x0, x19
100001420: 97fffebb    	bl	0x100000f0c <_timer_time_maccess>
100001424: f9400288    	ldr	x8, [x20]
100001428: f9400100    	ldr	x0, [x8]
10000142c: 97fffecd    	bl	0x100000f60 <_touch>
100001430: aa1303e0    	mov	x0, x19
100001434: 97fffeb6    	bl	0x100000f0c <_timer_time_maccess>
100001438: f9400288    	ldr	x8, [x20]
10000143c: f9400100    	ldr	x0, [x8]
100001440: 97fffec8    	bl	0x100000f60 <_touch>
100001444: aa1303e0    	mov	x0, x19
100001448: 97fffeb1    	bl	0x100000f0c <_timer_time_maccess>
10000144c: f9400288    	ldr	x8, [x20]
100001450: f9400100    	ldr	x0, [x8]
100001454: 97fffec3    	bl	0x100000f60 <_touch>
100001458: aa1303e0    	mov	x0, x19
10000145c: 97fffeac    	bl	0x100000f0c <_timer_time_maccess>
100001460: f9400288    	ldr	x8, [x20]
100001464: f9400100    	ldr	x0, [x8]
100001468: 97fffebe    	bl	0x100000f60 <_touch>
10000146c: aa1303e0    	mov	x0, x19
100001470: 97fffea7    	bl	0x100000f0c <_timer_time_maccess>
100001474: f9400288    	ldr	x8, [x20]
100001478: f9400100    	ldr	x0, [x8]
10000147c: 97fffeb9    	bl	0x100000f60 <_touch>
100001480: aa1303e0    	mov	x0, x19
100001484: 97fffea2    	bl	0x100000f0c <_timer_time_maccess>
100001488: f9400288    	ldr	x8, [x20]
10000148c: f9400100    	ldr	x0, [x8]
100001490: 97fffeb4    	bl	0x100000f60 <_touch>
100001494: aa1303e0    	mov	x0, x19
100001498: 97fffe9d    	bl	0x100000f0c <_timer_time_maccess>
10000149c: f9400288    	ldr	x8, [x20]
1000014a0: f9400100    	ldr	x0, [x8]
1000014a4: 97fffeaf    	bl	0x100000f60 <_touch>
1000014a8: aa1303e0    	mov	x0, x19
1000014ac: 97fffe98    	bl	0x100000f0c <_timer_time_maccess>
1000014b0: 52800020    	mov	w0, #0x1                ; =1
1000014b4: a9417bfd    	ldp	x29, x30, [sp, #0x10]
1000014b8: a8c24ff4    	ldp	x20, x19, [sp], #0x20
1000014bc: d65f03c0    	ret
1000014c0: 52800020    	mov	w0, #0x1                ; =1
1000014c4: 94000079    	bl	0x1000016a8 <_thread_policy_set+0x1000016a8>

00000001000014c8 <_main1>:
1000014c8: d101c3ff    	sub	sp, sp, #0x70
1000014cc: a90267fa    	stp	x26, x25, [sp, #0x20]
1000014d0: a9035ff8    	stp	x24, x23, [sp, #0x30]
1000014d4: a90457f6    	stp	x22, x21, [sp, #0x40]
1000014d8: a9054ff4    	stp	x20, x19, [sp, #0x50]
1000014dc: a9067bfd    	stp	x29, x30, [sp, #0x60]
1000014e0: 910183fd    	add	x29, sp, #0x60
1000014e4: b200e7e8    	mov	x8, #0x3333333333333333 ; =3689348814741910323
1000014e8: f2e7fa68    	movk	x8, #0x3fd3, lsl #48
1000014ec: 9e670100    	fmov	d0, x8
1000014f0: 52800000    	mov	w0, #0x0                ; =0
1000014f4: 97fffe04    	bl	0x100000d04 <_timer_init>
1000014f8: 52810000    	mov	w0, #0x800              ; =2048
1000014fc: 9400007a    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
100001500: aa0003f3    	mov	x19, x0
100001504: 97fffea5    	bl	0x100000f98 <_calibrate_latency>
100001508: aa0003f4    	mov	x20, x0
10000150c: 52810000    	mov	w0, #0x800              ; =2048
100001510: 94000075    	bl	0x1000016e4 <_thread_policy_set+0x1000016e4>
100001514: aa0003f5    	mov	x21, x0
100001518: aa1303e0    	mov	x0, x19
10000151c: aa1403e1    	mov	x1, x20
100001520: 97ffff29    	bl	0x1000011c4 <_find_eviction_set>
100001524: aa0003f6    	mov	x22, x0
100001528: f90003f6    	str	x22, [sp]
10000152c: 90000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100001530: 9128a000    	add	x0, x0, #0xa28
100001534: 94000084    	bl	0x100001744 <_thread_policy_set+0x100001744>
100001538: 52800019    	mov	w25, #0x0               ; =0
10000153c: 52800017    	mov	w23, #0x0               ; =0
100001540: 52800018    	mov	w24, #0x0               ; =0
100001544: f000003a    	adrp	x26, 0x100008000 <_page_size>
100001548: 9101a35a    	add	x26, x26, #0x68
10000154c: 2a1603f6    	mov	w22, w22
100001550: 14000008    	b	0x100001570 <_main1+0xa8>
100001554: aa1503e0    	mov	x0, x21
100001558: 97fffe6d    	bl	0x100000f0c <_timer_time_maccess>
10000155c: 6b14001f    	cmp	w0, w20
100001560: 1a983718    	cinc	w24, w24, hs
100001564: 11000739    	add	w25, w25, #0x1
100001568: 710fa33f    	cmp	w25, #0x3e8
10000156c: 54000300    	b.eq	0x1000015cc <_main1+0x104>
100001570: 34000116    	cbz	w22, 0x100001590 <_main1+0xc8>
100001574: f9400348    	ldr	x8, [x26]
100001578: aa1603e9    	mov	x9, x22
10000157c: f840850a    	ldr	x10, [x8], #0x8
100001580: 3940014a    	ldrb	w10, [x10]
100001584: 39007bea    	strb	w10, [sp, #0x1e]
100001588: f1000529    	subs	x9, x9, #0x1
10000158c: 54ffff81    	b.ne	0x10000157c <_main1+0xb4>
100001590: aa1303e0    	mov	x0, x19
100001594: 97fffe5e    	bl	0x100000f0c <_timer_time_maccess>
100001598: 6b14001f    	cmp	w0, w20
10000159c: 1a9726f7    	cinc	w23, w23, lo
1000015a0: aa1503e0    	mov	x0, x21
1000015a4: 97fffe6f    	bl	0x100000f60 <_touch>
1000015a8: 34fffd76    	cbz	w22, 0x100001554 <_main1+0x8c>
1000015ac: f9400348    	ldr	x8, [x26]
1000015b0: aa1603e9    	mov	x9, x22
1000015b4: f840850a    	ldr	x10, [x8], #0x8
1000015b8: 3940014a    	ldrb	w10, [x10]
1000015bc: 39007fea    	strb	w10, [sp, #0x1f]
1000015c0: f1000529    	subs	x9, x9, #0x1
1000015c4: 54ffff81    	b.ne	0x1000015b4 <_main1+0xec>
1000015c8: 17ffffe3    	b	0x100001554 <_main1+0x8c>
1000015cc: a90063f7    	stp	x23, x24, [sp]
1000015d0: 90000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
1000015d4: 91291400    	add	x0, x0, #0xa45
1000015d8: 9400005b    	bl	0x100001744 <_thread_policy_set+0x100001744>
1000015dc: 52800000    	mov	w0, #0x0                ; =0
1000015e0: a9467bfd    	ldp	x29, x30, [sp, #0x60]
1000015e4: a9454ff4    	ldp	x20, x19, [sp, #0x50]
1000015e8: a94457f6    	ldp	x22, x21, [sp, #0x40]
1000015ec: a9435ff8    	ldp	x24, x23, [sp, #0x30]
1000015f0: a94267fa    	ldp	x26, x25, [sp, #0x20]
1000015f4: 9101c3ff    	add	sp, sp, #0x70
1000015f8: d65f03c0    	ret

00000001000015fc <_naive_attacker.cold.1>:
1000015fc: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
100001600: 910003fd    	mov	x29, sp
100001604: 90000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100001608: 91229000    	add	x0, x0, #0x8a4
10000160c: 94000048    	bl	0x10000172c <_thread_policy_set+0x10000172c>
100001610: 52800020    	mov	w0, #0x1                ; =1
100001614: 94000025    	bl	0x1000016a8 <_thread_policy_set+0x1000016a8>

0000000100001618 <_main.cold.1>:
100001618: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
10000161c: 910003fd    	mov	x29, sp
100001620: 90000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100001624: 9122dc00    	add	x0, x0, #0x8b7
100001628: 94000041    	bl	0x10000172c <_thread_policy_set+0x10000172c>
10000162c: 52800020    	mov	w0, #0x1                ; =1
100001630: 9400001e    	bl	0x1000016a8 <_thread_policy_set+0x1000016a8>

0000000100001634 <_calibrate_latency.cold.1>:
100001634: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
100001638: 910003fd    	mov	x29, sp
10000163c: 90000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100001640: 91271c00    	add	x0, x0, #0x9c7
100001644: 90000001    	adrp	x1, 0x100001000 <_calibrate_latency+0x68>
100001648: 91276421    	add	x1, x1, #0x9d9
10000164c: 90000003    	adrp	x3, 0x100001000 <_calibrate_latency+0x68>
100001650: 91278463    	add	x3, x3, #0x9e1
100001654: 528019c2    	mov	w2, #0xce               ; =206
100001658: 94000008    	bl	0x100001678 <_thread_policy_set+0x100001678>

000000010000165c <_calibrate_latency.cold.2>:
10000165c: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
100001660: 910003fd    	mov	x29, sp
100001664: 90000000    	adrp	x0, 0x100001000 <_calibrate_latency+0x68>
100001668: 9126d800    	add	x0, x0, #0x9b6
10000166c: 94000030    	bl	0x10000172c <_thread_policy_set+0x10000172c>
100001670: 12800000    	mov	w0, #-0x1               ; =-1
100001674: 9400000d    	bl	0x1000016a8 <_thread_policy_set+0x1000016a8>

Disassembly of section __TEXT,__stubs:

0000000100001678 <__stubs>:
100001678: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000167c: f9400610    	ldr	x16, [x16, #0x8]
100001680: d61f0200    	br	x16
100001684: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001688: f9400a10    	ldr	x16, [x16, #0x10]
10000168c: d61f0200    	br	x16
100001690: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001694: f9400e10    	ldr	x16, [x16, #0x18]
100001698: d61f0200    	br	x16
10000169c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000016a0: f9401a10    	ldr	x16, [x16, #0x30]
1000016a4: d61f0200    	br	x16
1000016a8: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000016ac: f9401e10    	ldr	x16, [x16, #0x38]
1000016b0: d61f0200    	br	x16
1000016b4: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000016b8: f9402210    	ldr	x16, [x16, #0x40]
1000016bc: d61f0200    	br	x16
1000016c0: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000016c4: f9402610    	ldr	x16, [x16, #0x48]
1000016c8: d61f0200    	br	x16
1000016cc: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000016d0: f9402a10    	ldr	x16, [x16, #0x50]
1000016d4: d61f0200    	br	x16
1000016d8: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000016dc: f9402e10    	ldr	x16, [x16, #0x58]
1000016e0: d61f0200    	br	x16
1000016e4: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000016e8: f9403210    	ldr	x16, [x16, #0x60]
1000016ec: d61f0200    	br	x16
1000016f0: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000016f4: f9403610    	ldr	x16, [x16, #0x68]
1000016f8: d61f0200    	br	x16
1000016fc: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001700: f9403a10    	ldr	x16, [x16, #0x70]
100001704: d61f0200    	br	x16
100001708: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000170c: f9403e10    	ldr	x16, [x16, #0x78]
100001710: d61f0200    	br	x16
100001714: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001718: f9404210    	ldr	x16, [x16, #0x80]
10000171c: d61f0200    	br	x16
100001720: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001724: f9404610    	ldr	x16, [x16, #0x88]
100001728: d61f0200    	br	x16
10000172c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001730: f9404a10    	ldr	x16, [x16, #0x90]
100001734: d61f0200    	br	x16
100001738: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000173c: f9404e10    	ldr	x16, [x16, #0x98]
100001740: d61f0200    	br	x16
100001744: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001748: f9405210    	ldr	x16, [x16, #0xa0]
10000174c: d61f0200    	br	x16
100001750: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001754: f9405610    	ldr	x16, [x16, #0xa8]
100001758: d61f0200    	br	x16
10000175c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001760: f9405a10    	ldr	x16, [x16, #0xb0]
100001764: d61f0200    	br	x16
100001768: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000176c: f9405e10    	ldr	x16, [x16, #0xb8]
100001770: d61f0200    	br	x16
100001774: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001778: f9406210    	ldr	x16, [x16, #0xc0]
10000177c: d61f0200    	br	x16
100001780: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001784: f9406610    	ldr	x16, [x16, #0xc8]
100001788: d61f0200    	br	x16
10000178c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001790: f9406a10    	ldr	x16, [x16, #0xd0]
100001794: d61f0200    	br	x16
100001798: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000179c: f9406e10    	ldr	x16, [x16, #0xd8]
1000017a0: d61f0200    	br	x16
1000017a4: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017a8: f9407210    	ldr	x16, [x16, #0xe0]
1000017ac: d61f0200    	br	x16
