
spectre:	file format mach-o arm64

Disassembly of section __TEXT,__text:

00000001000005e8 <_cselect>:
1000005e8: 7100005f    	cmp	w2, #0x0
1000005ec: 9a811000    	csel	x0, x0, x1, ne
1000005f0: d65f03c0    	ret

00000001000005f4 <_decode_flush_reload_state>:
1000005f4: d101c3ff    	sub	sp, sp, #0x70
1000005f8: a9035ff8    	stp	x24, x23, [sp, #0x30]
1000005fc: a90457f6    	stp	x22, x21, [sp, #0x40]
100000600: a9054ff4    	stp	x20, x19, [sp, #0x50]
100000604: a9067bfd    	stp	x29, x30, [sp, #0x60]
100000608: 910183fd    	add	x29, sp, #0x60
10000060c: aa0003f3    	mov	x19, x0
100000610: 52802008    	mov	w8, #0x100              ; =256
100000614: f104005f    	cmp	x2, #0x100
100000618: 9a883048    	csel	x8, x2, x8, lo
10000061c: b4000222    	cbz	x2, 0x100000660 <_decode_flush_reload_state+0x6c>
100000620: d2800014    	mov	x20, #0x0               ; =0
100000624: d2800009    	mov	x9, #0x0                ; =0
100000628: 52800016    	mov	w22, #0x0               ; =0
10000062c: 5280000a    	mov	w10, #0x0               ; =0
100000630: d2800015    	mov	x21, #0x0               ; =0
100000634: f869782b    	ldr	x11, [x1, x9, lsl #3]
100000638: eb0b029f    	cmp	x20, x11
10000063c: 9a9422b5    	csel	x21, x21, x20, hs
100000640: 1a892157    	csel	w23, w10, w9, hs
100000644: 1a8a22d6    	csel	w22, w22, w10, hs
100000648: 9a8b2294    	csel	x20, x20, x11, hs
10000064c: 91000529    	add	x9, x9, #0x1
100000650: aa1703ea    	mov	x10, x23
100000654: eb09011f    	cmp	x8, x9
100000658: 54fffee1    	b.ne	0x100000634 <_decode_flush_reload_state+0x40>
10000065c: 14000005    	b	0x100000670 <_decode_flush_reload_state+0x7c>
100000660: d2800015    	mov	x21, #0x0               ; =0
100000664: 52800017    	mov	w23, #0x0               ; =0
100000668: 52800016    	mov	w22, #0x0               ; =0
10000066c: d2800014    	mov	x20, #0x0               ; =0
100000670: 90000038    	adrp	x24, 0x100004000 <_thread_policy_set+0x100004000>
100000674: f9400318    	ldr	x24, [x24]
100000678: 373800b7    	tbnz	w23, #0x7, 0x10000068c <_decode_flush_reload_state+0x98>
10000067c: 8b370b08    	add	x8, x24, w23, uxtb #2
100000680: b9403d08    	ldr	w8, [x8, #0x3c]
100000684: 120e0100    	and	w0, w8, #0x40000
100000688: 14000004    	b	0x100000698 <_decode_flush_reload_state+0xa4>
10000068c: 12001ee0    	and	w0, w23, #0xff
100000690: 52a00081    	mov	w1, #0x40000            ; =262144
100000694: 9400042d    	bl	0x100001748 <_thread_policy_set+0x100001748>
100000698: 52800a88    	mov	w8, #0x54               ; =84
10000069c: 7100001f    	cmp	w0, #0x0
1000006a0: 1a970117    	csel	w23, w8, w23, eq
1000006a4: 39000277    	strb	w23, [x19]
1000006a8: 12001ed3    	and	w19, w22, #0xff
1000006ac: 373800b6    	tbnz	w22, #0x7, 0x1000006c0 <_decode_flush_reload_state+0xcc>
1000006b0: 8b360b08    	add	x8, x24, w22, uxtb #2
1000006b4: b9403d08    	ldr	w8, [x8, #0x3c]
1000006b8: 120e0100    	and	w0, w8, #0x40000
1000006bc: 14000004    	b	0x1000006cc <_decode_flush_reload_state+0xd8>
1000006c0: aa1303e0    	mov	x0, x19
1000006c4: 52a00081    	mov	w1, #0x40000            ; =262144
1000006c8: 94000420    	bl	0x100001748 <_thread_policy_set+0x100001748>
1000006cc: 13001ec8    	sxtb	w8, w22
1000006d0: 528007e9    	mov	w9, #0x3f               ; =63
1000006d4: 7100001f    	cmp	w0, #0x0
1000006d8: 1a880128    	csel	w8, w9, w8, eq
1000006dc: a90257f3    	stp	x19, x21, [sp, #0x20]
1000006e0: 93401ee9    	sxtb	x9, w23
1000006e4: a90027e9    	stp	x9, x9, [sp]
1000006e8: a90123f4    	stp	x20, x8, [sp, #0x10]
1000006ec: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
1000006f0: 91224c00    	add	x0, x0, #0x893
1000006f4: 94000445    	bl	0x100001808 <_thread_policy_set+0x100001808>
1000006f8: a9467bfd    	ldp	x29, x30, [sp, #0x60]
1000006fc: a9454ff4    	ldp	x20, x19, [sp, #0x50]
100000700: a94457f6    	ldp	x22, x21, [sp, #0x40]
100000704: a9435ff8    	ldp	x24, x23, [sp, #0x30]
100000708: 9101c3ff    	add	sp, sp, #0x70
10000070c: d65f03c0    	ret

0000000100000710 <_naive_victim>:
100000710: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000714: f9410908    	ldr	x8, [x8, #0x210]
100000718: eb01011f    	cmp	x8, x1
10000071c: 5400012d    	b.le	0x100000740 <_naive_victim+0x30>
100000720: d10043ff    	sub	sp, sp, #0x10
100000724: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000728: 91080508    	add	x8, x8, #0x201
10000072c: 38616908    	ldrb	w8, [x8, x1]
100000730: 9b027d08    	mul	x8, x8, x2
100000734: 38686808    	ldrb	w8, [x0, x8]
100000738: 39003fe8    	strb	w8, [sp, #0xf]
10000073c: 910043ff    	add	sp, sp, #0x10
100000740: 52800000    	mov	w0, #0x0                ; =0
100000744: d65f03c0    	ret

0000000100000748 <_naive_attacker>:
100000748: a9ba6ffc    	stp	x28, x27, [sp, #-0x60]!
10000074c: a90167fa    	stp	x26, x25, [sp, #0x10]
100000750: a9025ff8    	stp	x24, x23, [sp, #0x20]
100000754: a90357f6    	stp	x22, x21, [sp, #0x30]
100000758: a9044ff4    	stp	x20, x19, [sp, #0x40]
10000075c: a9057bfd    	stp	x29, x30, [sp, #0x50]
100000760: 910143fd    	add	x29, sp, #0x50
100000764: d12a03ff    	sub	sp, sp, #0xa80
100000768: aa0103f3    	mov	x19, x1
10000076c: aa0003f8    	mov	x24, x0
100000770: 910183f4    	add	x20, sp, #0x60
100000774: 90000028    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100000778: f9401108    	ldr	x8, [x8, #0x20]
10000077c: f9400108    	ldr	x8, [x8]
100000780: f81983a8    	stur	x8, [x29, #-0x68]
100000784: 1e6e1000    	fmov	d0, #1.00000000
100000788: 52800020    	mov	w0, #0x1                ; =1
10000078c: 9400016a    	bl	0x100000d34 <_timer_init>
100000790: aa1303e0    	mov	x0, x19
100000794: 9400022f    	bl	0x100001050 <_calibrate_latency>
100000798: aa0003f5    	mov	x21, x0
10000079c: 940002e9    	bl	0x100001340 <_find_fuzzy_eviction_set>
1000007a0: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
1000007a4: 91287c00    	add	x0, x0, #0xa1f
1000007a8: 94000427    	bl	0x100001844 <_thread_policy_set+0x100001844>
1000007ac: 9109a3e0    	add	x0, sp, #0x268
1000007b0: 52810001    	mov	w1, #0x800              ; =2048
1000007b4: 940003ee    	bl	0x10000176c <_thread_policy_set+0x10000176c>
1000007b8: 6f00e400    	movi.2d	v0, #0000000000000000
1000007bc: ad0f0280    	stp	q0, q0, [x20, #0x1e0]
1000007c0: ad0e0280    	stp	q0, q0, [x20, #0x1c0]
1000007c4: ad0d0280    	stp	q0, q0, [x20, #0x1a0]
1000007c8: ad0c0280    	stp	q0, q0, [x20, #0x180]
1000007cc: ad0b0280    	stp	q0, q0, [x20, #0x160]
1000007d0: ad0a0280    	stp	q0, q0, [x20, #0x140]
1000007d4: ad090280    	stp	q0, q0, [x20, #0x120]
1000007d8: ad080280    	stp	q0, q0, [x20, #0x100]
1000007dc: ad070280    	stp	q0, q0, [x20, #0xe0]
1000007e0: ad060280    	stp	q0, q0, [x20, #0xc0]
1000007e4: ad050280    	stp	q0, q0, [x20, #0xa0]
1000007e8: ad040280    	stp	q0, q0, [x20, #0x80]
1000007ec: ad0603e0    	stp	q0, q0, [sp, #0xc0]
1000007f0: ad0503e0    	stp	q0, q0, [sp, #0xa0]
1000007f4: ad0403e0    	stp	q0, q0, [sp, #0x80]
1000007f8: ad0303e0    	stp	q0, q0, [sp, #0x60]
1000007fc: d2800000    	mov	x0, #0x0                ; =0
100000800: 52a00801    	mov	w1, #0x400000           ; =4194304
100000804: 52800062    	mov	w2, #0x3                ; =3
100000808: 52820043    	mov	w3, #0x1002             ; =4098
10000080c: 12800004    	mov	w4, #-0x1               ; =-1
100000810: d2800005    	mov	x5, #0x0                ; =0
100000814: 940003f1    	bl	0x1000017d8 <_thread_policy_set+0x1000017d8>
100000818: b100041f    	cmn	x0, #0x1
10000081c: 540013e0    	b.eq	0x100000a98 <_naive_attacker+0x350>
100000820: aa0003f6    	mov	x22, x0
100000824: 52800021    	mov	w1, #0x1                ; =1
100000828: 52a00802    	mov	w2, #0x400000           ; =4194304
10000082c: 940003e8    	bl	0x1000017cc <_thread_policy_set+0x1000017cc>
100000830: 52802008    	mov	w8, #0x100              ; =256
100000834: f90003e8    	str	x8, [sp]
100000838: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
10000083c: 9123d000    	add	x0, x0, #0x8f4
100000840: 940003f2    	bl	0x100001808 <_thread_policy_set+0x100001808>
100000844: 90000059    	adrp	x25, 0x100008000 <_secret_default>
100000848: 91080739    	add	x25, x25, #0x201
10000084c: cb190314    	sub	x20, x24, x25
100000850: a90067f8    	stp	x24, x25, [sp]
100000854: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000858: 91241000    	add	x0, x0, #0x904
10000085c: 940003eb    	bl	0x100001808 <_thread_policy_set+0x100001808>
100000860: f90027f4    	str	x20, [sp, #0x48]
100000864: a900d3f9    	stp	x25, x20, [sp, #0x8]
100000868: f90003f8    	str	x24, [sp]
10000086c: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000870: 9124ac00    	add	x0, x0, #0x92b
100000874: 940003e5    	bl	0x100001808 <_thread_policy_set+0x100001808>
100000878: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
10000087c: 91287c00    	add	x0, x0, #0xa1f
100000880: 940003f1    	bl	0x100001844 <_thread_policy_set+0x100001844>
100000884: 39400308    	ldrb	w8, [x24]
100000888: 34000d88    	cbz	w8, 0x100000a38 <_naive_attacker+0x2f0>
10000088c: d280001a    	mov	x26, #0x0               ; =0
100000890: 9000005c    	adrp	x28, 0x100008000 <_secret_default>
100000894: 9109a3f7    	add	x23, sp, #0x268
100000898: f90023f8    	str	x24, [sp, #0x40]
10000089c: 1400001a    	b	0x100000904 <_naive_attacker+0x1bc>
1000008a0: aa0a03e0    	mov	x0, x10
1000008a4: 52a00081    	mov	w1, #0x40000            ; =262144
1000008a8: f9001fea    	str	x10, [sp, #0x38]
1000008ac: 940003a7    	bl	0x100001748 <_thread_policy_set+0x100001748>
1000008b0: f9401fea    	ldr	x10, [sp, #0x38]
1000008b4: 13001f68    	sxtb	w8, w27
1000008b8: 7100001f    	cmp	w0, #0x0
1000008bc: 528007e9    	mov	w9, #0x3f               ; =63
1000008c0: 1a880128    	csel	w8, w9, w8, eq
1000008c4: a9026bea    	stp	x10, x26, [sp, #0x20]
1000008c8: 93401f09    	sxtb	x9, w24
1000008cc: a90027e9    	stp	x9, x9, [sp]
1000008d0: a90123f4    	stp	x20, x8, [sp, #0x10]
1000008d4: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
1000008d8: 91224c00    	add	x0, x0, #0x893
1000008dc: 940003cb    	bl	0x100001808 <_thread_policy_set+0x100001808>
1000008e0: 9109a3e0    	add	x0, sp, #0x268
1000008e4: 52810001    	mov	w1, #0x800              ; =2048
1000008e8: 940003a1    	bl	0x10000176c <_thread_policy_set+0x10000176c>
1000008ec: f9402bfa    	ldr	x26, [sp, #0x50]
1000008f0: 9100075a    	add	x26, x26, #0x1
1000008f4: f94023e0    	ldr	x0, [sp, #0x40]
1000008f8: 940003d9    	bl	0x10000185c <_thread_policy_set+0x10000185c>
1000008fc: eb00035f    	cmp	x26, x0
100000900: 540009c2    	b.hs	0x100000a38 <_naive_attacker+0x2f0>
100000904: d2800014    	mov	x20, #0x0               ; =0
100000908: f94027e8    	ldr	x8, [sp, #0x48]
10000090c: f9002bfa    	str	x26, [sp, #0x50]
100000910: 8b080358    	add	x24, x26, x8
100000914: d280001a    	mov	x26, #0x0               ; =0
100000918: 14000004    	b	0x100000928 <_naive_attacker+0x1e0>
10000091c: 9100075a    	add	x26, x26, #0x1
100000920: f102035f    	cmp	x26, #0x80
100000924: 540001a0    	b.eq	0x100000958 <_naive_attacker+0x210>
100000928: 2a3a03e8    	mvn	w8, w26
10000092c: f240151f    	tst	x8, #0x3f
100000930: 9a9f031b    	csel	x27, x24, xzr, eq
100000934: 94000270    	bl	0x1000012f4 <_fuzzy_evict>
100000938: f9410b88    	ldr	x8, [x28, #0x210]
10000093c: eb1b011f    	cmp	x8, x27
100000940: 54fffeed    	b.le	0x10000091c <_naive_attacker+0x1d4>
100000944: 387b6b28    	ldrb	w8, [x25, x27]
100000948: d372c508    	lsl	x8, x8, #14
10000094c: 38686ac8    	ldrb	w8, [x22, x8]
100000950: 39017fe8    	strb	w8, [sp, #0x5f]
100000954: 17fffff2    	b	0x10000091c <_naive_attacker+0x1d4>
100000958: 528001ba    	mov	w26, #0xd               ; =13
10000095c: 5280201b    	mov	w27, #0x100             ; =256
100000960: 92401f59    	and	x25, x26, #0xff
100000964: 8b193ac0    	add	x0, x22, x25, lsl #14
100000968: aa1303e1    	mov	x1, x19
10000096c: 940000df    	bl	0x100000ce8 <_timer_time_maccess>
100000970: f8797ae8    	ldr	x8, [x23, x25, lsl #3]
100000974: eb2042bf    	cmp	x21, w0, uxtw
100000978: 9a889508    	cinc	x8, x8, hi
10000097c: f8397ae8    	str	x8, [x23, x25, lsl #3]
100000980: 91029f5a    	add	x26, x26, #0xa7
100000984: f100077b    	subs	x27, x27, #0x1
100000988: 54fffec1    	b.ne	0x100000960 <_naive_attacker+0x218>
10000098c: 91000694    	add	x20, x20, #0x1
100000990: f103229f    	cmp	x20, #0xc8
100000994: 90000059    	adrp	x25, 0x100008000 <_secret_default>
100000998: 91080739    	add	x25, x25, #0x201
10000099c: 54fffbc1    	b.ne	0x100000914 <_naive_attacker+0x1cc>
1000009a0: d2800014    	mov	x20, #0x0               ; =0
1000009a4: d2800008    	mov	x8, #0x0                ; =0
1000009a8: 5280001b    	mov	w27, #0x0               ; =0
1000009ac: 52800018    	mov	w24, #0x0               ; =0
1000009b0: d280001a    	mov	x26, #0x0               ; =0
1000009b4: f8687aea    	ldr	x10, [x23, x8, lsl #3]
1000009b8: eb0a029f    	cmp	x20, x10
1000009bc: 9a94235a    	csel	x26, x26, x20, hs
1000009c0: 1a98237b    	csel	w27, w27, w24, hs
1000009c4: 1a882318    	csel	w24, w24, w8, hs
1000009c8: 9a8a2294    	csel	x20, x20, x10, hs
1000009cc: 91000508    	add	x8, x8, #0x1
1000009d0: f104011f    	cmp	x8, #0x100
1000009d4: 54ffff01    	b.ne	0x1000009b4 <_naive_attacker+0x26c>
1000009d8: 373800f8    	tbnz	w24, #0x7, 0x1000009f4 <_naive_attacker+0x2ac>
1000009dc: 90000028    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
1000009e0: f9400108    	ldr	x8, [x8]
1000009e4: 8b380908    	add	x8, x8, w24, uxtb #2
1000009e8: b9403d08    	ldr	w8, [x8, #0x3c]
1000009ec: 120e0100    	and	w0, w8, #0x40000
1000009f0: 14000004    	b	0x100000a00 <_naive_attacker+0x2b8>
1000009f4: 12001f00    	and	w0, w24, #0xff
1000009f8: 52a00081    	mov	w1, #0x40000            ; =262144
1000009fc: 94000353    	bl	0x100001748 <_thread_policy_set+0x100001748>
100000a00: 7100001f    	cmp	w0, #0x0
100000a04: 52800a88    	mov	w8, #0x54               ; =84
100000a08: 1a980118    	csel	w24, w8, w24, eq
100000a0c: f9402be8    	ldr	x8, [sp, #0x50]
100000a10: 910183e9    	add	x9, sp, #0x60
100000a14: 38286938    	strb	w24, [x9, x8]
100000a18: 12001f6a    	and	w10, w27, #0xff
100000a1c: 373ff43b    	tbnz	w27, #0x7, 0x1000008a0 <_naive_attacker+0x158>
100000a20: 90000028    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100000a24: f9400108    	ldr	x8, [x8]
100000a28: 8b3b0908    	add	x8, x8, w27, uxtb #2
100000a2c: b9403d08    	ldr	w8, [x8, #0x3c]
100000a30: 120e0100    	and	w0, w8, #0x40000
100000a34: 17ffffa0    	b	0x1000008b4 <_naive_attacker+0x16c>
100000a38: aa1303e0    	mov	x0, x19
100000a3c: 9400016c    	bl	0x100000fec <_timer_shutdown>
100000a40: 910183e8    	add	x8, sp, #0x60
100000a44: f90003e8    	str	x8, [sp]
100000a48: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000a4c: 91253800    	add	x0, x0, #0x94e
100000a50: 9400036e    	bl	0x100001808 <_thread_policy_set+0x100001808>
100000a54: aa1603e0    	mov	x0, x22
100000a58: 52a00801    	mov	w1, #0x400000           ; =4194304
100000a5c: 94000362    	bl	0x1000017e4 <_thread_policy_set+0x1000017e4>
100000a60: f85983a8    	ldur	x8, [x29, #-0x68]
100000a64: 90000029    	adrp	x9, 0x100004000 <_thread_policy_set+0x100004000>
100000a68: f9401129    	ldr	x9, [x9, #0x20]
100000a6c: f9400129    	ldr	x9, [x9]
100000a70: eb08013f    	cmp	x9, x8
100000a74: 54000321    	b.ne	0x100000ad8 <_naive_attacker+0x390>
100000a78: 912a03ff    	add	sp, sp, #0xa80
100000a7c: a9457bfd    	ldp	x29, x30, [sp, #0x50]
100000a80: a9444ff4    	ldp	x20, x19, [sp, #0x40]
100000a84: a94357f6    	ldp	x22, x21, [sp, #0x30]
100000a88: a9425ff8    	ldp	x24, x23, [sp, #0x20]
100000a8c: a94167fa    	ldp	x26, x25, [sp, #0x10]
100000a90: a8c66ffc    	ldp	x28, x27, [sp], #0x60
100000a94: d65f03c0    	ret
100000a98: f85983a8    	ldur	x8, [x29, #-0x68]
100000a9c: 90000029    	adrp	x9, 0x100004000 <_thread_policy_set+0x100004000>
100000aa0: f9401129    	ldr	x9, [x9, #0x20]
100000aa4: f9400129    	ldr	x9, [x9]
100000aa8: eb08013f    	cmp	x9, x8
100000aac: 54000161    	b.ne	0x100000ad8 <_naive_attacker+0x390>
100000ab0: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000ab4: 9123bc00    	add	x0, x0, #0x8ef
100000ab8: 912a03ff    	add	sp, sp, #0xa80
100000abc: a9457bfd    	ldp	x29, x30, [sp, #0x50]
100000ac0: a9444ff4    	ldp	x20, x19, [sp, #0x40]
100000ac4: a94357f6    	ldp	x22, x21, [sp, #0x30]
100000ac8: a9425ff8    	ldp	x24, x23, [sp, #0x20]
100000acc: a94167fa    	ldp	x26, x25, [sp, #0x10]
100000ad0: a8c66ffc    	ldp	x28, x27, [sp], #0x60
100000ad4: 1400034a    	b	0x1000017fc <_thread_policy_set+0x1000017fc>
100000ad8: 9400031f    	bl	0x100001754 <_thread_policy_set+0x100001754>

0000000100000adc <_main>:
100000adc: d10183ff    	sub	sp, sp, #0x60
100000ae0: a9025ff8    	stp	x24, x23, [sp, #0x20]
100000ae4: a90357f6    	stp	x22, x21, [sp, #0x30]
100000ae8: a9044ff4    	stp	x20, x19, [sp, #0x40]
100000aec: a9057bfd    	stp	x29, x30, [sp, #0x50]
100000af0: 910143fd    	add	x29, sp, #0x50
100000af4: aa0103f5    	mov	x21, x1
100000af8: aa0003f3    	mov	x19, x0
100000afc: 940001d8    	bl	0x10000125c <_flush_whole_cache>
100000b00: 52800260    	mov	w0, #0x13               ; =19
100000b04: 9400032f    	bl	0x1000017c0 <_thread_policy_set+0x1000017c0>
100000b08: aa0003f4    	mov	x20, x0
100000b0c: 90000057    	adrp	x23, 0x100008000 <_secret_default>
100000b10: f94002e1    	ldr	x1, [x23]
100000b14: 52800262    	mov	w2, #0x13               ; =19
100000b18: 94000312    	bl	0x100001760 <_thread_policy_set+0x100001760>
100000b1c: 7100127f    	cmp	w19, #0x4
100000b20: 540000eb    	b.lt	0x100000b3c <_main+0x60>
100000b24: f9400ea0    	ldr	x0, [x21, #0x18]
100000b28: d2800001    	mov	x1, #0x0                ; =0
100000b2c: 52800002    	mov	w2, #0x0                ; =0
100000b30: 9400034e    	bl	0x100001868 <_thread_policy_set+0x100001868>
100000b34: aa0003f6    	mov	x22, x0
100000b38: 14000002    	b	0x100000b40 <_main+0x64>
100000b3c: d2800016    	mov	x22, #0x0               ; =0
100000b40: f94006a0    	ldr	x0, [x21, #0x8]
100000b44: d2800001    	mov	x1, #0x0                ; =0
100000b48: 52800002    	mov	w2, #0x0                ; =0
100000b4c: 94000347    	bl	0x100001868 <_thread_policy_set+0x100001868>
100000b50: aa0003f3    	mov	x19, x0
100000b54: b0000008    	adrp	x8, 0x100001000 <_timer_shutdown+0x14>
100000b58: 91292508    	add	x8, x8, #0xa49
100000b5c: b0000009    	adrp	x9, 0x100001000 <_timer_shutdown+0x14>
100000b60: 91297d29    	add	x9, x9, #0xa5f
100000b64: f100001f    	cmp	x0, #0x0
100000b68: 9a881120    	csel	x0, x9, x8, ne
100000b6c: 94000336    	bl	0x100001844 <_thread_policy_set+0x100001844>
100000b70: aa1603e0    	mov	x0, x22
100000b74: 52800001    	mov	w1, #0x0                ; =0
100000b78: 9400023a    	bl	0x100001460 <_init_secret_on_page>
100000b7c: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000b80: 91259800    	add	x0, x0, #0x966
100000b84: 94000321    	bl	0x100001808 <_thread_policy_set+0x100001808>
100000b88: f9400aa0    	ldr	x0, [x21, #0x10]
100000b8c: d2800001    	mov	x1, #0x0                ; =0
100000b90: 52800002    	mov	w2, #0x0                ; =0
100000b94: 94000335    	bl	0x100001868 <_thread_policy_set+0x100001868>
100000b98: aa0003f5    	mov	x21, x0
100000b9c: 710006bf    	cmp	w21, #0x1
100000ba0: 5400014d    	b.le	0x100000bc8 <_main+0xec>
100000ba4: 71000abf    	cmp	w21, #0x2
100000ba8: 540002e0    	b.eq	0x100000c04 <_main+0x128>
100000bac: 71000ebf    	cmp	w21, #0x3
100000bb0: 540003a0    	b.eq	0x100000c24 <_main+0x148>
100000bb4: 710012bf    	cmp	w21, #0x4
100000bb8: 54000781    	b.ne	0x100000ca8 <_main+0x1cc>
100000bbc: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000bc0: 9129d000    	add	x0, x0, #0xa74
100000bc4: 1400002a    	b	0x100000c6c <_main+0x190>
100000bc8: 340004d5    	cbz	w21, 0x100000c60 <_main+0x184>
100000bcc: 710006bf    	cmp	w21, #0x1
100000bd0: 540006c1    	b.ne	0x100000ca8 <_main+0x1cc>
100000bd4: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000bd8: 912a2000    	add	x0, x0, #0xa88
100000bdc: 9400031a    	bl	0x100001844 <_thread_policy_set+0x100001844>
100000be0: 90000054    	adrp	x20, 0x100008000 <_secret_default>
100000be4: 91020294    	add	x20, x20, #0x80
100000be8: 52801008    	mov	w8, #0x80               ; =128
100000bec: a900ffe8    	stp	x8, xzr, [sp, #0x8]
100000bf0: f90003f4    	str	x20, [sp]
100000bf4: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000bf8: 91262800    	add	x0, x0, #0x98a
100000bfc: 94000303    	bl	0x100001808 <_thread_policy_set+0x100001808>
100000c00: 1400001c    	b	0x100000c70 <_main+0x194>
100000c04: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000c08: 91096108    	add	x8, x8, #0x258
100000c0c: f9400114    	ldr	x20, [x8]
100000c10: f90003f4    	str	x20, [sp]
100000c14: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000c18: 9126cc00    	add	x0, x0, #0x9b3
100000c1c: 940002fb    	bl	0x100001808 <_thread_policy_set+0x100001808>
100000c20: 14000014    	b	0x100000c70 <_main+0x194>
100000c24: 52800f88    	mov	w8, #0x7c               ; =124
100000c28: f90003e8    	str	x8, [sp]
100000c2c: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000c30: 91272800    	add	x0, x0, #0x9ca
100000c34: 940002f5    	bl	0x100001808 <_thread_policy_set+0x100001808>
100000c38: 90000054    	adrp	x20, 0x100008000 <_secret_default>
100000c3c: 91020294    	add	x20, x20, #0x80
100000c40: 52801008    	mov	w8, #0x80               ; =128
100000c44: a900ffe8    	stp	x8, xzr, [sp, #0x8]
100000c48: f90003f4    	str	x20, [sp]
100000c4c: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000c50: 91262800    	add	x0, x0, #0x98a
100000c54: 940002ed    	bl	0x100001808 <_thread_policy_set+0x100001808>
100000c58: 9101f294    	add	x20, x20, #0x7c
100000c5c: 14000005    	b	0x100000c70 <_main+0x194>
100000c60: f94002f4    	ldr	x20, [x23]
100000c64: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000c68: 912a6400    	add	x0, x0, #0xa99
100000c6c: 940002f6    	bl	0x100001844 <_thread_policy_set+0x100001844>
100000c70: f100027f    	cmp	x19, #0x0
100000c74: 1a9f07e1    	cset	w1, ne
100000c78: aa1403e0    	mov	x0, x20
100000c7c: 97fffeb3    	bl	0x100000748 <_naive_attacker>
100000c80: 71000abf    	cmp	w21, #0x2
100000c84: 54000041    	b.ne	0x100000c8c <_main+0x1b0>
100000c88: 9400027d    	bl	0x10000167c <_destroy_secret_page>
100000c8c: 52800000    	mov	w0, #0x0                ; =0
100000c90: a9457bfd    	ldp	x29, x30, [sp, #0x50]
100000c94: a9444ff4    	ldp	x20, x19, [sp, #0x40]
100000c98: a94357f6    	ldp	x22, x21, [sp, #0x30]
100000c9c: a9425ff8    	ldp	x24, x23, [sp, #0x20]
100000ca0: 910183ff    	add	sp, sp, #0x60
100000ca4: d65f03c0    	ret
100000ca8: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000cac: 912ab800    	add	x0, x0, #0xaae
100000cb0: 940002e5    	bl	0x100001844 <_thread_policy_set+0x100001844>
100000cb4: 52800020    	mov	w0, #0x1                ; =1
100000cb8: 940002b0    	bl	0x100001778 <_thread_policy_set+0x100001778>

0000000100000cbc <__maccess>:
100000cbc: b9400008    	ldr	w8, [x0]
100000cc0: d65f03c0    	ret

0000000100000cc4 <_fence>:
100000cc4: d65f03c0    	ret

0000000100000cc8 <_timer_now>:
100000cc8: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000ccc: 9108e108    	add	x8, x8, #0x238
100000cd0: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000cd4: 91088129    	add	x9, x9, #0x220
100000cd8: 7100001f    	cmp	w0, #0x0
100000cdc: 9a881128    	csel	x8, x9, x8, ne
100000ce0: f9400100    	ldr	x0, [x8]
100000ce4: d65f03c0    	ret

0000000100000ce8 <_timer_time_maccess>:
100000ce8: d10043ff    	sub	sp, sp, #0x10
100000cec: d5033fdf    	isb
100000cf0: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000cf4: 9108e108    	add	x8, x8, #0x238
100000cf8: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000cfc: 91088129    	add	x9, x9, #0x220
100000d00: 7100003f    	cmp	w1, #0x0
100000d04: 9a881128    	csel	x8, x9, x8, ne
100000d08: f9400109    	ldr	x9, [x8]
100000d0c: d5033fdf    	isb
100000d10: 3940000a    	ldrb	w10, [x0]
100000d14: 39003fea    	strb	w10, [sp, #0xf]
100000d18: 39403fea    	ldrb	w10, [sp, #0xf]
100000d1c: d5033fdf    	isb
100000d20: f9400108    	ldr	x8, [x8]
100000d24: d5033fdf    	isb
100000d28: 4b090100    	sub	w0, w8, w9
100000d2c: 910043ff    	add	sp, sp, #0x10
100000d30: d65f03c0    	ret

0000000100000d34 <_timer_init>:
100000d34: d101c3ff    	sub	sp, sp, #0x70
100000d38: 6d0123e9    	stp	d9, d8, [sp, #0x10]
100000d3c: a90267fa    	stp	x26, x25, [sp, #0x20]
100000d40: a9035ff8    	stp	x24, x23, [sp, #0x30]
100000d44: a90457f6    	stp	x22, x21, [sp, #0x40]
100000d48: a9054ff4    	stp	x20, x19, [sp, #0x50]
100000d4c: a9067bfd    	stp	x29, x30, [sp, #0x60]
100000d50: 910183fd    	add	x29, sp, #0x60
100000d54: aa0103f4    	mov	x20, x1
100000d58: 1e604008    	fmov	d8, d0
100000d5c: aa0003f5    	mov	x21, x0
100000d60: 90000053    	adrp	x19, 0x100008000 <_secret_default>
100000d64: 9109c273    	add	x19, x19, #0x270
100000d68: aa1303e0    	mov	x0, x19
100000d6c: 94000292    	bl	0x1000017b4 <_thread_policy_set+0x1000017b4>
100000d70: 90000057    	adrp	x23, 0x100008000 <_secret_default>
100000d74: f90112ff    	str	xzr, [x23, #0x220]
100000d78: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000d7c: b902291f    	str	wzr, [x8, #0x228]
100000d80: 90000040    	adrp	x0, 0x100008000 <_secret_default>
100000d84: 910a0000    	add	x0, x0, #0x280
100000d88: 9400028b    	bl	0x1000017b4 <_thread_policy_set+0x1000017b4>
100000d8c: 90000056    	adrp	x22, 0x100008000 <_secret_default>
100000d90: 9108e2d6    	add	x22, x22, #0x238
100000d94: c89ffedf    	stlr	xzr, [x22]
100000d98: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000d9c: 91090108    	add	x8, x8, #0x240
100000da0: 889ffd1f    	stlr	wzr, [x8]
100000da4: 34000135    	cbz	w21, 0x100000dc8 <_timer_init+0x94>
100000da8: 940002a4    	bl	0x100001838 <_thread_policy_set+0x100001838>
100000dac: 940002a0    	bl	0x10000182c <_thread_policy_set+0x10000182c>
100000db0: 52800028    	mov	w8, #0x1                ; =1
100000db4: b90003e8    	str	w8, [sp]
100000db8: 910003e2    	mov	x2, sp
100000dbc: 52800081    	mov	w1, #0x4                ; =4
100000dc0: 52800023    	mov	w3, #0x1                ; =1
100000dc4: 940002ac    	bl	0x100001874 <_thread_policy_set+0x100001874>
100000dc8: 340000d4    	cbz	w20, 0x100000de0 <_timer_init+0xac>
100000dcc: 90000040    	adrp	x0, 0x100008000 <_secret_default>
100000dd0: 9109e000    	add	x0, x0, #0x278
100000dd4: 90000002    	adrp	x2, 0x100000000 <_thread_policy_set+0x100000000>
100000dd8: 913e3042    	add	x2, x2, #0xf8c
100000ddc: 14000005    	b	0x100000df0 <_timer_init+0xbc>
100000de0: 90000040    	adrp	x0, 0x100008000 <_secret_default>
100000de4: 910a2000    	add	x0, x0, #0x288
100000de8: 90000002    	adrp	x2, 0x100000000 <_thread_policy_set+0x100000000>
100000dec: 913ee042    	add	x2, x2, #0xfb8
100000df0: d2800001    	mov	x1, #0x0                ; =0
100000df4: d2800003    	mov	x3, #0x0                ; =0
100000df8: 94000287    	bl	0x100001814 <_thread_policy_set+0x100001814>
100000dfc: 35000be0    	cbnz	w0, 0x100000f78 <_timer_init+0x244>
100000e00: 340001f5    	cbz	w21, 0x100000e3c <_timer_init+0x108>
100000e04: 34000094    	cbz	w20, 0x100000e14 <_timer_init+0xe0>
100000e08: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000e0c: 9109e108    	add	x8, x8, #0x278
100000e10: 14000003    	b	0x100000e1c <_timer_init+0xe8>
100000e14: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000e18: 910a2108    	add	x8, x8, #0x288
100000e1c: f9400100    	ldr	x0, [x8]
100000e20: 94000283    	bl	0x10000182c <_thread_policy_set+0x10000182c>
100000e24: 52800028    	mov	w8, #0x1                ; =1
100000e28: b90003e8    	str	w8, [sp]
100000e2c: 910003e2    	mov	x2, sp
100000e30: 52800081    	mov	w1, #0x4                ; =4
100000e34: 52800023    	mov	w3, #0x1                ; =1
100000e38: 9400028f    	bl	0x100001874 <_thread_policy_set+0x100001874>
100000e3c: b0000008    	adrp	x8, 0x100001000 <_timer_shutdown+0x14>
100000e40: 91344108    	add	x8, x8, #0xd10
100000e44: 3dc00100    	ldr	q0, [x8]
100000e48: 3d8003e0    	str	q0, [sp]
100000e4c: 910003e0    	mov	x0, sp
100000e50: d2800001    	mov	x1, #0x0                ; =0
100000e54: 94000267    	bl	0x1000017f0 <_thread_policy_set+0x1000017f0>
100000e58: d2d9aca8    	mov	x8, #0xcd6500000000     ; =225833675390976
100000e5c: f2e839a8    	movk	x8, #0x41cd, lsl #48
100000e60: 9e670100    	fmov	d0, x8
100000e64: 1e600909    	fmul	d9, d8, d0
100000e68: f94112f5    	ldr	x21, [x23, #0x220]
100000e6c: 9400024f    	bl	0x1000017a8 <_thread_policy_set+0x1000017a8>
100000e70: aa0003f4    	mov	x20, x0
100000e74: 1e602108    	fcmp	d8, #0.0
100000e78: d2dc3468    	mov	x8, #0xe1a300000000     ; =248090195918848
100000e7c: f2e83628    	movk	x8, #0x41b1, lsl #48
100000e80: 9e670100    	fmov	d0, x8
100000e84: 1e60cd20    	fcsel	d0, d9, d0, gt
100000e88: 9e790018    	fcvtzu	x24, d0
100000e8c: 29402269    	ldp	w9, w8, [x19]
100000e90: 9b187d08    	mul	x8, x8, x24
100000e94: 9ac90919    	udiv	x25, x8, x9
100000e98: 94000244    	bl	0x1000017a8 <_thread_policy_set+0x1000017a8>
100000e9c: cb140008    	sub	x8, x0, x20
100000ea0: eb19011f    	cmp	x8, x25
100000ea4: 54ffffa3    	b.lo	0x100000e98 <_timer_init+0x164>
100000ea8: f94112f7    	ldr	x23, [x23, #0x220]
100000eac: 9400023f    	bl	0x1000017a8 <_thread_policy_set+0x1000017a8>
100000eb0: cb140008    	sub	x8, x0, x20
100000eb4: 29402a69    	ldp	w9, w10, [x19]
100000eb8: 9b097d08    	mul	x8, x8, x9
100000ebc: 9aca0908    	udiv	x8, x8, x10
100000ec0: f100051f    	cmp	x8, #0x1
100000ec4: 9a9f8508    	csinc	x8, x8, xzr, hi
100000ec8: cb1502e9    	sub	x9, x23, x21
100000ecc: 9e630120    	ucvtf	d0, x9
100000ed0: 9e630101    	ucvtf	d1, x8
100000ed4: 1e611800    	fdiv	d0, d0, d1
100000ed8: 90000055    	adrp	x21, 0x100008000 <_secret_default>
100000edc: fd011aa0    	str	d0, [x21, #0x230]
100000ee0: c8dffed7    	ldar	x23, [x22]
100000ee4: 94000231    	bl	0x1000017a8 <_thread_policy_set+0x1000017a8>
100000ee8: aa0003f4    	mov	x20, x0
100000eec: 29402269    	ldp	w9, w8, [x19]
100000ef0: 9b187d08    	mul	x8, x8, x24
100000ef4: 9ac90918    	udiv	x24, x8, x9
100000ef8: 9400022c    	bl	0x1000017a8 <_thread_policy_set+0x1000017a8>
100000efc: cb140008    	sub	x8, x0, x20
100000f00: eb18011f    	cmp	x8, x24
100000f04: 54ffffa3    	b.lo	0x100000ef8 <_timer_init+0x1c4>
100000f08: c8dffed6    	ldar	x22, [x22]
100000f0c: 94000227    	bl	0x1000017a8 <_thread_policy_set+0x1000017a8>
100000f10: cb140008    	sub	x8, x0, x20
100000f14: 29402a69    	ldp	w9, w10, [x19]
100000f18: 9b097d08    	mul	x8, x8, x9
100000f1c: 9aca0908    	udiv	x8, x8, x10
100000f20: f100051f    	cmp	x8, #0x1
100000f24: 9a9f8508    	csinc	x8, x8, xzr, hi
100000f28: cb1702c9    	sub	x9, x22, x23
100000f2c: 9e630120    	ucvtf	d0, x9
100000f30: 9e630101    	ucvtf	d1, x8
100000f34: 1e611800    	fdiv	d0, d0, d1
100000f38: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000f3c: fd012500    	str	d0, [x8, #0x248]
100000f40: fd411aa0    	ldr	d0, [x21, #0x230]
100000f44: 1e602008    	fcmp	d0, #0.0
100000f48: 54000068    	b.hi	0x100000f54 <_timer_init+0x220>
100000f4c: d2e7fe08    	mov	x8, #0x3ff0000000000000 ; =4607182418800017408
100000f50: f9011aa8    	str	x8, [x21, #0x230]
100000f54: 52800000    	mov	w0, #0x0                ; =0
100000f58: a9467bfd    	ldp	x29, x30, [sp, #0x60]
100000f5c: a9454ff4    	ldp	x20, x19, [sp, #0x50]
100000f60: a94457f6    	ldp	x22, x21, [sp, #0x40]
100000f64: a9435ff8    	ldp	x24, x23, [sp, #0x30]
100000f68: a94267fa    	ldp	x26, x25, [sp, #0x20]
100000f6c: 6d4123e9    	ldp	d9, d8, [sp, #0x10]
100000f70: 9101c3ff    	add	sp, sp, #0x70
100000f74: d65f03c0    	ret
100000f78: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100000f7c: 912b0000    	add	x0, x0, #0xac0
100000f80: 9400021f    	bl	0x1000017fc <_thread_policy_set+0x1000017fc>
100000f84: 12800000    	mov	w0, #-0x1               ; =-1
100000f88: 17fffff4    	b	0x100000f58 <_timer_init+0x224>

0000000100000f8c <_timer_thread_fn_atomic>:
100000f8c: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000f90: b9422909    	ldr	w9, [x8, #0x228]
100000f94: 350000e9    	cbnz	w9, 0x100000fb0 <_timer_thread_fn_atomic+0x24>
100000f98: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000f9c: 91088129    	add	x9, x9, #0x220
100000fa0: 5280002a    	mov	w10, #0x1               ; =1
100000fa4: f82a012b    	ldadd	x10, x11, [x9]
100000fa8: b942290b    	ldr	w11, [x8, #0x228]
100000fac: 34ffffcb    	cbz	w11, 0x100000fa4 <_timer_thread_fn_atomic+0x18>
100000fb0: d2800000    	mov	x0, #0x0                ; =0
100000fb4: d65f03c0    	ret

0000000100000fb8 <_timer_thread_fn>:
100000fb8: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000fbc: f9011d1f    	str	xzr, [x8, #0x238]
100000fc0: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000fc4: b902413f    	str	wzr, [x9, #0x240]
100000fc8: b942412a    	ldr	w10, [x9, #0x240]
100000fcc: 350000ca    	cbnz	w10, 0x100000fe4 <_timer_thread_fn+0x2c>
100000fd0: 5280002a    	mov	w10, #0x1               ; =1
100000fd4: f9011d0a    	str	x10, [x8, #0x238]
100000fd8: b942412b    	ldr	w11, [x9, #0x240]
100000fdc: 9100054a    	add	x10, x10, #0x1
100000fe0: 34ffffab    	cbz	w11, 0x100000fd4 <_timer_thread_fn+0x1c>
100000fe4: d2800000    	mov	x0, #0x0                ; =0
100000fe8: d65f03c0    	ret

0000000100000fec <_timer_shutdown>:
100000fec: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000ff0: 91090108    	add	x8, x8, #0x240
100000ff4: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000ff8: 9108a129    	add	x9, x9, #0x228
100000ffc: 7100001f    	cmp	w0, #0x0
100001000: 9a881128    	csel	x8, x9, x8, ne
100001004: 52800029    	mov	w9, #0x1                ; =1
100001008: b9000109    	str	w9, [x8]
10000100c: f0000028    	adrp	x8, 0x100008000 <_secret_default>
100001010: 9109e108    	add	x8, x8, #0x278
100001014: f0000029    	adrp	x9, 0x100008000 <_secret_default>
100001018: 910a2129    	add	x9, x9, #0x288
10000101c: 9a891108    	csel	x8, x8, x9, ne
100001020: f9400100    	ldr	x0, [x8]
100001024: d2800001    	mov	x1, #0x0                ; =0
100001028: 140001fe    	b	0x100001820 <_thread_policy_set+0x100001820>

000000010000102c <_touch>:
10000102c: 3940001f    	ldrb	wzr, [x0]
100001030: d65f03c0    	ret

0000000100001034 <_evict_by_sweep>:
100001034: b40000c1    	cbz	x1, 0x10000104c <_evict_by_sweep+0x18>
100001038: d2800008    	mov	x8, #0x0                ; =0
10000103c: 3868681f    	ldrb	wzr, [x0, x8]
100001040: 91020108    	add	x8, x8, #0x80
100001044: eb01011f    	cmp	x8, x1
100001048: 54ffffa3    	b.lo	0x10000103c <_evict_by_sweep+0x8>
10000104c: d65f03c0    	ret

0000000100001050 <_calibrate_latency>:
100001050: d10143ff    	sub	sp, sp, #0x50
100001054: a90257f6    	stp	x22, x21, [sp, #0x20]
100001058: a9034ff4    	stp	x20, x19, [sp, #0x30]
10000105c: a9047bfd    	stp	x29, x30, [sp, #0x40]
100001060: 910103fd    	add	x29, sp, #0x40
100001064: aa0003f5    	mov	x21, x0
100001068: 52801000    	mov	w0, #0x80               ; =128
10000106c: 72a10000    	movk	w0, #0x800, lsl #16
100001070: 940001d4    	bl	0x1000017c0 <_thread_policy_set+0x1000017c0>
100001074: b4000b40    	cbz	x0, 0x1000011dc <_calibrate_latency+0x18c>
100001078: aa0003f3    	mov	x19, x0
10000107c: 9287ffe8    	mov	x8, #-0x4000            ; =-16384
100001080: 52800029    	mov	w9, #0x1                ; =1
100001084: 321233ea    	mov	w10, #0x7ffc000         ; =134201344
100001088: 91401108    	add	x8, x8, #0x4, lsl #12   ; =0x4000
10000108c: 38336909    	strb	w9, [x8, x19]
100001090: eb0a011f    	cmp	x8, x10
100001094: 54ffffa3    	b.lo	0x100001088 <_calibrate_latency+0x38>
100001098: 52800100    	mov	w0, #0x8                ; =8
10000109c: 940001c9    	bl	0x1000017c0 <_thread_policy_set+0x1000017c0>
1000010a0: b40009c0    	cbz	x0, 0x1000011d8 <_calibrate_latency+0x188>
1000010a4: aa0003f4    	mov	x20, x0
1000010a8: d2800008    	mov	x8, #0x0                ; =0
1000010ac: 39400009    	ldrb	w9, [x0]
1000010b0: f000002b    	adrp	x11, 0x100008000 <_secret_default>
1000010b4: 9108e16b    	add	x11, x11, #0x238
1000010b8: 390077e9    	strb	w9, [sp, #0x1d]
1000010bc: f000002c    	adrp	x12, 0x100008000 <_secret_default>
1000010c0: 9108818c    	add	x12, x12, #0x220
1000010c4: 710002bf    	cmp	w21, #0x0
1000010c8: 9a8b1189    	csel	x9, x12, x11, ne
1000010cc: 52807d0a    	mov	w10, #0x3e8             ; =1000
1000010d0: d5033fdf    	isb
1000010d4: f940012d    	ldr	x13, [x9]
1000010d8: d5033fdf    	isb
1000010dc: 3940028e    	ldrb	w14, [x20]
1000010e0: 39007bee    	strb	w14, [sp, #0x1e]
1000010e4: 39407bee    	ldrb	w14, [sp, #0x1e]
1000010e8: d5033fdf    	isb
1000010ec: f940012e    	ldr	x14, [x9]
1000010f0: d5033fdf    	isb
1000010f4: 4b0d01cd    	sub	w13, w14, w13
1000010f8: 8b0801a8    	add	x8, x13, x8
1000010fc: 7100054a    	subs	w10, w10, #0x1
100001100: 54fffe81    	b.ne	0x1000010d0 <_calibrate_latency+0x80>
100001104: d2800009    	mov	x9, #0x0                ; =0
100001108: 710002bf    	cmp	w21, #0x0
10000110c: 9a8b118b    	csel	x11, x12, x11, ne
100001110: 32194fec    	mov	w12, #0x7ffff80         ; =134217600
100001114: d280000d    	mov	x13, #0x0               ; =0
100001118: 386d6a7f    	ldrb	wzr, [x19, x13]
10000111c: 910201ae    	add	x14, x13, #0x80
100001120: eb0c01bf    	cmp	x13, x12
100001124: aa0e03ed    	mov	x13, x14
100001128: 54ffff83    	b.lo	0x100001118 <_calibrate_latency+0xc8>
10000112c: d5033fdf    	isb
100001130: f940016d    	ldr	x13, [x11]
100001134: d5033fdf    	isb
100001138: 3940028e    	ldrb	w14, [x20]
10000113c: 39007fee    	strb	w14, [sp, #0x1f]
100001140: 39407fee    	ldrb	w14, [sp, #0x1f]
100001144: d5033fdf    	isb
100001148: f940016e    	ldr	x14, [x11]
10000114c: d5033fdf    	isb
100001150: 4b0d01cd    	sub	w13, w14, w13
100001154: 8b0901a9    	add	x9, x13, x9
100001158: 1100054a    	add	w10, w10, #0x1
10000115c: 710fa15f    	cmp	w10, #0x3e8
100001160: 54fffda1    	b.ne	0x100001114 <_calibrate_latency+0xc4>
100001164: d343fd08    	lsr	x8, x8, #3
100001168: d29ef9ea    	mov	x10, #0xf7cf            ; =63439
10000116c: f2bc6a6a    	movk	x10, #0xe353, lsl #16
100001170: f2d374aa    	movk	x10, #0x9ba5, lsl #32
100001174: f2e4188a    	movk	x10, #0x20c4, lsl #48
100001178: 9bca7d08    	umulh	x8, x8, x10
10000117c: d344fd08    	lsr	x8, x8, #4
100001180: d343fd29    	lsr	x9, x9, #3
100001184: 9bca7d29    	umulh	x9, x9, x10
100001188: d344fd29    	lsr	x9, x9, #4
10000118c: 8b09050a    	add	x10, x8, x9, lsl #1
100001190: b200f3eb    	mov	x11, #0x5555555555555555 ; =6148914691236517205
100001194: f28aaacb    	movk	x11, #0x5556
100001198: 9bcb7d55    	umulh	x21, x10, x11
10000119c: a90027e8    	stp	x8, x9, [sp]
1000011a0: f9000bf5    	str	x21, [sp, #0x10]
1000011a4: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
1000011a8: 912bfc00    	add	x0, x0, #0xaff
1000011ac: 94000197    	bl	0x100001808 <_thread_policy_set+0x100001808>
1000011b0: aa1403e0    	mov	x0, x20
1000011b4: 94000177    	bl	0x100001790 <_thread_policy_set+0x100001790>
1000011b8: aa1303e0    	mov	x0, x19
1000011bc: 94000175    	bl	0x100001790 <_thread_policy_set+0x100001790>
1000011c0: aa1503e0    	mov	x0, x21
1000011c4: a9447bfd    	ldp	x29, x30, [sp, #0x40]
1000011c8: a9434ff4    	ldp	x20, x19, [sp, #0x30]
1000011cc: a94257f6    	ldp	x22, x21, [sp, #0x20]
1000011d0: 910143ff    	add	sp, sp, #0x50
1000011d4: d65f03c0    	ret
1000011d8: 9400013a    	bl	0x1000016c0 <_calibrate_latency.cold.1>
1000011dc: 94000143    	bl	0x1000016e8 <_calibrate_latency.cold.2>

00000001000011e0 <_shuffle_ptrs>:
1000011e0: f100043f    	cmp	x1, #0x1
1000011e4: 540003a0    	b.eq	0x100001258 <_shuffle_ptrs+0x78>
1000011e8: a9bc5ff8    	stp	x24, x23, [sp, #-0x40]!
1000011ec: a90157f6    	stp	x22, x21, [sp, #0x10]
1000011f0: a9024ff4    	stp	x20, x19, [sp, #0x20]
1000011f4: a9037bfd    	stp	x29, x30, [sp, #0x30]
1000011f8: 9100c3fd    	add	x29, sp, #0x30
1000011fc: aa0103f3    	mov	x19, x1
100001200: aa0003f4    	mov	x20, x0
100001204: d2800015    	mov	x21, #0x0               ; =0
100001208: 12b00016    	mov	w22, #0x7fffffff        ; =2147483647
10000120c: aa0003f7    	mov	x23, x0
100001210: 94000190    	bl	0x100001850 <_thread_policy_set+0x100001850>
100001214: 93407c08    	sxtw	x8, w0
100001218: 9ad30ac9    	udiv	x9, x22, x19
10000121c: 91000529    	add	x9, x9, #0x1
100001220: 9ac90908    	udiv	x8, x8, x9
100001224: 8b150e89    	add	x9, x20, x21, lsl #3
100001228: f868792a    	ldr	x10, [x9, x8, lsl #3]
10000122c: f94002eb    	ldr	x11, [x23]
100001230: f828792b    	str	x11, [x9, x8, lsl #3]
100001234: f80086ea    	str	x10, [x23], #0x8
100001238: 910006b5    	add	x21, x21, #0x1
10000123c: d1000673    	sub	x19, x19, #0x1
100001240: f100067f    	cmp	x19, #0x1
100001244: 54fffe61    	b.ne	0x100001210 <_shuffle_ptrs+0x30>
100001248: a9437bfd    	ldp	x29, x30, [sp, #0x30]
10000124c: a9424ff4    	ldp	x20, x19, [sp, #0x20]
100001250: a94157f6    	ldp	x22, x21, [sp, #0x10]
100001254: a8c45ff8    	ldp	x24, x23, [sp], #0x40
100001258: d65f03c0    	ret

000000010000125c <_flush_whole_cache>:
10000125c: d100c3ff    	sub	sp, sp, #0x30
100001260: a9014ff4    	stp	x20, x19, [sp, #0x10]
100001264: a9027bfd    	stp	x29, x30, [sp, #0x20]
100001268: 910083fd    	add	x29, sp, #0x20
10000126c: f0000033    	adrp	x19, 0x100008000 <_secret_default>
100001270: f9412a68    	ldr	x8, [x19, #0x250]
100001274: b50001a8    	cbnz	x8, 0x1000012a8 <_flush_whole_cache+0x4c>
100001278: 52a10000    	mov	w0, #0x8000000          ; =134217728
10000127c: 94000151    	bl	0x1000017c0 <_thread_policy_set+0x1000017c0>
100001280: f9012a60    	str	x0, [x19, #0x250]
100001284: b4000360    	cbz	x0, 0x1000012f0 <_flush_whole_cache+0x94>
100001288: f90003e0    	str	x0, [sp]
10000128c: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100001290: 912d5000    	add	x0, x0, #0xb54
100001294: 9400015d    	bl	0x100001808 <_thread_policy_set+0x100001808>
100001298: f9412a60    	ldr	x0, [x19, #0x250]
10000129c: 528014a1    	mov	w1, #0xa5               ; =165
1000012a0: 52a10002    	mov	w2, #0x8000000          ; =134217728
1000012a4: 9400014a    	bl	0x1000017cc <_thread_policy_set+0x1000017cc>
1000012a8: d2800008    	mov	x8, #0x0                ; =0
1000012ac: b9000fff    	str	wzr, [sp, #0xc]
1000012b0: f9412a69    	ldr	x9, [x19, #0x250]
1000012b4: 32194fea    	mov	w10, #0x7ffff80         ; =134217600
1000012b8: 3868692b    	ldrb	w11, [x9, x8]
1000012bc: b9400fec    	ldr	w12, [sp, #0xc]
1000012c0: 0b0b018b    	add	w11, w12, w11
1000012c4: b9000feb    	str	w11, [sp, #0xc]
1000012c8: 9102010b    	add	x11, x8, #0x80
1000012cc: eb0a011f    	cmp	x8, x10
1000012d0: aa0b03e8    	mov	x8, x11
1000012d4: 54ffff23    	b.lo	0x1000012b8 <_flush_whole_cache+0x5c>
1000012d8: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
1000012dc: 912dc800    	add	x0, x0, #0xb72
1000012e0: a9427bfd    	ldp	x29, x30, [sp, #0x20]
1000012e4: a9414ff4    	ldp	x20, x19, [sp, #0x10]
1000012e8: 9100c3ff    	add	sp, sp, #0x30
1000012ec: 14000156    	b	0x100001844 <_thread_policy_set+0x100001844>
1000012f0: 94000105    	bl	0x100001704 <_flush_whole_cache.cold.1>

00000001000012f4 <_fuzzy_evict>:
1000012f4: a9bd57f6    	stp	x22, x21, [sp, #-0x30]!
1000012f8: a9014ff4    	stp	x20, x19, [sp, #0x10]
1000012fc: a9027bfd    	stp	x29, x30, [sp, #0x20]
100001300: 910083fd    	add	x29, sp, #0x20
100001304: d2800013    	mov	x19, #0x0               ; =0
100001308: f0000034    	adrp	x20, 0x100008000 <_secret_default>
10000130c: 910a4294    	add	x20, x20, #0x290
100001310: 52943015    	mov	w21, #0xa180            ; =41344
100001314: 72a005d5    	movk	w21, #0x2e, lsl #16
100001318: f9400288    	ldr	x8, [x20]
10000131c: f8736900    	ldr	x0, [x8, x19]
100001320: 97ffff43    	bl	0x10000102c <_touch>
100001324: 91002273    	add	x19, x19, #0x8
100001328: eb15027f    	cmp	x19, x21
10000132c: 54ffff61    	b.ne	0x100001318 <_fuzzy_evict+0x24>
100001330: a9427bfd    	ldp	x29, x30, [sp, #0x20]
100001334: a9414ff4    	ldp	x20, x19, [sp, #0x10]
100001338: a8c357f6    	ldp	x22, x21, [sp], #0x30
10000133c: d65f03c0    	ret

0000000100001340 <_find_fuzzy_eviction_set>:
100001340: a9bc5ff8    	stp	x24, x23, [sp, #-0x40]!
100001344: a90157f6    	stp	x22, x21, [sp, #0x10]
100001348: a9024ff4    	stp	x20, x19, [sp, #0x20]
10000134c: a9037bfd    	stp	x29, x30, [sp, #0x30]
100001350: 9100c3fd    	add	x29, sp, #0x30
100001354: f0000033    	adrp	x19, 0x100008000 <_secret_default>
100001358: 910a8273    	add	x19, x19, #0x2a0
10000135c: 52a10008    	mov	w8, #0x8000000          ; =134217728
100001360: f9000268    	str	x8, [x19]
100001364: 52a10000    	mov	w0, #0x8000000          ; =134217728
100001368: 94000116    	bl	0x1000017c0 <_thread_policy_set+0x1000017c0>
10000136c: f0000035    	adrp	x21, 0x100008000 <_secret_default>
100001370: 910a62b5    	add	x21, x21, #0x298
100001374: f90002a0    	str	x0, [x21]
100001378: b4000700    	cbz	x0, 0x100001458 <_find_fuzzy_eviction_set+0x118>
10000137c: f9400276    	ldr	x22, [x19]
100001380: b4000136    	cbz	x22, 0x1000013a4 <_find_fuzzy_eviction_set+0x64>
100001384: d2800008    	mov	x8, #0x0                ; =0
100001388: 52800029    	mov	w9, #0x1                ; =1
10000138c: f94002aa    	ldr	x10, [x21]
100001390: 38286949    	strb	w9, [x10, x8]
100001394: 91400508    	add	x8, x8, #0x1, lsl #12   ; =0x1000
100001398: f9400276    	ldr	x22, [x19]
10000139c: eb16011f    	cmp	x8, x22
1000013a0: 54ffff63    	b.lo	0x10000138c <_find_fuzzy_eviction_set+0x4c>
1000013a4: d347fed4    	lsr	x20, x22, #7
1000013a8: d37df293    	lsl	x19, x20, #3
1000013ac: aa1303e0    	mov	x0, x19
1000013b0: 94000104    	bl	0x1000017c0 <_thread_policy_set+0x1000017c0>
1000013b4: f0000028    	adrp	x8, 0x100008000 <_secret_default>
1000013b8: 910a4108    	add	x8, x8, #0x290
1000013bc: f9000100    	str	x0, [x8]
1000013c0: b40004c0    	cbz	x0, 0x100001458 <_find_fuzzy_eviction_set+0x118>
1000013c4: f10202df    	cmp	x22, #0x80
1000013c8: 54000163    	b.lo	0x1000013f4 <_find_fuzzy_eviction_set+0xb4>
1000013cc: d2800009    	mov	x9, #0x0                ; =0
1000013d0: d280000a    	mov	x10, #0x0               ; =0
1000013d4: f94002ab    	ldr	x11, [x21]
1000013d8: 8b09016b    	add	x11, x11, x9
1000013dc: f940010c    	ldr	x12, [x8]
1000013e0: f82a698b    	str	x11, [x12, x10]
1000013e4: 9100214a    	add	x10, x10, #0x8
1000013e8: 91020129    	add	x9, x9, #0x80
1000013ec: eb0a027f    	cmp	x19, x10
1000013f0: 54ffff21    	b.ne	0x1000013d4 <_find_fuzzy_eviction_set+0x94>
1000013f4: f100069f    	cmp	x20, #0x1
1000013f8: 54000260    	b.eq	0x100001444 <_find_fuzzy_eviction_set+0x104>
1000013fc: d2800013    	mov	x19, #0x0               ; =0
100001400: f9400115    	ldr	x21, [x8]
100001404: 12b00016    	mov	w22, #0x7fffffff        ; =2147483647
100001408: aa1503f7    	mov	x23, x21
10000140c: 94000111    	bl	0x100001850 <_thread_policy_set+0x100001850>
100001410: 93407c08    	sxtw	x8, w0
100001414: 9ad40ac9    	udiv	x9, x22, x20
100001418: 91000529    	add	x9, x9, #0x1
10000141c: 9ac90908    	udiv	x8, x8, x9
100001420: 8b130ea9    	add	x9, x21, x19, lsl #3
100001424: f868792a    	ldr	x10, [x9, x8, lsl #3]
100001428: f94002eb    	ldr	x11, [x23]
10000142c: f828792b    	str	x11, [x9, x8, lsl #3]
100001430: f80086ea    	str	x10, [x23], #0x8
100001434: 91000673    	add	x19, x19, #0x1
100001438: d1000694    	sub	x20, x20, #0x1
10000143c: f100069f    	cmp	x20, #0x1
100001440: 54fffe61    	b.ne	0x10000140c <_find_fuzzy_eviction_set+0xcc>
100001444: a9437bfd    	ldp	x29, x30, [sp, #0x30]
100001448: a9424ff4    	ldp	x20, x19, [sp, #0x20]
10000144c: a94157f6    	ldp	x22, x21, [sp, #0x10]
100001450: a8c45ff8    	ldp	x24, x23, [sp], #0x40
100001454: d65f03c0    	ret
100001458: 52800020    	mov	w0, #0x1                ; =1
10000145c: 940000c7    	bl	0x100001778 <_thread_policy_set+0x100001778>

0000000100001460 <_init_secret_on_page>:
100001460: d10183ff    	sub	sp, sp, #0x60
100001464: a9025ff8    	stp	x24, x23, [sp, #0x20]
100001468: a90357f6    	stp	x22, x21, [sp, #0x30]
10000146c: a9044ff4    	stp	x20, x19, [sp, #0x40]
100001470: a9057bfd    	stp	x29, x30, [sp, #0x50]
100001474: 910143fd    	add	x29, sp, #0x50
100001478: aa0103f3    	mov	x19, x1
10000147c: aa0003f4    	mov	x20, x0
100001480: f0000037    	adrp	x23, 0x100008000 <_secret_default>
100001484: f94156e0    	ldr	x0, [x23, #0x2a8]
100001488: f0000035    	adrp	x21, 0x100008000 <_secret_default>
10000148c: f0000036    	adrp	x22, 0x100008000 <_secret_default>
100001490: b40000a0    	cbz	x0, 0x1000014a4 <_init_secret_on_page+0x44>
100001494: 940000bf    	bl	0x100001790 <_thread_policy_set+0x100001790>
100001498: f90156ff    	str	xzr, [x23, #0x2a8]
10000149c: f90132bf    	str	xzr, [x21, #0x260]
1000014a0: f9012edf    	str	xzr, [x22, #0x258]
1000014a4: 52821000    	mov	w0, #0x1080             ; =4224
1000014a8: 940000c6    	bl	0x1000017c0 <_thread_policy_set+0x1000017c0>
1000014ac: f90156e0    	str	x0, [x23, #0x2a8]
1000014b0: b4000a40    	cbz	x0, 0x1000015f8 <_init_secret_on_page+0x198>
1000014b4: 9101fc08    	add	x8, x0, #0x7f
1000014b8: 9279e108    	and	x8, x8, #0xffffffffffffff80
1000014bc: 91400509    	add	x9, x8, #0x1, lsl #12   ; =0x1000
1000014c0: 5282100a    	mov	w10, #0x1080            ; =4224
1000014c4: 8b0a000a    	add	x10, x0, x10
1000014c8: eb0a013f    	cmp	x9, x10
1000014cc: 9a888009    	csel	x9, x0, x8, hi
1000014d0: f90132a9    	str	x9, [x21, #0x260]
1000014d4: f0000028    	adrp	x8, 0x100008000 <_secret_default>
1000014d8: f9410d0a    	ldr	x10, [x8, #0x218]
1000014dc: 5281ffeb    	mov	w11, #0xfff             ; =4095
1000014e0: cb0a016c    	sub	x12, x11, x10
1000014e4: 36000353    	tbz	w19, #0x0, 0x10000154c <_init_secret_on_page+0xec>
1000014e8: 9100068b    	add	x11, x20, #0x1
1000014ec: f100817f    	cmp	x11, #0x20
1000014f0: 54000862    	b.hs	0x1000015fc <_init_secret_on_page+0x19c>
1000014f4: d379e16d    	lsl	x13, x11, #7
1000014f8: cb4a05ab    	sub	x11, x13, x10, lsr #1
1000014fc: d379e28e    	lsl	x14, x20, #7
100001500: eb0e017f    	cmp	x11, x14
100001504: 9a8e816b    	csel	x11, x11, x14, hi
100001508: eb0c017f    	cmp	x11, x12
10000150c: 54000988    	b.hi	0x10000163c <_init_secret_on_page+0x1dc>
100001510: eb0d017f    	cmp	x11, x13
100001514: 54000082    	b.hs	0x100001524 <_init_secret_on_page+0xc4>
100001518: 8b0a016a    	add	x10, x11, x10
10000151c: eb0d015f    	cmp	x10, x13
100001520: 54000208    	b.hi	0x100001560 <_init_secret_on_page+0x100>
100001524: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100001528: f9401508    	ldr	x8, [x8, #0x28]
10000152c: f9400103    	ldr	x3, [x8]
100001530: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100001534: 9131f000    	add	x0, x0, #0xc7c
100001538: 52800801    	mov	w1, #0x40               ; =64
10000153c: 52800022    	mov	w2, #0x1                ; =1
100001540: 94000097    	bl	0x10000179c <_thread_policy_set+0x10000179c>
100001544: 52800020    	mov	w0, #0x1                ; =1
100001548: 9400008c    	bl	0x100001778 <_thread_policy_set+0x100001778>
10000154c: f100829f    	cmp	x20, #0x20
100001550: 54000662    	b.hs	0x10000161c <_init_secret_on_page+0x1bc>
100001554: d379e28b    	lsl	x11, x20, #7
100001558: eb0c017f    	cmp	x11, x12
10000155c: 540007e8    	b.hi	0x100001658 <_init_secret_on_page+0x1f8>
100001560: f000002a    	adrp	x10, 0x100008000 <_secret_default>
100001564: f9013554    	str	x20, [x10, #0x268]
100001568: 8b0b0129    	add	x9, x9, x11
10000156c: f9012ec9    	str	x9, [x22, #0x258]
100001570: f9410d09    	ldr	x9, [x8, #0x218]
100001574: b100053f    	cmn	x9, #0x1
100001578: 54000180    	b.eq	0x1000015a8 <_init_secret_on_page+0x148>
10000157c: d2800009    	mov	x9, #0x0                ; =0
100001580: 9000000b    	adrp	x11, 0x100001000 <_timer_shutdown+0x14>
100001584: 9134816b    	add	x11, x11, #0xd20
100001588: 3869696c    	ldrb	w12, [x11, x9]
10000158c: f9412ecd    	ldr	x13, [x22, #0x258]
100001590: 382969ac    	strb	w12, [x13, x9]
100001594: 91000529    	add	x9, x9, #0x1
100001598: f9410d0c    	ldr	x12, [x8, #0x218]
10000159c: 9100058c    	add	x12, x12, #0x1
1000015a0: eb0c013f    	cmp	x9, x12
1000015a4: 54ffff23    	b.lo	0x100001588 <_init_secret_on_page+0x128>
1000015a8: f94132a8    	ldr	x8, [x21, #0x260]
1000015ac: f9412ec9    	ldr	x9, [x22, #0x258]
1000015b0: f941354a    	ldr	x10, [x10, #0x268]
1000015b4: 9000000b    	adrp	x11, 0x100001000 <_timer_shutdown+0x14>
1000015b8: 9134116b    	add	x11, x11, #0xd04
1000015bc: 9000000c    	adrp	x12, 0x100001000 <_timer_shutdown+0x14>
1000015c0: 9133e58c    	add	x12, x12, #0xcf9
1000015c4: 7100027f    	cmp	w19, #0x0
1000015c8: 9a8b118b    	csel	x11, x12, x11, ne
1000015cc: a9012fea    	stp	x10, x11, [sp, #0x10]
1000015d0: a90027e8    	stp	x8, x9, [sp]
1000015d4: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
1000015d8: 9132f400    	add	x0, x0, #0xcbd
1000015dc: 9400008b    	bl	0x100001808 <_thread_policy_set+0x100001808>
1000015e0: a9457bfd    	ldp	x29, x30, [sp, #0x50]
1000015e4: a9444ff4    	ldp	x20, x19, [sp, #0x40]
1000015e8: a94357f6    	ldp	x22, x21, [sp, #0x30]
1000015ec: a9425ff8    	ldp	x24, x23, [sp, #0x20]
1000015f0: 910183ff    	add	sp, sp, #0x60
1000015f4: d65f03c0    	ret
1000015f8: 9400004a    	bl	0x100001720 <_init_secret_on_page.cold.1>
1000015fc: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100001600: f9401508    	ldr	x8, [x8, #0x28]
100001604: f9400100    	ldr	x0, [x8]
100001608: 52800408    	mov	w8, #0x20               ; =32
10000160c: a90023f4    	stp	x20, x8, [sp]
100001610: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x14>
100001614: 91302421    	add	x1, x1, #0xc09
100001618: 14000016    	b	0x100001670 <_init_secret_on_page+0x210>
10000161c: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100001620: f9401508    	ldr	x8, [x8, #0x28]
100001624: f9400100    	ldr	x0, [x8]
100001628: 528003e8    	mov	w8, #0x1f               ; =31
10000162c: a90023f4    	stp	x20, x8, [sp]
100001630: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x14>
100001634: 912e6421    	add	x1, x1, #0xb99
100001638: 1400000e    	b	0x100001670 <_init_secret_on_page+0x210>
10000163c: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100001640: f9401508    	ldr	x8, [x8, #0x28]
100001644: f9400100    	ldr	x0, [x8]
100001648: f90003f4    	str	x20, [sp]
10000164c: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x14>
100001650: 91310021    	add	x1, x1, #0xc40
100001654: 14000007    	b	0x100001670 <_init_secret_on_page+0x210>
100001658: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
10000165c: f9401508    	ldr	x8, [x8, #0x28]
100001660: f9400100    	ldr	x0, [x8]
100001664: f90003f4    	str	x20, [sp]
100001668: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x14>
10000166c: 912f4421    	add	x1, x1, #0xbd1
100001670: 94000045    	bl	0x100001784 <_thread_policy_set+0x100001784>
100001674: 52800020    	mov	w0, #0x1                ; =1
100001678: 94000040    	bl	0x100001778 <_thread_policy_set+0x100001778>

000000010000167c <_destroy_secret_page>:
10000167c: a9be4ff4    	stp	x20, x19, [sp, #-0x20]!
100001680: a9017bfd    	stp	x29, x30, [sp, #0x10]
100001684: 910043fd    	add	x29, sp, #0x10
100001688: f0000033    	adrp	x19, 0x100008000 <_secret_default>
10000168c: f9415660    	ldr	x0, [x19, #0x2a8]
100001690: b4000060    	cbz	x0, 0x10000169c <_destroy_secret_page+0x20>
100001694: 9400003f    	bl	0x100001790 <_thread_policy_set+0x100001790>
100001698: f901567f    	str	xzr, [x19, #0x2a8]
10000169c: f0000028    	adrp	x8, 0x100008000 <_secret_default>
1000016a0: f901311f    	str	xzr, [x8, #0x260]
1000016a4: f0000028    	adrp	x8, 0x100008000 <_secret_default>
1000016a8: f9012d1f    	str	xzr, [x8, #0x258]
1000016ac: f0000028    	adrp	x8, 0x100008000 <_secret_default>
1000016b0: f901351f    	str	xzr, [x8, #0x268]
1000016b4: a9417bfd    	ldp	x29, x30, [sp, #0x10]
1000016b8: a8c24ff4    	ldp	x20, x19, [sp], #0x20
1000016bc: d65f03c0    	ret

00000001000016c0 <_calibrate_latency.cold.1>:
1000016c0: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
1000016c4: 910003fd    	mov	x29, sp
1000016c8: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
1000016cc: 912b8000    	add	x0, x0, #0xae0
1000016d0: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x14>
1000016d4: 912bc821    	add	x1, x1, #0xaf2
1000016d8: 90000003    	adrp	x3, 0x100001000 <_timer_shutdown+0x14>
1000016dc: 912be863    	add	x3, x3, #0xafa
1000016e0: 52801b02    	mov	w2, #0xd8               ; =216
1000016e4: 94000016    	bl	0x10000173c <_thread_policy_set+0x10000173c>

00000001000016e8 <_calibrate_latency.cold.2>:
1000016e8: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
1000016ec: 910003fd    	mov	x29, sp
1000016f0: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
1000016f4: 912b3c00    	add	x0, x0, #0xacf
1000016f8: 94000041    	bl	0x1000017fc <_thread_policy_set+0x1000017fc>
1000016fc: 12800000    	mov	w0, #-0x1               ; =-1
100001700: 9400001e    	bl	0x100001778 <_thread_policy_set+0x100001778>

0000000100001704 <_flush_whole_cache.cold.1>:
100001704: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
100001708: 910003fd    	mov	x29, sp
10000170c: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
100001710: 912d0400    	add	x0, x0, #0xb41
100001714: 9400003a    	bl	0x1000017fc <_thread_policy_set+0x1000017fc>
100001718: 52800020    	mov	w0, #0x1                ; =1
10000171c: 94000017    	bl	0x100001778 <_thread_policy_set+0x100001778>

0000000100001720 <_init_secret_on_page.cold.1>:
100001720: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
100001724: 910003fd    	mov	x29, sp
100001728: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x14>
10000172c: 912e1800    	add	x0, x0, #0xb86
100001730: 94000033    	bl	0x1000017fc <_thread_policy_set+0x1000017fc>
100001734: 52800020    	mov	w0, #0x1                ; =1
100001738: 94000010    	bl	0x100001778 <_thread_policy_set+0x100001778>

Disassembly of section __TEXT,__stubs:

000000010000173c <__stubs>:
10000173c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001740: f9400610    	ldr	x16, [x16, #0x8]
100001744: d61f0200    	br	x16
100001748: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000174c: f9400a10    	ldr	x16, [x16, #0x10]
100001750: d61f0200    	br	x16
100001754: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001758: f9400e10    	ldr	x16, [x16, #0x18]
10000175c: d61f0200    	br	x16
100001760: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001764: f9401a10    	ldr	x16, [x16, #0x30]
100001768: d61f0200    	br	x16
10000176c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001770: f9401e10    	ldr	x16, [x16, #0x38]
100001774: d61f0200    	br	x16
100001778: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000177c: f9402210    	ldr	x16, [x16, #0x40]
100001780: d61f0200    	br	x16
100001784: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001788: f9402610    	ldr	x16, [x16, #0x48]
10000178c: d61f0200    	br	x16
100001790: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001794: f9402a10    	ldr	x16, [x16, #0x50]
100001798: d61f0200    	br	x16
10000179c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017a0: f9402e10    	ldr	x16, [x16, #0x58]
1000017a4: d61f0200    	br	x16
1000017a8: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017ac: f9403210    	ldr	x16, [x16, #0x60]
1000017b0: d61f0200    	br	x16
1000017b4: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017b8: f9403610    	ldr	x16, [x16, #0x68]
1000017bc: d61f0200    	br	x16
1000017c0: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017c4: f9403a10    	ldr	x16, [x16, #0x70]
1000017c8: d61f0200    	br	x16
1000017cc: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017d0: f9403e10    	ldr	x16, [x16, #0x78]
1000017d4: d61f0200    	br	x16
1000017d8: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017dc: f9404210    	ldr	x16, [x16, #0x80]
1000017e0: d61f0200    	br	x16
1000017e4: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017e8: f9404610    	ldr	x16, [x16, #0x88]
1000017ec: d61f0200    	br	x16
1000017f0: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017f4: f9404a10    	ldr	x16, [x16, #0x90]
1000017f8: d61f0200    	br	x16
1000017fc: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001800: f9404e10    	ldr	x16, [x16, #0x98]
100001804: d61f0200    	br	x16
100001808: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000180c: f9405210    	ldr	x16, [x16, #0xa0]
100001810: d61f0200    	br	x16
100001814: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001818: f9405610    	ldr	x16, [x16, #0xa8]
10000181c: d61f0200    	br	x16
100001820: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001824: f9405a10    	ldr	x16, [x16, #0xb0]
100001828: d61f0200    	br	x16
10000182c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001830: f9405e10    	ldr	x16, [x16, #0xb8]
100001834: d61f0200    	br	x16
100001838: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000183c: f9406210    	ldr	x16, [x16, #0xc0]
100001840: d61f0200    	br	x16
100001844: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001848: f9406610    	ldr	x16, [x16, #0xc8]
10000184c: d61f0200    	br	x16
100001850: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001854: f9406a10    	ldr	x16, [x16, #0xd0]
100001858: d61f0200    	br	x16
10000185c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001860: f9406e10    	ldr	x16, [x16, #0xd8]
100001864: d61f0200    	br	x16
100001868: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000186c: f9407210    	ldr	x16, [x16, #0xe0]
100001870: d61f0200    	br	x16
100001874: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001878: f9407610    	ldr	x16, [x16, #0xe8]
10000187c: d61f0200    	br	x16

Disassembly of section __TEXT,__cstring:

0000000100001880 <__cstring>:
100001880: 20656854    	<unknown>
100001884: 656b6163    	fnmls	z3.h, p0/m, z11.h, z11.h
100001888: 20736920    	<unknown>
10000188c: 696c2061    	ldpsw	x1, x8, [x3, #-0xa0]
100001890: 42002165    	<unknown>
100001894: 20747365    	<unknown>
100001898: 73657567    	<unknown>
10000189c: 27203a73    	<unknown>
1000018a0: 20276325    	<unknown>
1000018a4: 43534128    	<unknown>
1000018a8: 253d4949    	psel	p9, p2, p10.b[w13, 3]
1000018ac: 2c783423    	ldnp	s3, s13, [x1, #-0x40]
1000018b0: 69682320    	ldpsw	x0, x8, [x25, #-0xc0]
1000018b4: 253d7374    	<unknown>
1000018b8: 756c6c33    	<unknown>
1000018bc: 32203b29    	orr	w9, w25, #0x7fff
1000018c0: 6220646e    	<unknown>
1000018c4: 20747365    	<unknown>
1000018c8: 73657567    	<unknown>
1000018cc: 27203a73    	<unknown>
1000018d0: 20276325    	<unknown>
1000018d4: 43534128    	<unknown>
1000018d8: 253d4949    	psel	p9, p2, p10.b[w13, 3]
1000018dc: 2c783423    	ldnp	s3, s13, [x1, #-0x40]
1000018e0: 69682320    	ldpsw	x0, x8, [x25, #-0xc0]
1000018e4: 253d7374    	<unknown>
1000018e8: 756c6c33    	<unknown>
1000018ec: 6d000a29    	stp	d9, d2, [x17]
1000018f0: 0070616d    	<unknown>
1000018f4: 424d5953    	<unknown>
1000018f8: 435f4c4f    	<unknown>
1000018fc: 203a544e    	<unknown>
100001900: 000a6425    	<unknown>
100001904: 72636553    	<unknown>
100001908: 61207465    	<unknown>
10000190c: 65726464    	fnmls	z4.h, p1/m, z3.h, z18.h
100001910: 203a7373    	<unknown>
100001914: 202c7025    	<unknown>
100001918: 61727241    	<unknown>
10000191c: 64612079    	fmul	z25.h, z3.h, z1.h[4]
100001920: 73657264    	<unknown>
100001924: 25203a73    	<unknown>
100001928: 54000a70    	bc.eq	0x100001a74 <__cstring+0x1f4>
10000192c: 6d206568    	stp	d8, d25, [x11, #-0x200]
100001930: 63696c61    	<unknown>
100001934: 73756f69    	<unknown>
100001938: 646e6920    	<unknown>
10000193c: 69207865    	stgp	x5, x30, [x3, #-0x400]
100001940: 70252073    	adr	x19, 0x10004bd4f <_secret_alloc_base+0x43aa7>
100001944: 3d70252d    	ldr	b13, [x9, #0xc09]
100001948: 646c6c25    	<unknown>
10000194c: 6552000a    	fadd	z10.h, z0.h, z18.h
100001950: 65766f63    	fnmls	z3.h, p3/m, z27.h, z22.h
100001954: 20646572    	<unknown>
100001958: 72636573    	<unknown>
10000195c: 203a7465    	<unknown>
100001960: 22732522    	<unknown>
100001964: 5b1b000a    	<unknown>
100001968: 556d3333    	<unknown>
10000196c: 676e6973    	<unknown>
100001970: 6e206120    	rsubhn2.16b	v0, v9, v0
100001974: 65766961    	fnmls	z1.h, p2/m, z11.h, z22.h
100001978: 65705320    	fnmla	z0.h, p4/m, z25.h, z16.h
10000197c: 65727463    	fnmls	z3.h, p5/m, z3.h, z18.h
100001980: 436f5020    	<unknown>
100001984: 305b1b0a    	adr	x10, 0x1000b7ce5 <_secret_alloc_base+0xafa3d>
100001988: 6573006d    	fmla	z13.h, p0/m, z3.h, z19.h
10000198c: 74657263    	<unknown>
100001990: 6769625f    	<unknown>
100001994: 25203d20    	<unknown>
100001998: 73202c70    	<unknown>
10000199c: 65726365    	fnmls	z5.h, p0/m, z27.h, z18.h
1000019a0: 69625f74    	ldpsw	x20, x23, [x27, #-0xf0]
1000019a4: 25252067    	<unknown>
1000019a8: 20642520    	<unknown>
1000019ac: 7a25203d    	<unknown>
1000019b0: 55000a75    	<unknown>
1000019b4: 676e6973    	<unknown>
1000019b8: 616d6d20    	<unknown>
1000019bc: 65732070    	fmls	z16.h, p0/m, z3.h, z19.h
1000019c0: 74657263    	<unknown>
1000019c4: 7325203a    	<unknown>
1000019c8: 7355000a    	<unknown>
1000019cc: 20676e69    	<unknown>
1000019d0: 20676962    	<unknown>
1000019d4: 72636573    	<unknown>
1000019d8: 73207465    	<unknown>
1000019dc: 74726174    	<unknown>
1000019e0: 20676e69    	<unknown>
1000019e4: 63207461    	<unknown>
1000019e8: 65686361    	fnmls	z1.h, p0/m, z27.h, z8.h
1000019ec: 6e696c2d    	umin.8h	v13, v1, v9
1000019f0: 72632065    	<unknown>
1000019f4: 6973736f    	ldpsw	x15, x28, [x27, #-0x68]
1000019f8: 2820676e    	stnp	w14, w25, [x27, #-0x100]
1000019fc: 7366666f    	<unknown>
100001a00: 25207465    	<unknown>
100001a04: 3e2d2064    	<unknown>
100001a08: 73616c20    	<unknown>
100001a0c: 79622074    	ldrh	w20, [x3, #0x1110]
100001a10: 6f206574    	sqshlu.4s	v20, v11, #0x0
100001a14: 696c2066    	ldpsw	x6, x8, [x3, #-0xa0]
100001a18: 3020656e    	adr	x14, 0x1000426c5 <_secret_alloc_base+0x3a41d>
100001a1c: 2d000a29    	stp	s9, s2, [x17]
100001a20: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a24: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a28: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a2c: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a30: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a34: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a38: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a3c: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a40: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a44: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a48: 69735500    	ldpsw	x0, x21, [x8, #-0x68]
100001a4c: 7220676e    	ands	w14, w27, #0x3ffffff
100001a50: 6c756765    	ldnp	d5, d25, [x27, #-0xb0]
100001a54: 63207261    	<unknown>
100001a58: 746e756f    	<unknown>
100001a5c: 55007265    	<unknown>
100001a60: 676e6973    	<unknown>
100001a64: 6f746120    	umlsl2.4s	v0, v9, v4[3]
100001a68: 2063696d    	<unknown>
100001a6c: 6e756f63    	umin.8h	v3, v27, v21
100001a70: 00726574    	<unknown>
100001a74: 6e697355    	uabdl2.4s	v21, v26, v9
100001a78: 616d2067    	<unknown>
100001a7c: 636f6c6c    	<unknown>
100001a80: 63657320    	<unknown>
100001a84: 00746572    	<unknown>
100001a88: 6e697355    	uabdl2.4s	v21, v26, v9
100001a8c: 69622067    	ldpsw	x7, x8, [x3, #-0xf0]
100001a90: 65732067    	fmls	z7.h, p0/m, z3.h, z19.h
100001a94: 74657263    	<unknown>
100001a98: 69735500    	ldpsw	x0, x21, [x8, #-0x68]
100001a9c: 6420676e    	<unknown>
100001aa0: 75616665    	<unknown>
100001aa4: 7320746c    	<unknown>
100001aa8: 65726365    	fnmls	z5.h, p0/m, z27.h, z18.h
100001aac: 6e550074    	<unknown>
100001ab0: 70707573    	adr	x19, 0x1000e295f <_secret_alloc_base+0xda6b7>
100001ab4: 6574726f    	fnmls	z15.h, p4/m, z19.h, z20.h
100001ab8: 61762064    	<unknown>
100001abc: 0065756c    	<unknown>
100001ac0: 72687470    	<unknown>
100001ac4: 5f646165    	<unknown>
100001ac8: 61657263    	<unknown>
100001acc: 6d006574    	stp	d20, d25, [x11]
100001ad0: 6f6c6c61    	<unknown>
100001ad4: 76652063    	<unknown>
100001ad8: 5f746369    	<unknown>
100001adc: 00667562    	<unknown>
100001ae0: 696c6163    	ldpsw	x3, x24, [x11, #-0xa0]
100001ae4: 74617262    	<unknown>
100001ae8: 616c5f65    	<unknown>
100001aec: 636e6574    	<unknown>
100001af0: 69740079    	ldpsw	x25, x0, [x3, #-0x60]
100001af4: 2e72656d    	umax.4h	v13, v11, v18
100001af8: 61640063    	<unknown>
100001afc: 41006174    	<unknown>
100001b00: 202e6776    	<unknown>
100001b04: 20746968    	<unknown>
100001b08: 6574616c    	fnmls	z12.h, p0/m, z11.h, z20.h
100001b0c: 3a79636e    	<unknown>
100001b10: 6c6c2520    	ldnp	d0, d9, [x9, #-0x140]
100001b14: 41202c75    	<unknown>
100001b18: 202e6776    	<unknown>
100001b1c: 7373696d    	<unknown>
100001b20: 74616c20    	<unknown>
100001b24: 79636e65    	ldrh	w5, [x19, #0x11b6]
100001b28: 6c25203a    	stnp	d26, d8, [x1, #-0x1b0]
100001b2c: 202c756c    	<unknown>
100001b30: 65726854    	fnmls	z20.h, p2/m, z2.h, z18.h
100001b34: 6c6f6873    	ldnp	d19, d26, [x3, #-0x110]
100001b38: 25203a64    	<unknown>
100001b3c: 0a756c6c    	bic	w12, w3, w21, lsr #27
100001b40: 69766500    	ldpsw	x0, x25, [x8, #-0x50]
100001b44: 62207463    	<unknown>
100001b48: 65666675    	fnmls	z21.h, p1/m, z19.h, z6.h
100001b4c: 6c612072    	ldnp	d18, d8, [x3, #-0x1f0]
100001b50: 00636f6c    	<unknown>
100001b54: 63697645    	<unknown>
100001b58: 6e6f6974    	<unknown>
100001b5c: 66756220    	<unknown>
100001b60: 20726566    	<unknown>
100001b64: 6e696f70    	umin.8h	v16, v27, v9
100001b68: 20726574    	<unknown>
100001b6c: 7025203d    	adr	x29, 0x10004bf73 <_secret_alloc_base+0x43ccb>
100001b70: 6143000a    	<unknown>
100001b74: 20656863    	<unknown>
100001b78: 73756c66    	<unknown>
100001b7c: 676e6968    	<unknown>
100001b80: 6e6f6420    	umax.8h	v0, v1, v15
100001b84: 616d0065    	<unknown>
100001b88: 636f6c6c    	<unknown>
100001b8c: 63657320    	<unknown>
100001b90: 5f746572    	<unknown>
100001b94: 65676170    	fnmls	z16.h, p0/m, z11.h, z7.h
100001b98: 71655200    	subs	w0, w16, #0x954, lsl #12 ; =0x954000
100001b9c: 74736575    	<unknown>
100001ba0: 6c206465    	stnp	d5, d25, [x3, #-0x200]
100001ba4: 20656e69    	<unknown>
100001ba8: 65646e69    	fnmls	z9.h, p3/m, z19.h, z4.h
100001bac: 7a252078    	<unknown>
100001bb0: 73692075    	<unknown>
100001bb4: 6f6f7420    	uqshl.2d	v0, v1, #0x2f
100001bb8: 72616c20    	<unknown>
100001bbc: 203b6567    	<unknown>
100001bc0: 2078616d    	<unknown>
100001bc4: 656e696c    	fnmls	z12.h, p2/m, z11.h, z14.h
100001bc8: 20736920    	<unknown>
100001bcc: 0a757a25    	bic	w5, w17, w21, lsr #30
100001bd0: 6e614300    	raddhn2.8h	v0, v24, v1
100001bd4: 20746f6e    	<unknown>
100001bd8: 63616c70    	<unknown>
100001bdc: 65732065    	fmls	z5.h, p0/m, z3.h, z19.h
100001be0: 74657263    	<unknown>
100001be4: 20746120    	<unknown>
100001be8: 656e696c    	fnmls	z12.h, p2/m, z11.h, z14.h
100001bec: 757a2520    	<unknown>
100001bf0: 74697720    	<unknown>
100001bf4: 74756f68    	<unknown>
100001bf8: 61656c20    	<unknown>
100001bfc: 676e6976    	<unknown>
100001c00: 67657220    	<unknown>
100001c04: 0a6e6f69    	bic	w9, w27, w14, lsr #27
100001c08: 65654e00    	fnmla	z0.h, p3/m, z16.h, z5.h
100001c0c: 20612064    	<unknown>
100001c10: 7478656e    	<unknown>
100001c14: 6e696c20    	umin.8h	v0, v1, v9
100001c18: 6f742065    	umlal2.4s	v5, v3, v4[3]
100001c1c: 6f726320    	umlsl2.4s	v0, v25, v2[3]
100001c20: 203a7373    	<unknown>
100001c24: 656e696c    	fnmls	z12.h, p2/m, z11.h, z14.h
100001c28: 7864695f    	ldrh	wzr, [x10, x4]
100001c2c: 757a253d    	<unknown>
100001c30: 726e202c    	<unknown>
100001c34: 6e696c5f    	umin.8h	v31, v2, v9
100001c38: 253d7365    	<unknown>
100001c3c: 000a757a    	<unknown>
100001c40: 6e6e6143    	rsubhn2.8h	v3, v10, v14
100001c44: 7020746f    	adr	x15, 0x100042ad3 <_secret_alloc_base+0x3a82b>
100001c48: 6563616c    	fnmls	z12.h, p0/m, z11.h, z3.h
100001c4c: 63657320    	<unknown>
100001c50: 20746572    	<unknown>
100001c54: 6f726361    	umlsl2.4s	v1, v27, v2[3]
100001c58: 6c207373    	stnp	d19, d28, [x27, #-0x200]
100001c5c: 20656e69    	<unknown>
100001c60: 20757a25    	<unknown>
100001c64: 68746977    	<unknown>
100001c68: 2074756f    	<unknown>
100001c6c: 7661656c    	<unknown>
100001c70: 20676e69    	<unknown>
100001c74: 69676572    	ldpsw	x18, x25, [x11, #-0xc8]
100001c78: 000a6e6f    	<unknown>
100001c7c: 65746e49    	fnmls	z9.h, p3/m, z18.h, z20.h
100001c80: 6c616e72    	ldnp	d18, d27, [x19, #-0x1f0]
100001c84: 72726520    	<unknown>
100001c88: 203a726f    	<unknown>
100001c8c: 72636573    	<unknown>
100001c90: 64207465    	<unknown>
100001c94: 2073656f    	<unknown>
100001c98: 20746f6e    	<unknown>
100001c9c: 736f7263    	<unknown>
100001ca0: 696c2073    	ldpsw	x19, x8, [x3, #-0xa0]
100001ca4: 6220656e    	<unknown>
100001ca8: 646e756f    	<unknown>
100001cac: 20797261    	<unknown>
100001cb0: 69207361    	stgp	x1, x28, [x27, #-0x400]
100001cb4: 6e65746e    	uabd.8h	v14, v3, v5
100001cb8: 0a646564    	bic	w4, w11, w4, lsr #25
100001cbc: 63655300    	<unknown>
100001cc0: 5f746572    	<unknown>
100001cc4: 65676170    	fnmls	z16.h, p0/m, z11.h, z7.h
100001cc8: 73616220    	<unknown>
100001ccc: 203d2065    	<unknown>
100001cd0: 202c7025    	<unknown>
100001cd4: 72636573    	<unknown>
100001cd8: 3d207465    	str	b5, [x3, #0x81d]
100001cdc: 20702520    	<unknown>
100001ce0: 6e696c28    	umin.8h	v8, v1, v9
100001ce4: 7a252065    	<unknown>
100001ce8: 25202c75    	<unknown>
100001cec: 6f622073    	umlal2.4s	v19, v3, v2[2]
100001cf0: 61646e75    	<unknown>
100001cf4: 0a297972    	bic	w18, w11, w9, lsl #30
100001cf8: 72747300    	<unknown>
100001cfc: 6c646461    	ldnp	d1, d25, [x3, #-0x1c0]
100001d00: 00676e69    	<unknown>
100001d04: 67696c61    	<unknown>
100001d08: 2064656e    	<unknown>
100001d0c: 74 6f 00    	<unknown>

Disassembly of section __TEXT,__const:

0000000100001d10 <__const>:
		...
100001d18: 004c4b40    	<unknown>
100001d1c: 00000000    	udf	#0x0

0000000100001d20 <_secret_template>:
100001d20: 20656854    	<unknown>
100001d24: 656b6163    	fnmls	z3.h, p0/m, z11.h, z11.h
100001d28: 20736920    	<unknown>
100001d2c: 696c2061    	ldpsw	x1, x8, [x3, #-0xa0]
100001d30: 65 21 00    	<unknown>

Disassembly of section __TEXT,__unwind_info:

0000000100001d34 <__unwind_info>:
100001d34: 00000001    	udf	#0x1
100001d38: 0000001c    	udf	#0x1c
100001d3c: 00000005    	udf	#0x5
100001d40: 00000030    	udf	#0x30
100001d44: 00000000    	udf	#0x0
100001d48: 00000030    	udf	#0x30
100001d4c: 00000002    	udf	#0x2
100001d50: 04000007    	add	z7.b, p0/m, z7.b, z0.b
100001d54: 02000000    	<unknown>
100001d58: 02001000    	<unknown>
100001d5c: 04000001    	add	z1.b, p0/m, z1.b, z0.b
100001d60: 04000003    	add	z3.b, p0/m, z3.b, z0.b
100001d64: 000005e8    	udf	#0x5e8
100001d68: 00000054    	udf	#0x54
100001d6c: 00000054    	udf	#0x54
100001d70: 0000173c    	udf	#0x173c
100001d74: 00000000    	udf	#0x0
100001d78: 00000054    	udf	#0x54
		...
100001d88: 00000003    	udf	#0x3
100001d8c: 0010000c    	<unknown>
100001d90: 0003004c    	<unknown>
100001d94: 01000000    	<unknown>
100001d98: 0000000c    	udf	#0xc
100001d9c: 02000128    	<unknown>
100001da0: 05000160    	orr	z0.s, z0.s, #0xfff
100001da4: 000004f4    	udf	#0x4f4
100001da8: 010006d4    	<unknown>
100001dac: 02000700    	<unknown>
100001db0: 0600074c    	<unknown>
100001db4: 010009a4    	<unknown>
100001db8: 04000a68    	add	z8.b, p2/m, z8.b, z19.b
100001dbc: 00000bf8    	udf	#0xbf8
100001dc0: 03000c74    	<unknown>
100001dc4: 04000d0c    	add	z12.b, p3/m, z12.b, z8.b
100001dc8: 00000d58    	udf	#0xd58
100001dcc: 03001094    	<unknown>
100001dd0: 070010d8    	<unknown>
100001dd4: 0400001f    	add	z31.b, p0/m, z31.b, z0.b
100001dd8: 0400010f    	add	z15.b, p0/m, z15.b, z8.b
100001ddc: 04000000    	add	z0.b, p0/m, z0.b, z0.b
100001de0: 00000000    	udf	#0x0

Disassembly of section __DATA_CONST,__got:

0000000100004000 <__got>:
100004000: 00000000    	udf	#0x0
100004004: 80100000    	<unknown>
100004008: 00000001    	udf	#0x1
10000400c: 80100000    	<unknown>
100004010: 00000002    	udf	#0x2
100004014: 80100000    	<unknown>
100004018: 00000003    	udf	#0x3
10000401c: 80100000    	<unknown>
100004020: 00000004    	udf	#0x4
100004024: 80100000    	<unknown>
100004028: 00000005    	udf	#0x5
10000402c: 80100000    	<unknown>
100004030: 00000006    	udf	#0x6
100004034: 80100000    	<unknown>
100004038: 00000007    	udf	#0x7
10000403c: 80100000    	<unknown>
100004040: 00000008    	udf	#0x8
100004044: 80100000    	<unknown>
100004048: 00000009    	udf	#0x9
10000404c: 80100000    	<unknown>
100004050: 0000000a    	udf	#0xa
100004054: 80100000    	<unknown>
100004058: 0000000b    	udf	#0xb
10000405c: 80100000    	<unknown>
100004060: 0000000c    	udf	#0xc
100004064: 80100000    	<unknown>
100004068: 0000000d    	udf	#0xd
10000406c: 80100000    	<unknown>
100004070: 0000000e    	udf	#0xe
100004074: 80100000    	<unknown>
100004078: 0000000f    	udf	#0xf
10000407c: 80100000    	<unknown>
100004080: 00000010    	udf	#0x10
100004084: 80100000    	<unknown>
100004088: 00000011    	udf	#0x11
10000408c: 80100000    	<unknown>
100004090: 00000012    	udf	#0x12
100004094: 80100000    	<unknown>
100004098: 00000013    	udf	#0x13
10000409c: 80100000    	<unknown>
1000040a0: 00000014    	udf	#0x14
1000040a4: 80100000    	<unknown>
1000040a8: 00000015    	udf	#0x15
1000040ac: 80100000    	<unknown>
1000040b0: 00000016    	udf	#0x16
1000040b4: 80100000    	<unknown>
1000040b8: 00000017    	udf	#0x17
1000040bc: 80100000    	<unknown>
1000040c0: 00000018    	udf	#0x18
1000040c4: 80100000    	<unknown>
1000040c8: 00000019    	udf	#0x19
1000040cc: 80100000    	<unknown>
1000040d0: 0000001a    	udf	#0x1a
1000040d4: 80100000    	<unknown>
1000040d8: 0000001b    	udf	#0x1b
1000040dc: 80100000    	<unknown>
1000040e0: 0000001c    	udf	#0x1c
1000040e4: 80100000    	<unknown>
1000040e8: 0000001d    	udf	#0x1d
1000040ec: 80000000    	<unknown>

Disassembly of section __DATA,__data:

0000000100008000 <_secret_default>:
100008000: 00001880    	udf	#0x1880
		...

0000000100008080 <_secret_big>:
100008080: 41414141    	<unknown>
100008084: 41414141    	<unknown>
100008088: 41414141    	<unknown>
10000808c: 41414141    	<unknown>
100008090: 41414141    	<unknown>
100008094: 41414141    	<unknown>
100008098: 41414141    	<unknown>
10000809c: 41414141    	<unknown>
1000080a0: 41414141    	<unknown>
1000080a4: 41414141    	<unknown>
1000080a8: 41414141    	<unknown>
1000080ac: 41414141    	<unknown>
1000080b0: 41414141    	<unknown>
1000080b4: 41414141    	<unknown>
1000080b8: 41414141    	<unknown>
1000080bc: 41414141    	<unknown>
1000080c0: 41414141    	<unknown>
1000080c4: 41414141    	<unknown>
1000080c8: 41414141    	<unknown>
1000080cc: 41414141    	<unknown>
1000080d0: 41414141    	<unknown>
1000080d4: 41414141    	<unknown>
1000080d8: 41414141    	<unknown>
1000080dc: 41414141    	<unknown>
1000080e0: 41414141    	<unknown>
1000080e4: 41414141    	<unknown>
1000080e8: 41414141    	<unknown>
1000080ec: 41414141    	<unknown>
1000080f0: 41414141    	<unknown>
1000080f4: 41414141    	<unknown>
1000080f8: 41414141    	<unknown>
1000080fc: 41414141    	<unknown>
100008100: 42424242    	<unknown>
100008104: 42424242    	<unknown>
100008108: 42424242    	<unknown>
10000810c: 42424242    	<unknown>
100008110: 42424242    	<unknown>
100008114: 42424242    	<unknown>
100008118: 42424242    	<unknown>
10000811c: 42424242    	<unknown>
100008120: 42424242    	<unknown>
100008124: 42424242    	<unknown>
100008128: 42424242    	<unknown>
10000812c: 42424242    	<unknown>
100008130: 42424242    	<unknown>
100008134: 42424242    	<unknown>
100008138: 42424242    	<unknown>
10000813c: 42424242    	<unknown>
100008140: 42424242    	<unknown>
100008144: 42424242    	<unknown>
100008148: 42424242    	<unknown>
10000814c: 42424242    	<unknown>
100008150: 42424242    	<unknown>
100008154: 42424242    	<unknown>
100008158: 42424242    	<unknown>
10000815c: 42424242    	<unknown>
100008160: 42424242    	<unknown>
100008164: 42424242    	<unknown>
100008168: 42424242    	<unknown>
10000816c: 42424242    	<unknown>
100008170: 42424242    	<unknown>
100008174: 42424242    	<unknown>
100008178: 42424242    	<unknown>
10000817c: 42424242    	<unknown>
100008180: 43434343    	<unknown>
100008184: 43434343    	<unknown>
100008188: 43434343    	<unknown>
10000818c: 43434343    	<unknown>
100008190: 43434343    	<unknown>
100008194: 43434343    	<unknown>
100008198: 43434343    	<unknown>
10000819c: 43434343    	<unknown>
1000081a0: 43434343    	<unknown>
1000081a4: 43434343    	<unknown>
1000081a8: 43434343    	<unknown>
1000081ac: 43434343    	<unknown>
1000081b0: 43434343    	<unknown>
1000081b4: 43434343    	<unknown>
1000081b8: 43434343    	<unknown>
1000081bc: 43434343    	<unknown>
1000081c0: 43434343    	<unknown>
1000081c4: 43434343    	<unknown>
1000081c8: 43434343    	<unknown>
1000081cc: 43434343    	<unknown>
1000081d0: 43434343    	<unknown>
1000081d4: 43434343    	<unknown>
1000081d8: 43434343    	<unknown>
1000081dc: 43434343    	<unknown>
1000081e0: 43434343    	<unknown>
1000081e4: 43434343    	<unknown>
1000081e8: 43434343    	<unknown>
1000081ec: 43434343    	<unknown>
1000081f0: 43434343    	<unknown>
1000081f4: 43434343    	<unknown>
1000081f8: 43434343    	<unknown>
1000081fc: 43434343    	<unknown>
100008200: 02010000    	<unknown>

0000000100008201 <_array>:
100008201: 03020100    	<unknown>
100008205: 07060504    	<unknown>
100008209: 00000000    	udf	#0x0
10000820d: 08000000    	stxrb	w0, w0, [x0]

0000000100008210 <_array_size>:
100008210: 00000008    	udf	#0x8
100008214: 00000000    	udf	#0x0

0000000100008218 <_secret_len>:
100008218: 00000012    	udf	#0x12
10000821c: 00000000    	udf	#0x0

Disassembly of section __DATA,__common:

0000000100008220 <_g_counter>:
...

0000000100008228 <_g_stop>:
...

0000000100008230 <_g_ticks_per_ns>:
...

0000000100008238 <_counter>:
...

0000000100008240 <_stop>:
...

0000000100008248 <_ticks_per_ns>:
...

0000000100008250 <_evict_buf>:
...

0000000100008258 <_secret_mmap>:
...

0000000100008260 <_secret_page>:
...

0000000100008268 <_secret_line_idx>:
...

0000000100008270 <_g_tb>:
...

0000000100008278 <_g_thr>:
...

0000000100008280 <_tb>:
...

0000000100008288 <_thr>:
...

0000000100008290 <_evict_ptrs>:
...

0000000100008298 <_smart_evict_buf>:
...

00000001000082a0 <_smart_evict_bytes>:
...

Disassembly of section __DATA,__bss:

00000001000082a8 <_secret_alloc_base>:
...
