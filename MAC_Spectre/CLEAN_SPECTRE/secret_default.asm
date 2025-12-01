
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
100000610: 52801008    	mov	w8, #0x80               ; =128
100000614: f102005f    	cmp	x2, #0x80
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
100000694: 94000420    	bl	0x100001714 <_thread_policy_set+0x100001714>
100000698: 528007e8    	mov	w8, #0x3f               ; =63
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
1000006c8: 94000413    	bl	0x100001714 <_thread_policy_set+0x100001714>
1000006cc: 13001ec8    	sxtb	w8, w22
1000006d0: 528007e9    	mov	w9, #0x3f               ; =63
1000006d4: 7100001f    	cmp	w0, #0x0
1000006d8: 1a880128    	csel	w8, w9, w8, eq
1000006dc: a90257f3    	stp	x19, x21, [sp, #0x20]
1000006e0: 93401ee9    	sxtb	x9, w23
1000006e4: a90027e9    	stp	x9, x9, [sp]
1000006e8: a90123f4    	stp	x20, x8, [sp, #0x10]
1000006ec: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
1000006f0: 9121ac00    	add	x0, x0, #0x86b
1000006f4: 9400043b    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
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
100000764: d11a03ff    	sub	sp, sp, #0x680
100000768: aa0103f3    	mov	x19, x1
10000076c: aa0003f8    	mov	x24, x0
100000770: 910183f4    	add	x20, sp, #0x60
100000774: 90000028    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100000778: f9401108    	ldr	x8, [x8, #0x20]
10000077c: f9400108    	ldr	x8, [x8]
100000780: f81983a8    	stur	x8, [x29, #-0x68]
100000784: 1e6e1000    	fmov	d0, #1.00000000
100000788: 52800020    	mov	w0, #0x1                ; =1
10000078c: 94000160    	bl	0x100000d0c <_timer_init>
100000790: aa1303e0    	mov	x0, x19
100000794: 94000225    	bl	0x100001028 <_calibrate_latency>
100000798: aa0003f5    	mov	x21, x0
10000079c: 940002dc    	bl	0x10000130c <_find_fuzzy_eviction_set>
1000007a0: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
1000007a4: 9127e000    	add	x0, x0, #0x9f8
1000007a8: 9400041d    	bl	0x10000181c <_thread_policy_set+0x10000181c>
1000007ac: 9109a3e0    	add	x0, sp, #0x268
1000007b0: 52808001    	mov	w1, #0x400              ; =1024
1000007b4: 940003e1    	bl	0x100001738 <_thread_policy_set+0x100001738>
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
100000800: 52a00401    	mov	w1, #0x200000           ; =2097152
100000804: 52800062    	mov	w2, #0x3                ; =3
100000808: 52820043    	mov	w3, #0x1002             ; =4098
10000080c: 12800004    	mov	w4, #-0x1               ; =-1
100000810: d2800005    	mov	x5, #0x0                ; =0
100000814: 940003e4    	bl	0x1000017a4 <_thread_policy_set+0x1000017a4>
100000818: b100041f    	cmn	x0, #0x1
10000081c: 540013e0    	b.eq	0x100000a98 <_naive_attacker+0x350>
100000820: aa0003f6    	mov	x22, x0
100000824: 52800021    	mov	w1, #0x1                ; =1
100000828: 52a00402    	mov	w2, #0x200000           ; =2097152
10000082c: 940003db    	bl	0x100001798 <_thread_policy_set+0x100001798>
100000830: 52801008    	mov	w8, #0x80               ; =128
100000834: f90003e8    	str	x8, [sp]
100000838: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
10000083c: 91233000    	add	x0, x0, #0x8cc
100000840: 940003e8    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
100000844: 90000059    	adrp	x25, 0x100008000 <_secret_default>
100000848: 91080739    	add	x25, x25, #0x201
10000084c: cb190314    	sub	x20, x24, x25
100000850: a90067f8    	stp	x24, x25, [sp]
100000854: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000858: 91237000    	add	x0, x0, #0x8dc
10000085c: 940003e1    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
100000860: f90027f4    	str	x20, [sp, #0x48]
100000864: a900d3f9    	stp	x25, x20, [sp, #0x8]
100000868: f90003f8    	str	x24, [sp]
10000086c: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000870: 91240c00    	add	x0, x0, #0x903
100000874: 940003db    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
100000878: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
10000087c: 9127e000    	add	x0, x0, #0x9f8
100000880: 940003e7    	bl	0x10000181c <_thread_policy_set+0x10000181c>
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
1000008ac: 9400039a    	bl	0x100001714 <_thread_policy_set+0x100001714>
1000008b0: f9401fea    	ldr	x10, [sp, #0x38]
1000008b4: 13001f68    	sxtb	w8, w27
1000008b8: 7100001f    	cmp	w0, #0x0
1000008bc: 528007e9    	mov	w9, #0x3f               ; =63
1000008c0: 1a880128    	csel	w8, w9, w8, eq
1000008c4: a90253ea    	stp	x10, x20, [sp, #0x20]
1000008c8: 93401f09    	sxtb	x9, w24
1000008cc: a90027e9    	stp	x9, x9, [sp]
1000008d0: a90123fa    	stp	x26, x8, [sp, #0x10]
1000008d4: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
1000008d8: 9121ac00    	add	x0, x0, #0x86b
1000008dc: 940003c1    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
1000008e0: 9109a3e0    	add	x0, sp, #0x268
1000008e4: 52808001    	mov	w1, #0x400              ; =1024
1000008e8: 94000394    	bl	0x100001738 <_thread_policy_set+0x100001738>
1000008ec: f9402bfa    	ldr	x26, [sp, #0x50]
1000008f0: 9100075a    	add	x26, x26, #0x1
1000008f4: f94023e0    	ldr	x0, [sp, #0x40]
1000008f8: 940003cf    	bl	0x100001834 <_thread_policy_set+0x100001834>
1000008fc: eb00035f    	cmp	x26, x0
100000900: 540009c2    	b.hs	0x100000a38 <_naive_attacker+0x2f0>
100000904: d2800014    	mov	x20, #0x0               ; =0
100000908: f94027e8    	ldr	x8, [sp, #0x48]
10000090c: f9002bfa    	str	x26, [sp, #0x50]
100000910: 8b080358    	add	x24, x26, x8
100000914: d280001a    	mov	x26, #0x0               ; =0
100000918: 14000004    	b	0x100000928 <_naive_attacker+0x1e0>
10000091c: 9100075a    	add	x26, x26, #0x1
100000920: f100435f    	cmp	x26, #0x10
100000924: 540001a0    	b.eq	0x100000958 <_naive_attacker+0x210>
100000928: 2a3a03e8    	mvn	w8, w26
10000092c: f240091f    	tst	x8, #0x7
100000930: 9a9f031b    	csel	x27, x24, xzr, eq
100000934: 94000263    	bl	0x1000012c0 <_fuzzy_evict>
100000938: f9410b88    	ldr	x8, [x28, #0x210]
10000093c: eb1b011f    	cmp	x8, x27
100000940: 54fffeed    	b.le	0x10000091c <_naive_attacker+0x1d4>
100000944: 387b6b28    	ldrb	w8, [x25, x27]
100000948: d372c508    	lsl	x8, x8, #14
10000094c: 38686ac8    	ldrb	w8, [x22, x8]
100000950: 39017fe8    	strb	w8, [sp, #0x5f]
100000954: 17fffff2    	b	0x10000091c <_naive_attacker+0x1d4>
100000958: 528001ba    	mov	w26, #0xd               ; =13
10000095c: 5280101b    	mov	w27, #0x80              ; =128
100000960: 92401b59    	and	x25, x26, #0x7f
100000964: 8b193ac0    	add	x0, x22, x25, lsl #14
100000968: aa1303e1    	mov	x1, x19
10000096c: 940000d5    	bl	0x100000cc0 <_timer_time_maccess>
100000970: f8797ae8    	ldr	x8, [x23, x25, lsl #3]
100000974: eb2042bf    	cmp	x21, w0, uxtw
100000978: 9a889508    	cinc	x8, x8, hi
10000097c: f8397ae8    	str	x8, [x23, x25, lsl #3]
100000980: 91009f5a    	add	x26, x26, #0x27
100000984: f100077b    	subs	x27, x27, #0x1
100000988: 54fffec1    	b.ne	0x100000960 <_naive_attacker+0x218>
10000098c: 91000694    	add	x20, x20, #0x1
100000990: f103229f    	cmp	x20, #0xc8
100000994: 90000059    	adrp	x25, 0x100008000 <_secret_default>
100000998: 91080739    	add	x25, x25, #0x201
10000099c: 54fffbc1    	b.ne	0x100000914 <_naive_attacker+0x1cc>
1000009a0: d280001a    	mov	x26, #0x0               ; =0
1000009a4: d2800008    	mov	x8, #0x0                ; =0
1000009a8: 5280001b    	mov	w27, #0x0               ; =0
1000009ac: 52800018    	mov	w24, #0x0               ; =0
1000009b0: d2800014    	mov	x20, #0x0               ; =0
1000009b4: f8687aea    	ldr	x10, [x23, x8, lsl #3]
1000009b8: eb0a035f    	cmp	x26, x10
1000009bc: 9a9a2294    	csel	x20, x20, x26, hs
1000009c0: 1a98237b    	csel	w27, w27, w24, hs
1000009c4: 1a882318    	csel	w24, w24, w8, hs
1000009c8: 9a8a235a    	csel	x26, x26, x10, hs
1000009cc: 91000508    	add	x8, x8, #0x1
1000009d0: f102011f    	cmp	x8, #0x80
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
1000009fc: 94000346    	bl	0x100001714 <_thread_policy_set+0x100001714>
100000a00: 7100001f    	cmp	w0, #0x0
100000a04: 528007e8    	mov	w8, #0x3f               ; =63
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
100000a3c: 94000162    	bl	0x100000fc4 <_timer_shutdown>
100000a40: 910183e8    	add	x8, sp, #0x60
100000a44: f90003e8    	str	x8, [sp]
100000a48: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000a4c: 91249c00    	add	x0, x0, #0x927
100000a50: 94000364    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
100000a54: aa1603e0    	mov	x0, x22
100000a58: 52a00401    	mov	w1, #0x200000           ; =2097152
100000a5c: 94000355    	bl	0x1000017b0 <_thread_policy_set+0x1000017b0>
100000a60: f85983a8    	ldur	x8, [x29, #-0x68]
100000a64: 90000029    	adrp	x9, 0x100004000 <_thread_policy_set+0x100004000>
100000a68: f9401129    	ldr	x9, [x9, #0x20]
100000a6c: f9400129    	ldr	x9, [x9]
100000a70: eb08013f    	cmp	x9, x8
100000a74: 54000321    	b.ne	0x100000ad8 <_naive_attacker+0x390>
100000a78: 911a03ff    	add	sp, sp, #0x680
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
100000ab0: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000ab4: 91231c00    	add	x0, x0, #0x8c7
100000ab8: 911a03ff    	add	sp, sp, #0x680
100000abc: a9457bfd    	ldp	x29, x30, [sp, #0x50]
100000ac0: a9444ff4    	ldp	x20, x19, [sp, #0x40]
100000ac4: a94357f6    	ldp	x22, x21, [sp, #0x30]
100000ac8: a9425ff8    	ldp	x24, x23, [sp, #0x20]
100000acc: a94167fa    	ldp	x26, x25, [sp, #0x10]
100000ad0: a8c66ffc    	ldp	x28, x27, [sp], #0x60
100000ad4: 1400033d    	b	0x1000017c8 <_thread_policy_set+0x1000017c8>
100000ad8: 94000312    	bl	0x100001720 <_thread_policy_set+0x100001720>

0000000100000adc <_main>:
100000adc: d10143ff    	sub	sp, sp, #0x50
100000ae0: a90257f6    	stp	x22, x21, [sp, #0x20]
100000ae4: a9034ff4    	stp	x20, x19, [sp, #0x30]
100000ae8: a9047bfd    	stp	x29, x30, [sp, #0x40]
100000aec: 910103fd    	add	x29, sp, #0x40
100000af0: aa0103f4    	mov	x20, x1
100000af4: aa0003f3    	mov	x19, x0
100000af8: 52800260    	mov	w0, #0x13               ; =19
100000afc: 94000324    	bl	0x10000178c <_thread_policy_set+0x10000178c>
100000b00: 90000056    	adrp	x22, 0x100008000 <_secret_default>
100000b04: f94002c1    	ldr	x1, [x22]
100000b08: 52800262    	mov	w2, #0x13               ; =19
100000b0c: 94000308    	bl	0x10000172c <_thread_policy_set+0x10000172c>
100000b10: 7100127f    	cmp	w19, #0x4
100000b14: 540000eb    	b.lt	0x100000b30 <_main+0x54>
100000b18: f9400e80    	ldr	x0, [x20, #0x18]
100000b1c: d2800001    	mov	x1, #0x0                ; =0
100000b20: 52800002    	mov	w2, #0x0                ; =0
100000b24: 94000347    	bl	0x100001840 <_thread_policy_set+0x100001840>
100000b28: aa0003f5    	mov	x21, x0
100000b2c: 14000002    	b	0x100000b34 <_main+0x58>
100000b30: d2800015    	mov	x21, #0x0               ; =0
100000b34: f9400680    	ldr	x0, [x20, #0x8]
100000b38: d2800001    	mov	x1, #0x0                ; =0
100000b3c: 52800002    	mov	w2, #0x0                ; =0
100000b40: 94000340    	bl	0x100001840 <_thread_policy_set+0x100001840>
100000b44: aa0003f3    	mov	x19, x0
100000b48: b0000008    	adrp	x8, 0x100001000 <_timer_shutdown+0x3c>
100000b4c: 91288908    	add	x8, x8, #0xa22
100000b50: b0000009    	adrp	x9, 0x100001000 <_timer_shutdown+0x3c>
100000b54: 9128e129    	add	x9, x9, #0xa38
100000b58: f100001f    	cmp	x0, #0x0
100000b5c: 9a881120    	csel	x0, x9, x8, ne
100000b60: 9400032f    	bl	0x10000181c <_thread_policy_set+0x10000181c>
100000b64: aa1503e0    	mov	x0, x21
100000b68: 52800001    	mov	w1, #0x0                ; =0
100000b6c: 94000230    	bl	0x10000142c <_init_secret_on_page>
100000b70: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000b74: 9124fc00    	add	x0, x0, #0x93f
100000b78: 9400031a    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
100000b7c: f9400a80    	ldr	x0, [x20, #0x10]
100000b80: d2800001    	mov	x1, #0x0                ; =0
100000b84: 52800002    	mov	w2, #0x0                ; =0
100000b88: 9400032e    	bl	0x100001840 <_thread_policy_set+0x100001840>
100000b8c: aa0003f4    	mov	x20, x0
100000b90: 7100069f    	cmp	w20, #0x1
100000b94: 540001ec    	b.gt	0x100000bd0 <_main+0xf4>
100000b98: 34000434    	cbz	w20, 0x100000c1c <_main+0x140>
100000b9c: 7100069f    	cmp	w20, #0x1
100000ba0: 54000701    	b.ne	0x100000c80 <_main+0x1a4>
100000ba4: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000ba8: 91293400    	add	x0, x0, #0xa4d
100000bac: 9400031c    	bl	0x10000181c <_thread_policy_set+0x10000181c>
100000bb0: 90000055    	adrp	x21, 0x100008000 <_secret_default>
100000bb4: 910202b5    	add	x21, x21, #0x80
100000bb8: 52801008    	mov	w8, #0x80               ; =128
100000bbc: a900ffe8    	stp	x8, xzr, [sp, #0x8]
100000bc0: f90003f5    	str	x21, [sp]
100000bc4: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000bc8: 91258c00    	add	x0, x0, #0x963
100000bcc: 1400001f    	b	0x100000c48 <_main+0x16c>
100000bd0: 71000a9f    	cmp	w20, #0x2
100000bd4: 540002e0    	b.eq	0x100000c30 <_main+0x154>
100000bd8: 71000e9f    	cmp	w20, #0x3
100000bdc: 54000521    	b.ne	0x100000c80 <_main+0x1a4>
100000be0: 52800f88    	mov	w8, #0x7c               ; =124
100000be4: f90003e8    	str	x8, [sp]
100000be8: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000bec: 91268c00    	add	x0, x0, #0x9a3
100000bf0: 940002fc    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
100000bf4: 90000055    	adrp	x21, 0x100008000 <_secret_default>
100000bf8: 910202b5    	add	x21, x21, #0x80
100000bfc: 52801008    	mov	w8, #0x80               ; =128
100000c00: a900ffe8    	stp	x8, xzr, [sp, #0x8]
100000c04: f90003f5    	str	x21, [sp]
100000c08: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000c0c: 91258c00    	add	x0, x0, #0x963
100000c10: 940002f4    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
100000c14: 9101f2b5    	add	x21, x21, #0x7c
100000c18: 1400000d    	b	0x100000c4c <_main+0x170>
100000c1c: f94002d5    	ldr	x21, [x22]
100000c20: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000c24: 91297800    	add	x0, x0, #0xa5e
100000c28: 940002fd    	bl	0x10000181c <_thread_policy_set+0x10000181c>
100000c2c: 14000008    	b	0x100000c4c <_main+0x170>
100000c30: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000c34: 91096108    	add	x8, x8, #0x258
100000c38: f9400115    	ldr	x21, [x8]
100000c3c: f90003f5    	str	x21, [sp]
100000c40: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000c44: 91263000    	add	x0, x0, #0x98c
100000c48: 940002e6    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
100000c4c: f100027f    	cmp	x19, #0x0
100000c50: 1a9f07e1    	cset	w1, ne
100000c54: aa1503e0    	mov	x0, x21
100000c58: 97fffebc    	bl	0x100000748 <_naive_attacker>
100000c5c: 71000a9f    	cmp	w20, #0x2
100000c60: 54000041    	b.ne	0x100000c68 <_main+0x18c>
100000c64: 94000279    	bl	0x100001648 <_destroy_secret_page>
100000c68: 52800000    	mov	w0, #0x0                ; =0
100000c6c: a9447bfd    	ldp	x29, x30, [sp, #0x40]
100000c70: a9434ff4    	ldp	x20, x19, [sp, #0x30]
100000c74: a94257f6    	ldp	x22, x21, [sp, #0x20]
100000c78: 910143ff    	add	sp, sp, #0x50
100000c7c: d65f03c0    	ret
100000c80: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000c84: 9129cc00    	add	x0, x0, #0xa73
100000c88: 940002e5    	bl	0x10000181c <_thread_policy_set+0x10000181c>
100000c8c: 52800020    	mov	w0, #0x1                ; =1
100000c90: 940002ad    	bl	0x100001744 <_thread_policy_set+0x100001744>

0000000100000c94 <__maccess>:
100000c94: b9400008    	ldr	w8, [x0]
100000c98: d65f03c0    	ret

0000000100000c9c <_fence>:
100000c9c: d65f03c0    	ret

0000000100000ca0 <_timer_now>:
100000ca0: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000ca4: 9108e108    	add	x8, x8, #0x238
100000ca8: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000cac: 91088129    	add	x9, x9, #0x220
100000cb0: 7100001f    	cmp	w0, #0x0
100000cb4: 9a881128    	csel	x8, x9, x8, ne
100000cb8: f9400100    	ldr	x0, [x8]
100000cbc: d65f03c0    	ret

0000000100000cc0 <_timer_time_maccess>:
100000cc0: d10043ff    	sub	sp, sp, #0x10
100000cc4: d5033fdf    	isb
100000cc8: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000ccc: 9108e108    	add	x8, x8, #0x238
100000cd0: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000cd4: 91088129    	add	x9, x9, #0x220
100000cd8: 7100003f    	cmp	w1, #0x0
100000cdc: 9a881128    	csel	x8, x9, x8, ne
100000ce0: f9400109    	ldr	x9, [x8]
100000ce4: d5033fdf    	isb
100000ce8: 3940000a    	ldrb	w10, [x0]
100000cec: 39003fea    	strb	w10, [sp, #0xf]
100000cf0: 39403fea    	ldrb	w10, [sp, #0xf]
100000cf4: d5033fdf    	isb
100000cf8: f9400108    	ldr	x8, [x8]
100000cfc: d5033fdf    	isb
100000d00: 4b090100    	sub	w0, w8, w9
100000d04: 910043ff    	add	sp, sp, #0x10
100000d08: d65f03c0    	ret

0000000100000d0c <_timer_init>:
100000d0c: d101c3ff    	sub	sp, sp, #0x70
100000d10: 6d0123e9    	stp	d9, d8, [sp, #0x10]
100000d14: a90267fa    	stp	x26, x25, [sp, #0x20]
100000d18: a9035ff8    	stp	x24, x23, [sp, #0x30]
100000d1c: a90457f6    	stp	x22, x21, [sp, #0x40]
100000d20: a9054ff4    	stp	x20, x19, [sp, #0x50]
100000d24: a9067bfd    	stp	x29, x30, [sp, #0x60]
100000d28: 910183fd    	add	x29, sp, #0x60
100000d2c: aa0103f4    	mov	x20, x1
100000d30: 1e604008    	fmov	d8, d0
100000d34: aa0003f5    	mov	x21, x0
100000d38: 90000053    	adrp	x19, 0x100008000 <_secret_default>
100000d3c: 9109c273    	add	x19, x19, #0x270
100000d40: aa1303e0    	mov	x0, x19
100000d44: 9400028f    	bl	0x100001780 <_thread_policy_set+0x100001780>
100000d48: 90000057    	adrp	x23, 0x100008000 <_secret_default>
100000d4c: f90112ff    	str	xzr, [x23, #0x220]
100000d50: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000d54: b902291f    	str	wzr, [x8, #0x228]
100000d58: 90000040    	adrp	x0, 0x100008000 <_secret_default>
100000d5c: 910a0000    	add	x0, x0, #0x280
100000d60: 94000288    	bl	0x100001780 <_thread_policy_set+0x100001780>
100000d64: 90000056    	adrp	x22, 0x100008000 <_secret_default>
100000d68: 9108e2d6    	add	x22, x22, #0x238
100000d6c: c89ffedf    	stlr	xzr, [x22]
100000d70: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000d74: 91090108    	add	x8, x8, #0x240
100000d78: 889ffd1f    	stlr	wzr, [x8]
100000d7c: 34000135    	cbz	w21, 0x100000da0 <_timer_init+0x94>
100000d80: 940002a4    	bl	0x100001810 <_thread_policy_set+0x100001810>
100000d84: 940002a0    	bl	0x100001804 <_thread_policy_set+0x100001804>
100000d88: 52800028    	mov	w8, #0x1                ; =1
100000d8c: b90003e8    	str	w8, [sp]
100000d90: 910003e2    	mov	x2, sp
100000d94: 52800081    	mov	w1, #0x4                ; =4
100000d98: 52800023    	mov	w3, #0x1                ; =1
100000d9c: 940002ac    	bl	0x10000184c <_thread_policy_set+0x10000184c>
100000da0: 340000d4    	cbz	w20, 0x100000db8 <_timer_init+0xac>
100000da4: 90000040    	adrp	x0, 0x100008000 <_secret_default>
100000da8: 9109e000    	add	x0, x0, #0x278
100000dac: 90000002    	adrp	x2, 0x100000000 <_thread_policy_set+0x100000000>
100000db0: 913d9042    	add	x2, x2, #0xf64
100000db4: 14000005    	b	0x100000dc8 <_timer_init+0xbc>
100000db8: 90000040    	adrp	x0, 0x100008000 <_secret_default>
100000dbc: 910a2000    	add	x0, x0, #0x288
100000dc0: 90000002    	adrp	x2, 0x100000000 <_thread_policy_set+0x100000000>
100000dc4: 913e4042    	add	x2, x2, #0xf90
100000dc8: d2800001    	mov	x1, #0x0                ; =0
100000dcc: d2800003    	mov	x3, #0x0                ; =0
100000dd0: 94000287    	bl	0x1000017ec <_thread_policy_set+0x1000017ec>
100000dd4: 35000be0    	cbnz	w0, 0x100000f50 <_timer_init+0x244>
100000dd8: 340001f5    	cbz	w21, 0x100000e14 <_timer_init+0x108>
100000ddc: 34000094    	cbz	w20, 0x100000dec <_timer_init+0xe0>
100000de0: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000de4: 9109e108    	add	x8, x8, #0x278
100000de8: 14000003    	b	0x100000df4 <_timer_init+0xe8>
100000dec: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000df0: 910a2108    	add	x8, x8, #0x288
100000df4: f9400100    	ldr	x0, [x8]
100000df8: 94000283    	bl	0x100001804 <_thread_policy_set+0x100001804>
100000dfc: 52800028    	mov	w8, #0x1                ; =1
100000e00: b90003e8    	str	w8, [sp]
100000e04: 910003e2    	mov	x2, sp
100000e08: 52800081    	mov	w1, #0x4                ; =4
100000e0c: 52800023    	mov	w3, #0x1                ; =1
100000e10: 9400028f    	bl	0x10000184c <_thread_policy_set+0x10000184c>
100000e14: b0000008    	adrp	x8, 0x100001000 <_timer_shutdown+0x3c>
100000e18: 9132c108    	add	x8, x8, #0xcb0
100000e1c: 3dc00100    	ldr	q0, [x8]
100000e20: 3d8003e0    	str	q0, [sp]
100000e24: 910003e0    	mov	x0, sp
100000e28: d2800001    	mov	x1, #0x0                ; =0
100000e2c: 94000264    	bl	0x1000017bc <_thread_policy_set+0x1000017bc>
100000e30: d2d9aca8    	mov	x8, #0xcd6500000000     ; =225833675390976
100000e34: f2e839a8    	movk	x8, #0x41cd, lsl #48
100000e38: 9e670100    	fmov	d0, x8
100000e3c: 1e600909    	fmul	d9, d8, d0
100000e40: f94112f5    	ldr	x21, [x23, #0x220]
100000e44: 9400024c    	bl	0x100001774 <_thread_policy_set+0x100001774>
100000e48: aa0003f4    	mov	x20, x0
100000e4c: 1e602108    	fcmp	d8, #0.0
100000e50: d2dc3468    	mov	x8, #0xe1a300000000     ; =248090195918848
100000e54: f2e83628    	movk	x8, #0x41b1, lsl #48
100000e58: 9e670100    	fmov	d0, x8
100000e5c: 1e60cd20    	fcsel	d0, d9, d0, gt
100000e60: 9e790018    	fcvtzu	x24, d0
100000e64: 29402269    	ldp	w9, w8, [x19]
100000e68: 9b187d08    	mul	x8, x8, x24
100000e6c: 9ac90919    	udiv	x25, x8, x9
100000e70: 94000241    	bl	0x100001774 <_thread_policy_set+0x100001774>
100000e74: cb140008    	sub	x8, x0, x20
100000e78: eb19011f    	cmp	x8, x25
100000e7c: 54ffffa3    	b.lo	0x100000e70 <_timer_init+0x164>
100000e80: f94112f7    	ldr	x23, [x23, #0x220]
100000e84: 9400023c    	bl	0x100001774 <_thread_policy_set+0x100001774>
100000e88: cb140008    	sub	x8, x0, x20
100000e8c: 29402a69    	ldp	w9, w10, [x19]
100000e90: 9b097d08    	mul	x8, x8, x9
100000e94: 9aca0908    	udiv	x8, x8, x10
100000e98: f100051f    	cmp	x8, #0x1
100000e9c: 9a9f8508    	csinc	x8, x8, xzr, hi
100000ea0: cb1502e9    	sub	x9, x23, x21
100000ea4: 9e630120    	ucvtf	d0, x9
100000ea8: 9e630101    	ucvtf	d1, x8
100000eac: 1e611800    	fdiv	d0, d0, d1
100000eb0: 90000055    	adrp	x21, 0x100008000 <_secret_default>
100000eb4: fd011aa0    	str	d0, [x21, #0x230]
100000eb8: c8dffed7    	ldar	x23, [x22]
100000ebc: 9400022e    	bl	0x100001774 <_thread_policy_set+0x100001774>
100000ec0: aa0003f4    	mov	x20, x0
100000ec4: 29402269    	ldp	w9, w8, [x19]
100000ec8: 9b187d08    	mul	x8, x8, x24
100000ecc: 9ac90918    	udiv	x24, x8, x9
100000ed0: 94000229    	bl	0x100001774 <_thread_policy_set+0x100001774>
100000ed4: cb140008    	sub	x8, x0, x20
100000ed8: eb18011f    	cmp	x8, x24
100000edc: 54ffffa3    	b.lo	0x100000ed0 <_timer_init+0x1c4>
100000ee0: c8dffed6    	ldar	x22, [x22]
100000ee4: 94000224    	bl	0x100001774 <_thread_policy_set+0x100001774>
100000ee8: cb140008    	sub	x8, x0, x20
100000eec: 29402a69    	ldp	w9, w10, [x19]
100000ef0: 9b097d08    	mul	x8, x8, x9
100000ef4: 9aca0908    	udiv	x8, x8, x10
100000ef8: f100051f    	cmp	x8, #0x1
100000efc: 9a9f8508    	csinc	x8, x8, xzr, hi
100000f00: cb1702c9    	sub	x9, x22, x23
100000f04: 9e630120    	ucvtf	d0, x9
100000f08: 9e630101    	ucvtf	d1, x8
100000f0c: 1e611800    	fdiv	d0, d0, d1
100000f10: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000f14: fd012500    	str	d0, [x8, #0x248]
100000f18: fd411aa0    	ldr	d0, [x21, #0x230]
100000f1c: 1e602008    	fcmp	d0, #0.0
100000f20: 54000068    	b.hi	0x100000f2c <_timer_init+0x220>
100000f24: d2e7fe08    	mov	x8, #0x3ff0000000000000 ; =4607182418800017408
100000f28: f9011aa8    	str	x8, [x21, #0x230]
100000f2c: 52800000    	mov	w0, #0x0                ; =0
100000f30: a9467bfd    	ldp	x29, x30, [sp, #0x60]
100000f34: a9454ff4    	ldp	x20, x19, [sp, #0x50]
100000f38: a94457f6    	ldp	x22, x21, [sp, #0x40]
100000f3c: a9435ff8    	ldp	x24, x23, [sp, #0x30]
100000f40: a94267fa    	ldp	x26, x25, [sp, #0x20]
100000f44: 6d4123e9    	ldp	d9, d8, [sp, #0x10]
100000f48: 9101c3ff    	add	sp, sp, #0x70
100000f4c: d65f03c0    	ret
100000f50: b0000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100000f54: 912a1400    	add	x0, x0, #0xa85
100000f58: 9400021c    	bl	0x1000017c8 <_thread_policy_set+0x1000017c8>
100000f5c: 12800000    	mov	w0, #-0x1               ; =-1
100000f60: 17fffff4    	b	0x100000f30 <_timer_init+0x224>

0000000100000f64 <_timer_thread_fn_atomic>:
100000f64: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000f68: b9422909    	ldr	w9, [x8, #0x228]
100000f6c: 350000e9    	cbnz	w9, 0x100000f88 <_timer_thread_fn_atomic+0x24>
100000f70: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000f74: 91088129    	add	x9, x9, #0x220
100000f78: 5280002a    	mov	w10, #0x1               ; =1
100000f7c: f82a012b    	ldadd	x10, x11, [x9]
100000f80: b942290b    	ldr	w11, [x8, #0x228]
100000f84: 34ffffcb    	cbz	w11, 0x100000f7c <_timer_thread_fn_atomic+0x18>
100000f88: d2800000    	mov	x0, #0x0                ; =0
100000f8c: d65f03c0    	ret

0000000100000f90 <_timer_thread_fn>:
100000f90: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000f94: f9011d1f    	str	xzr, [x8, #0x238]
100000f98: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000f9c: b902413f    	str	wzr, [x9, #0x240]
100000fa0: b942412a    	ldr	w10, [x9, #0x240]
100000fa4: 350000ca    	cbnz	w10, 0x100000fbc <_timer_thread_fn+0x2c>
100000fa8: 5280002a    	mov	w10, #0x1               ; =1
100000fac: f9011d0a    	str	x10, [x8, #0x238]
100000fb0: b942412b    	ldr	w11, [x9, #0x240]
100000fb4: 9100054a    	add	x10, x10, #0x1
100000fb8: 34ffffab    	cbz	w11, 0x100000fac <_timer_thread_fn+0x1c>
100000fbc: d2800000    	mov	x0, #0x0                ; =0
100000fc0: d65f03c0    	ret

0000000100000fc4 <_timer_shutdown>:
100000fc4: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000fc8: 91090108    	add	x8, x8, #0x240
100000fcc: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000fd0: 9108a129    	add	x9, x9, #0x228
100000fd4: 7100001f    	cmp	w0, #0x0
100000fd8: 9a881128    	csel	x8, x9, x8, ne
100000fdc: 52800029    	mov	w9, #0x1                ; =1
100000fe0: b9000109    	str	w9, [x8]
100000fe4: 90000048    	adrp	x8, 0x100008000 <_secret_default>
100000fe8: 9109e108    	add	x8, x8, #0x278
100000fec: 90000049    	adrp	x9, 0x100008000 <_secret_default>
100000ff0: 910a2129    	add	x9, x9, #0x288
100000ff4: 9a891108    	csel	x8, x8, x9, ne
100000ff8: f9400100    	ldr	x0, [x8]
100000ffc: d2800001    	mov	x1, #0x0                ; =0
100001000: 140001fe    	b	0x1000017f8 <_thread_policy_set+0x1000017f8>

0000000100001004 <_touch>:
100001004: 3940001f    	ldrb	wzr, [x0]
100001008: d65f03c0    	ret

000000010000100c <_evict_by_sweep>:
10000100c: b40000c1    	cbz	x1, 0x100001024 <_evict_by_sweep+0x18>
100001010: d2800008    	mov	x8, #0x0                ; =0
100001014: 3868681f    	ldrb	wzr, [x0, x8]
100001018: 91020108    	add	x8, x8, #0x80
10000101c: eb01011f    	cmp	x8, x1
100001020: 54ffffa3    	b.lo	0x100001014 <_evict_by_sweep+0x8>
100001024: d65f03c0    	ret

0000000100001028 <_calibrate_latency>:
100001028: d10143ff    	sub	sp, sp, #0x50
10000102c: a90257f6    	stp	x22, x21, [sp, #0x20]
100001030: a9034ff4    	stp	x20, x19, [sp, #0x30]
100001034: a9047bfd    	stp	x29, x30, [sp, #0x40]
100001038: 910103fd    	add	x29, sp, #0x40
10000103c: aa0003f5    	mov	x21, x0
100001040: 52801000    	mov	w0, #0x80               ; =128
100001044: 72a10000    	movk	w0, #0x800, lsl #16
100001048: 940001d1    	bl	0x10000178c <_thread_policy_set+0x10000178c>
10000104c: b4000b00    	cbz	x0, 0x1000011ac <_calibrate_latency+0x184>
100001050: aa0003f3    	mov	x19, x0
100001054: 9287ffe8    	mov	x8, #-0x4000            ; =-16384
100001058: 52800029    	mov	w9, #0x1                ; =1
10000105c: 321233ea    	mov	w10, #0x7ffc000         ; =134201344
100001060: 91401108    	add	x8, x8, #0x4, lsl #12   ; =0x4000
100001064: 38336909    	strb	w9, [x8, x19]
100001068: eb0a011f    	cmp	x8, x10
10000106c: 54ffffa3    	b.lo	0x100001060 <_calibrate_latency+0x38>
100001070: 52800100    	mov	w0, #0x8                ; =8
100001074: 940001c6    	bl	0x10000178c <_thread_policy_set+0x10000178c>
100001078: b4000980    	cbz	x0, 0x1000011a8 <_calibrate_latency+0x180>
10000107c: aa0003f4    	mov	x20, x0
100001080: d2800008    	mov	x8, #0x0                ; =0
100001084: 39400009    	ldrb	w9, [x0]
100001088: f000002b    	adrp	x11, 0x100008000 <_secret_default>
10000108c: 9108e16b    	add	x11, x11, #0x238
100001090: 390077e9    	strb	w9, [sp, #0x1d]
100001094: f000002c    	adrp	x12, 0x100008000 <_secret_default>
100001098: 9108818c    	add	x12, x12, #0x220
10000109c: 710002bf    	cmp	w21, #0x0
1000010a0: 9a8b1189    	csel	x9, x12, x11, ne
1000010a4: 52807d0a    	mov	w10, #0x3e8             ; =1000
1000010a8: d5033fdf    	isb
1000010ac: f940012d    	ldr	x13, [x9]
1000010b0: d5033fdf    	isb
1000010b4: 3940028e    	ldrb	w14, [x20]
1000010b8: 39007bee    	strb	w14, [sp, #0x1e]
1000010bc: 39407bee    	ldrb	w14, [sp, #0x1e]
1000010c0: d5033fdf    	isb
1000010c4: f940012e    	ldr	x14, [x9]
1000010c8: d5033fdf    	isb
1000010cc: 4b0d01cd    	sub	w13, w14, w13
1000010d0: 8b0801a8    	add	x8, x13, x8
1000010d4: 7100054a    	subs	w10, w10, #0x1
1000010d8: 54fffe81    	b.ne	0x1000010a8 <_calibrate_latency+0x80>
1000010dc: d2800009    	mov	x9, #0x0                ; =0
1000010e0: 710002bf    	cmp	w21, #0x0
1000010e4: 9a8b118b    	csel	x11, x12, x11, ne
1000010e8: 32194fec    	mov	w12, #0x7ffff80         ; =134217600
1000010ec: d280000d    	mov	x13, #0x0               ; =0
1000010f0: 386d6a7f    	ldrb	wzr, [x19, x13]
1000010f4: 910201ae    	add	x14, x13, #0x80
1000010f8: eb0c01bf    	cmp	x13, x12
1000010fc: aa0e03ed    	mov	x13, x14
100001100: 54ffff83    	b.lo	0x1000010f0 <_calibrate_latency+0xc8>
100001104: d5033fdf    	isb
100001108: f940016d    	ldr	x13, [x11]
10000110c: d5033fdf    	isb
100001110: 3940028e    	ldrb	w14, [x20]
100001114: 39007fee    	strb	w14, [sp, #0x1f]
100001118: 39407fee    	ldrb	w14, [sp, #0x1f]
10000111c: d5033fdf    	isb
100001120: f940016e    	ldr	x14, [x11]
100001124: d5033fdf    	isb
100001128: 4b0d01cd    	sub	w13, w14, w13
10000112c: 8b0901a9    	add	x9, x13, x9
100001130: 1100054a    	add	w10, w10, #0x1
100001134: 710fa15f    	cmp	w10, #0x3e8
100001138: 54fffda1    	b.ne	0x1000010ec <_calibrate_latency+0xc4>
10000113c: d343fd08    	lsr	x8, x8, #3
100001140: d29ef9ea    	mov	x10, #0xf7cf            ; =63439
100001144: f2bc6a6a    	movk	x10, #0xe353, lsl #16
100001148: f2d374aa    	movk	x10, #0x9ba5, lsl #32
10000114c: f2e4188a    	movk	x10, #0x20c4, lsl #48
100001150: 9bca7d08    	umulh	x8, x8, x10
100001154: d344fd08    	lsr	x8, x8, #4
100001158: d343fd29    	lsr	x9, x9, #3
10000115c: 9bca7d29    	umulh	x9, x9, x10
100001160: d344fd29    	lsr	x9, x9, #4
100001164: 8b09050a    	add	x10, x8, x9, lsl #1
100001168: d342fd55    	lsr	x21, x10, #2
10000116c: a90027e8    	stp	x8, x9, [sp]
100001170: f9000bf5    	str	x21, [sp, #0x10]
100001174: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100001178: 912b1000    	add	x0, x0, #0xac4
10000117c: 94000199    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
100001180: aa1403e0    	mov	x0, x20
100001184: 94000176    	bl	0x10000175c <_thread_policy_set+0x10000175c>
100001188: aa1303e0    	mov	x0, x19
10000118c: 94000174    	bl	0x10000175c <_thread_policy_set+0x10000175c>
100001190: aa1503e0    	mov	x0, x21
100001194: a9447bfd    	ldp	x29, x30, [sp, #0x40]
100001198: a9434ff4    	ldp	x20, x19, [sp, #0x30]
10000119c: a94257f6    	ldp	x22, x21, [sp, #0x20]
1000011a0: 910143ff    	add	sp, sp, #0x50
1000011a4: d65f03c0    	ret
1000011a8: 94000139    	bl	0x10000168c <_calibrate_latency.cold.1>
1000011ac: 94000142    	bl	0x1000016b4 <_calibrate_latency.cold.2>

00000001000011b0 <_shuffle_ptrs>:
1000011b0: f100043f    	cmp	x1, #0x1
1000011b4: 540003a0    	b.eq	0x100001228 <_shuffle_ptrs+0x78>
1000011b8: a9bc5ff8    	stp	x24, x23, [sp, #-0x40]!
1000011bc: a90157f6    	stp	x22, x21, [sp, #0x10]
1000011c0: a9024ff4    	stp	x20, x19, [sp, #0x20]
1000011c4: a9037bfd    	stp	x29, x30, [sp, #0x30]
1000011c8: 9100c3fd    	add	x29, sp, #0x30
1000011cc: aa0103f3    	mov	x19, x1
1000011d0: aa0003f4    	mov	x20, x0
1000011d4: d2800015    	mov	x21, #0x0               ; =0
1000011d8: 12b00016    	mov	w22, #0x7fffffff        ; =2147483647
1000011dc: aa0003f7    	mov	x23, x0
1000011e0: 94000192    	bl	0x100001828 <_thread_policy_set+0x100001828>
1000011e4: 93407c08    	sxtw	x8, w0
1000011e8: 9ad30ac9    	udiv	x9, x22, x19
1000011ec: 91000529    	add	x9, x9, #0x1
1000011f0: 9ac90908    	udiv	x8, x8, x9
1000011f4: 8b150e89    	add	x9, x20, x21, lsl #3
1000011f8: f868792a    	ldr	x10, [x9, x8, lsl #3]
1000011fc: f94002eb    	ldr	x11, [x23]
100001200: f828792b    	str	x11, [x9, x8, lsl #3]
100001204: f80086ea    	str	x10, [x23], #0x8
100001208: 910006b5    	add	x21, x21, #0x1
10000120c: d1000673    	sub	x19, x19, #0x1
100001210: f100067f    	cmp	x19, #0x1
100001214: 54fffe61    	b.ne	0x1000011e0 <_shuffle_ptrs+0x30>
100001218: a9437bfd    	ldp	x29, x30, [sp, #0x30]
10000121c: a9424ff4    	ldp	x20, x19, [sp, #0x20]
100001220: a94157f6    	ldp	x22, x21, [sp, #0x10]
100001224: a8c45ff8    	ldp	x24, x23, [sp], #0x40
100001228: d65f03c0    	ret

000000010000122c <_flush_whole_cache>:
10000122c: d100c3ff    	sub	sp, sp, #0x30
100001230: a9014ff4    	stp	x20, x19, [sp, #0x10]
100001234: a9027bfd    	stp	x29, x30, [sp, #0x20]
100001238: 910083fd    	add	x29, sp, #0x20
10000123c: f0000034    	adrp	x20, 0x100008000 <_secret_default>
100001240: f9412a88    	ldr	x8, [x20, #0x250]
100001244: b50001a8    	cbnz	x8, 0x100001278 <_flush_whole_cache+0x4c>
100001248: f0000033    	adrp	x19, 0x100008000 <_secret_default>
10000124c: 91094273    	add	x19, x19, #0x250
100001250: aa1303e0    	mov	x0, x19
100001254: 52800801    	mov	w1, #0x40               ; =64
100001258: 52a10002    	mov	w2, #0x8000000          ; =134217728
10000125c: 9400015e    	bl	0x1000017d4 <_thread_policy_set+0x1000017d4>
100001260: 350002e0    	cbnz	w0, 0x1000012bc <_flush_whole_cache+0x90>
100001264: f9400260    	ldr	x0, [x19]
100001268: b40002a0    	cbz	x0, 0x1000012bc <_flush_whole_cache+0x90>
10000126c: 528014a1    	mov	w1, #0xa5               ; =165
100001270: 52a10002    	mov	w2, #0x8000000          ; =134217728
100001274: 94000149    	bl	0x100001798 <_thread_policy_set+0x100001798>
100001278: d2800008    	mov	x8, #0x0                ; =0
10000127c: b9000fff    	str	wzr, [sp, #0xc]
100001280: f9412a89    	ldr	x9, [x20, #0x250]
100001284: 32194fea    	mov	w10, #0x7ffff80         ; =134217600
100001288: 3868692b    	ldrb	w11, [x9, x8]
10000128c: b9400fec    	ldr	w12, [sp, #0xc]
100001290: 0b0b018b    	add	w11, w12, w11
100001294: b9000feb    	str	w11, [sp, #0xc]
100001298: 9102010b    	add	x11, x8, #0x80
10000129c: eb0a011f    	cmp	x8, x10
1000012a0: aa0b03e8    	mov	x8, x11
1000012a4: 54ffff23    	b.lo	0x100001288 <_flush_whole_cache+0x5c>
1000012a8: b9400fe8    	ldr	w8, [sp, #0xc]
1000012ac: a9427bfd    	ldp	x29, x30, [sp, #0x20]
1000012b0: a9414ff4    	ldp	x20, x19, [sp, #0x10]
1000012b4: 9100c3ff    	add	sp, sp, #0x30
1000012b8: d65f03c0    	ret
1000012bc: 94000105    	bl	0x1000016d0 <_flush_whole_cache.cold.1>

00000001000012c0 <_fuzzy_evict>:
1000012c0: a9bd57f6    	stp	x22, x21, [sp, #-0x30]!
1000012c4: a9014ff4    	stp	x20, x19, [sp, #0x10]
1000012c8: a9027bfd    	stp	x29, x30, [sp, #0x20]
1000012cc: 910083fd    	add	x29, sp, #0x20
1000012d0: d2800013    	mov	x19, #0x0               ; =0
1000012d4: f0000034    	adrp	x20, 0x100008000 <_secret_default>
1000012d8: 910a4294    	add	x20, x20, #0x290
1000012dc: 52943015    	mov	w21, #0xa180            ; =41344
1000012e0: 72a005d5    	movk	w21, #0x2e, lsl #16
1000012e4: f9400288    	ldr	x8, [x20]
1000012e8: f8736900    	ldr	x0, [x8, x19]
1000012ec: 97ffff46    	bl	0x100001004 <_touch>
1000012f0: 91002273    	add	x19, x19, #0x8
1000012f4: eb15027f    	cmp	x19, x21
1000012f8: 54ffff61    	b.ne	0x1000012e4 <_fuzzy_evict+0x24>
1000012fc: a9427bfd    	ldp	x29, x30, [sp, #0x20]
100001300: a9414ff4    	ldp	x20, x19, [sp, #0x10]
100001304: a8c357f6    	ldp	x22, x21, [sp], #0x30
100001308: d65f03c0    	ret

000000010000130c <_find_fuzzy_eviction_set>:
10000130c: a9bc5ff8    	stp	x24, x23, [sp, #-0x40]!
100001310: a90157f6    	stp	x22, x21, [sp, #0x10]
100001314: a9024ff4    	stp	x20, x19, [sp, #0x20]
100001318: a9037bfd    	stp	x29, x30, [sp, #0x30]
10000131c: 9100c3fd    	add	x29, sp, #0x30
100001320: f0000033    	adrp	x19, 0x100008000 <_secret_default>
100001324: 910a8273    	add	x19, x19, #0x2a0
100001328: 52a10008    	mov	w8, #0x8000000          ; =134217728
10000132c: f9000268    	str	x8, [x19]
100001330: 52a10000    	mov	w0, #0x8000000          ; =134217728
100001334: 94000116    	bl	0x10000178c <_thread_policy_set+0x10000178c>
100001338: f0000035    	adrp	x21, 0x100008000 <_secret_default>
10000133c: 910a62b5    	add	x21, x21, #0x298
100001340: f90002a0    	str	x0, [x21]
100001344: b4000700    	cbz	x0, 0x100001424 <_find_fuzzy_eviction_set+0x118>
100001348: f9400276    	ldr	x22, [x19]
10000134c: b4000136    	cbz	x22, 0x100001370 <_find_fuzzy_eviction_set+0x64>
100001350: d2800008    	mov	x8, #0x0                ; =0
100001354: 52800029    	mov	w9, #0x1                ; =1
100001358: f94002aa    	ldr	x10, [x21]
10000135c: 38286949    	strb	w9, [x10, x8]
100001360: 91400508    	add	x8, x8, #0x1, lsl #12   ; =0x1000
100001364: f9400276    	ldr	x22, [x19]
100001368: eb16011f    	cmp	x8, x22
10000136c: 54ffff63    	b.lo	0x100001358 <_find_fuzzy_eviction_set+0x4c>
100001370: d347fed4    	lsr	x20, x22, #7
100001374: d37df293    	lsl	x19, x20, #3
100001378: aa1303e0    	mov	x0, x19
10000137c: 94000104    	bl	0x10000178c <_thread_policy_set+0x10000178c>
100001380: f0000028    	adrp	x8, 0x100008000 <_secret_default>
100001384: 910a4108    	add	x8, x8, #0x290
100001388: f9000100    	str	x0, [x8]
10000138c: b40004c0    	cbz	x0, 0x100001424 <_find_fuzzy_eviction_set+0x118>
100001390: f10202df    	cmp	x22, #0x80
100001394: 54000163    	b.lo	0x1000013c0 <_find_fuzzy_eviction_set+0xb4>
100001398: d2800009    	mov	x9, #0x0                ; =0
10000139c: d280000a    	mov	x10, #0x0               ; =0
1000013a0: f94002ab    	ldr	x11, [x21]
1000013a4: 8b09016b    	add	x11, x11, x9
1000013a8: f940010c    	ldr	x12, [x8]
1000013ac: f82a698b    	str	x11, [x12, x10]
1000013b0: 9100214a    	add	x10, x10, #0x8
1000013b4: 91020129    	add	x9, x9, #0x80
1000013b8: eb0a027f    	cmp	x19, x10
1000013bc: 54ffff21    	b.ne	0x1000013a0 <_find_fuzzy_eviction_set+0x94>
1000013c0: f100069f    	cmp	x20, #0x1
1000013c4: 54000260    	b.eq	0x100001410 <_find_fuzzy_eviction_set+0x104>
1000013c8: d2800013    	mov	x19, #0x0               ; =0
1000013cc: f9400115    	ldr	x21, [x8]
1000013d0: 12b00016    	mov	w22, #0x7fffffff        ; =2147483647
1000013d4: aa1503f7    	mov	x23, x21
1000013d8: 94000114    	bl	0x100001828 <_thread_policy_set+0x100001828>
1000013dc: 93407c08    	sxtw	x8, w0
1000013e0: 9ad40ac9    	udiv	x9, x22, x20
1000013e4: 91000529    	add	x9, x9, #0x1
1000013e8: 9ac90908    	udiv	x8, x8, x9
1000013ec: 8b130ea9    	add	x9, x21, x19, lsl #3
1000013f0: f868792a    	ldr	x10, [x9, x8, lsl #3]
1000013f4: f94002eb    	ldr	x11, [x23]
1000013f8: f828792b    	str	x11, [x9, x8, lsl #3]
1000013fc: f80086ea    	str	x10, [x23], #0x8
100001400: 91000673    	add	x19, x19, #0x1
100001404: d1000694    	sub	x20, x20, #0x1
100001408: f100069f    	cmp	x20, #0x1
10000140c: 54fffe61    	b.ne	0x1000013d8 <_find_fuzzy_eviction_set+0xcc>
100001410: a9437bfd    	ldp	x29, x30, [sp, #0x30]
100001414: a9424ff4    	ldp	x20, x19, [sp, #0x20]
100001418: a94157f6    	ldp	x22, x21, [sp, #0x10]
10000141c: a8c45ff8    	ldp	x24, x23, [sp], #0x40
100001420: d65f03c0    	ret
100001424: 52800020    	mov	w0, #0x1                ; =1
100001428: 940000c7    	bl	0x100001744 <_thread_policy_set+0x100001744>

000000010000142c <_init_secret_on_page>:
10000142c: d10183ff    	sub	sp, sp, #0x60
100001430: a9025ff8    	stp	x24, x23, [sp, #0x20]
100001434: a90357f6    	stp	x22, x21, [sp, #0x30]
100001438: a9044ff4    	stp	x20, x19, [sp, #0x40]
10000143c: a9057bfd    	stp	x29, x30, [sp, #0x50]
100001440: 910143fd    	add	x29, sp, #0x50
100001444: aa0103f3    	mov	x19, x1
100001448: aa0003f4    	mov	x20, x0
10000144c: f0000037    	adrp	x23, 0x100008000 <_secret_default>
100001450: f94156e0    	ldr	x0, [x23, #0x2a8]
100001454: f0000035    	adrp	x21, 0x100008000 <_secret_default>
100001458: f0000036    	adrp	x22, 0x100008000 <_secret_default>
10000145c: b40000a0    	cbz	x0, 0x100001470 <_init_secret_on_page+0x44>
100001460: 940000bf    	bl	0x10000175c <_thread_policy_set+0x10000175c>
100001464: f90156ff    	str	xzr, [x23, #0x2a8]
100001468: f90132bf    	str	xzr, [x21, #0x260]
10000146c: f9012edf    	str	xzr, [x22, #0x258]
100001470: 52821000    	mov	w0, #0x1080             ; =4224
100001474: 940000c6    	bl	0x10000178c <_thread_policy_set+0x10000178c>
100001478: f90156e0    	str	x0, [x23, #0x2a8]
10000147c: b4000a40    	cbz	x0, 0x1000015c4 <_init_secret_on_page+0x198>
100001480: 9101fc08    	add	x8, x0, #0x7f
100001484: 9279e108    	and	x8, x8, #0xffffffffffffff80
100001488: 91400509    	add	x9, x8, #0x1, lsl #12   ; =0x1000
10000148c: 5282100a    	mov	w10, #0x1080            ; =4224
100001490: 8b0a000a    	add	x10, x0, x10
100001494: eb0a013f    	cmp	x9, x10
100001498: 9a888009    	csel	x9, x0, x8, hi
10000149c: f90132a9    	str	x9, [x21, #0x260]
1000014a0: f0000028    	adrp	x8, 0x100008000 <_secret_default>
1000014a4: f9410d0a    	ldr	x10, [x8, #0x218]
1000014a8: 5281ffeb    	mov	w11, #0xfff             ; =4095
1000014ac: cb0a016c    	sub	x12, x11, x10
1000014b0: 36000353    	tbz	w19, #0x0, 0x100001518 <_init_secret_on_page+0xec>
1000014b4: 9100068b    	add	x11, x20, #0x1
1000014b8: f100817f    	cmp	x11, #0x20
1000014bc: 54000862    	b.hs	0x1000015c8 <_init_secret_on_page+0x19c>
1000014c0: d379e16d    	lsl	x13, x11, #7
1000014c4: cb4a05ab    	sub	x11, x13, x10, lsr #1
1000014c8: d379e28e    	lsl	x14, x20, #7
1000014cc: eb0e017f    	cmp	x11, x14
1000014d0: 9a8e816b    	csel	x11, x11, x14, hi
1000014d4: eb0c017f    	cmp	x11, x12
1000014d8: 54000988    	b.hi	0x100001608 <_init_secret_on_page+0x1dc>
1000014dc: eb0d017f    	cmp	x11, x13
1000014e0: 54000082    	b.hs	0x1000014f0 <_init_secret_on_page+0xc4>
1000014e4: 8b0a016a    	add	x10, x11, x10
1000014e8: eb0d015f    	cmp	x10, x13
1000014ec: 54000208    	b.hi	0x10000152c <_init_secret_on_page+0x100>
1000014f0: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
1000014f4: f9401508    	ldr	x8, [x8, #0x28]
1000014f8: f9400103    	ldr	x3, [x8]
1000014fc: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100001500: 91303c00    	add	x0, x0, #0xc0f
100001504: 52800801    	mov	w1, #0x40               ; =64
100001508: 52800022    	mov	w2, #0x1                ; =1
10000150c: 94000097    	bl	0x100001768 <_thread_policy_set+0x100001768>
100001510: 52800020    	mov	w0, #0x1                ; =1
100001514: 9400008c    	bl	0x100001744 <_thread_policy_set+0x100001744>
100001518: f100829f    	cmp	x20, #0x20
10000151c: 54000662    	b.hs	0x1000015e8 <_init_secret_on_page+0x1bc>
100001520: d379e28b    	lsl	x11, x20, #7
100001524: eb0c017f    	cmp	x11, x12
100001528: 540007e8    	b.hi	0x100001624 <_init_secret_on_page+0x1f8>
10000152c: f000002a    	adrp	x10, 0x100008000 <_secret_default>
100001530: f9013554    	str	x20, [x10, #0x268]
100001534: 8b0b0129    	add	x9, x9, x11
100001538: f9012ec9    	str	x9, [x22, #0x258]
10000153c: f9410d09    	ldr	x9, [x8, #0x218]
100001540: b100053f    	cmn	x9, #0x1
100001544: 54000180    	b.eq	0x100001574 <_init_secret_on_page+0x148>
100001548: d2800009    	mov	x9, #0x0                ; =0
10000154c: 9000000b    	adrp	x11, 0x100001000 <_timer_shutdown+0x3c>
100001550: 9133016b    	add	x11, x11, #0xcc0
100001554: 3869696c    	ldrb	w12, [x11, x9]
100001558: f9412ecd    	ldr	x13, [x22, #0x258]
10000155c: 382969ac    	strb	w12, [x13, x9]
100001560: 91000529    	add	x9, x9, #0x1
100001564: f9410d0c    	ldr	x12, [x8, #0x218]
100001568: 9100058c    	add	x12, x12, #0x1
10000156c: eb0c013f    	cmp	x9, x12
100001570: 54ffff23    	b.lo	0x100001554 <_init_secret_on_page+0x128>
100001574: f94132a8    	ldr	x8, [x21, #0x260]
100001578: f9412ec9    	ldr	x9, [x22, #0x258]
10000157c: f941354a    	ldr	x10, [x10, #0x268]
100001580: 9000000b    	adrp	x11, 0x100001000 <_timer_shutdown+0x3c>
100001584: 91325d6b    	add	x11, x11, #0xc97
100001588: 9000000c    	adrp	x12, 0x100001000 <_timer_shutdown+0x3c>
10000158c: 9132318c    	add	x12, x12, #0xc8c
100001590: 7100027f    	cmp	w19, #0x0
100001594: 9a8b118b    	csel	x11, x12, x11, ne
100001598: a9012fea    	stp	x10, x11, [sp, #0x10]
10000159c: a90027e8    	stp	x8, x9, [sp]
1000015a0: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
1000015a4: 91314000    	add	x0, x0, #0xc50
1000015a8: 9400008e    	bl	0x1000017e0 <_thread_policy_set+0x1000017e0>
1000015ac: a9457bfd    	ldp	x29, x30, [sp, #0x50]
1000015b0: a9444ff4    	ldp	x20, x19, [sp, #0x40]
1000015b4: a94357f6    	ldp	x22, x21, [sp, #0x30]
1000015b8: a9425ff8    	ldp	x24, x23, [sp, #0x20]
1000015bc: 910183ff    	add	sp, sp, #0x60
1000015c0: d65f03c0    	ret
1000015c4: 9400004a    	bl	0x1000016ec <_init_secret_on_page.cold.1>
1000015c8: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
1000015cc: f9401508    	ldr	x8, [x8, #0x28]
1000015d0: f9400100    	ldr	x0, [x8]
1000015d4: 52800408    	mov	w8, #0x20               ; =32
1000015d8: a90023f4    	stp	x20, x8, [sp]
1000015dc: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x3c>
1000015e0: 912e7021    	add	x1, x1, #0xb9c
1000015e4: 14000016    	b	0x10000163c <_init_secret_on_page+0x210>
1000015e8: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
1000015ec: f9401508    	ldr	x8, [x8, #0x28]
1000015f0: f9400100    	ldr	x0, [x8]
1000015f4: 528003e8    	mov	w8, #0x1f               ; =31
1000015f8: a90023f4    	stp	x20, x8, [sp]
1000015fc: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x3c>
100001600: 912cb021    	add	x1, x1, #0xb2c
100001604: 1400000e    	b	0x10000163c <_init_secret_on_page+0x210>
100001608: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
10000160c: f9401508    	ldr	x8, [x8, #0x28]
100001610: f9400100    	ldr	x0, [x8]
100001614: f90003f4    	str	x20, [sp]
100001618: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x3c>
10000161c: 912f4c21    	add	x1, x1, #0xbd3
100001620: 14000007    	b	0x10000163c <_init_secret_on_page+0x210>
100001624: f0000008    	adrp	x8, 0x100004000 <_thread_policy_set+0x100004000>
100001628: f9401508    	ldr	x8, [x8, #0x28]
10000162c: f9400100    	ldr	x0, [x8]
100001630: f90003f4    	str	x20, [sp]
100001634: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x3c>
100001638: 912d9021    	add	x1, x1, #0xb64
10000163c: 94000045    	bl	0x100001750 <_thread_policy_set+0x100001750>
100001640: 52800020    	mov	w0, #0x1                ; =1
100001644: 94000040    	bl	0x100001744 <_thread_policy_set+0x100001744>

0000000100001648 <_destroy_secret_page>:
100001648: a9be4ff4    	stp	x20, x19, [sp, #-0x20]!
10000164c: a9017bfd    	stp	x29, x30, [sp, #0x10]
100001650: 910043fd    	add	x29, sp, #0x10
100001654: f0000033    	adrp	x19, 0x100008000 <_secret_default>
100001658: f9415660    	ldr	x0, [x19, #0x2a8]
10000165c: b4000060    	cbz	x0, 0x100001668 <_destroy_secret_page+0x20>
100001660: 9400003f    	bl	0x10000175c <_thread_policy_set+0x10000175c>
100001664: f901567f    	str	xzr, [x19, #0x2a8]
100001668: f0000028    	adrp	x8, 0x100008000 <_secret_default>
10000166c: f901311f    	str	xzr, [x8, #0x260]
100001670: f0000028    	adrp	x8, 0x100008000 <_secret_default>
100001674: f9012d1f    	str	xzr, [x8, #0x258]
100001678: f0000028    	adrp	x8, 0x100008000 <_secret_default>
10000167c: f901351f    	str	xzr, [x8, #0x268]
100001680: a9417bfd    	ldp	x29, x30, [sp, #0x10]
100001684: a8c24ff4    	ldp	x20, x19, [sp], #0x20
100001688: d65f03c0    	ret

000000010000168c <_calibrate_latency.cold.1>:
10000168c: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
100001690: 910003fd    	mov	x29, sp
100001694: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
100001698: 912a9400    	add	x0, x0, #0xaa5
10000169c: 90000001    	adrp	x1, 0x100001000 <_timer_shutdown+0x3c>
1000016a0: 912adc21    	add	x1, x1, #0xab7
1000016a4: 90000003    	adrp	x3, 0x100001000 <_timer_shutdown+0x3c>
1000016a8: 912afc63    	add	x3, x3, #0xabf
1000016ac: 52801b02    	mov	w2, #0xd8               ; =216
1000016b0: 94000016    	bl	0x100001708 <_thread_policy_set+0x100001708>

00000001000016b4 <_calibrate_latency.cold.2>:
1000016b4: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
1000016b8: 910003fd    	mov	x29, sp
1000016bc: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
1000016c0: 912a5000    	add	x0, x0, #0xa94
1000016c4: 94000041    	bl	0x1000017c8 <_thread_policy_set+0x1000017c8>
1000016c8: 12800000    	mov	w0, #-0x1               ; =-1
1000016cc: 9400001e    	bl	0x100001744 <_thread_policy_set+0x100001744>

00000001000016d0 <_flush_whole_cache.cold.1>:
1000016d0: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
1000016d4: 910003fd    	mov	x29, sp
1000016d8: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
1000016dc: 912c1800    	add	x0, x0, #0xb06
1000016e0: 9400003a    	bl	0x1000017c8 <_thread_policy_set+0x1000017c8>
1000016e4: 52800020    	mov	w0, #0x1                ; =1
1000016e8: 94000017    	bl	0x100001744 <_thread_policy_set+0x100001744>

00000001000016ec <_init_secret_on_page.cold.1>:
1000016ec: a9bf7bfd    	stp	x29, x30, [sp, #-0x10]!
1000016f0: 910003fd    	mov	x29, sp
1000016f4: 90000000    	adrp	x0, 0x100001000 <_timer_shutdown+0x3c>
1000016f8: 912c6400    	add	x0, x0, #0xb19
1000016fc: 94000033    	bl	0x1000017c8 <_thread_policy_set+0x1000017c8>
100001700: 52800020    	mov	w0, #0x1                ; =1
100001704: 94000010    	bl	0x100001744 <_thread_policy_set+0x100001744>

Disassembly of section __TEXT,__stubs:

0000000100001708 <__stubs>:
100001708: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000170c: f9400610    	ldr	x16, [x16, #0x8]
100001710: d61f0200    	br	x16
100001714: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001718: f9400a10    	ldr	x16, [x16, #0x10]
10000171c: d61f0200    	br	x16
100001720: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001724: f9400e10    	ldr	x16, [x16, #0x18]
100001728: d61f0200    	br	x16
10000172c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001730: f9401a10    	ldr	x16, [x16, #0x30]
100001734: d61f0200    	br	x16
100001738: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000173c: f9401e10    	ldr	x16, [x16, #0x38]
100001740: d61f0200    	br	x16
100001744: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001748: f9402210    	ldr	x16, [x16, #0x40]
10000174c: d61f0200    	br	x16
100001750: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001754: f9402610    	ldr	x16, [x16, #0x48]
100001758: d61f0200    	br	x16
10000175c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001760: f9402a10    	ldr	x16, [x16, #0x50]
100001764: d61f0200    	br	x16
100001768: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000176c: f9402e10    	ldr	x16, [x16, #0x58]
100001770: d61f0200    	br	x16
100001774: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001778: f9403210    	ldr	x16, [x16, #0x60]
10000177c: d61f0200    	br	x16
100001780: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001784: f9403610    	ldr	x16, [x16, #0x68]
100001788: d61f0200    	br	x16
10000178c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001790: f9403a10    	ldr	x16, [x16, #0x70]
100001794: d61f0200    	br	x16
100001798: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000179c: f9403e10    	ldr	x16, [x16, #0x78]
1000017a0: d61f0200    	br	x16
1000017a4: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017a8: f9404210    	ldr	x16, [x16, #0x80]
1000017ac: d61f0200    	br	x16
1000017b0: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017b4: f9404610    	ldr	x16, [x16, #0x88]
1000017b8: d61f0200    	br	x16
1000017bc: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017c0: f9404a10    	ldr	x16, [x16, #0x90]
1000017c4: d61f0200    	br	x16
1000017c8: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017cc: f9404e10    	ldr	x16, [x16, #0x98]
1000017d0: d61f0200    	br	x16
1000017d4: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017d8: f9405210    	ldr	x16, [x16, #0xa0]
1000017dc: d61f0200    	br	x16
1000017e0: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017e4: f9405610    	ldr	x16, [x16, #0xa8]
1000017e8: d61f0200    	br	x16
1000017ec: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017f0: f9405a10    	ldr	x16, [x16, #0xb0]
1000017f4: d61f0200    	br	x16
1000017f8: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
1000017fc: f9405e10    	ldr	x16, [x16, #0xb8]
100001800: d61f0200    	br	x16
100001804: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001808: f9406210    	ldr	x16, [x16, #0xc0]
10000180c: d61f0200    	br	x16
100001810: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001814: f9406610    	ldr	x16, [x16, #0xc8]
100001818: d61f0200    	br	x16
10000181c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001820: f9406a10    	ldr	x16, [x16, #0xd0]
100001824: d61f0200    	br	x16
100001828: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
10000182c: f9406e10    	ldr	x16, [x16, #0xd8]
100001830: d61f0200    	br	x16
100001834: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001838: f9407210    	ldr	x16, [x16, #0xe0]
10000183c: d61f0200    	br	x16
100001840: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001844: f9407610    	ldr	x16, [x16, #0xe8]
100001848: d61f0200    	br	x16
10000184c: f0000010    	adrp	x16, 0x100004000 <_thread_policy_set+0x100004000>
100001850: f9407a10    	ldr	x16, [x16, #0xf0]
100001854: d61f0200    	br	x16

Disassembly of section __TEXT,__cstring:

0000000100001858 <__cstring>:
100001858: 20656854    	<unknown>
10000185c: 656b6163    	fnmls	z3.h, p0/m, z11.h, z11.h
100001860: 20736920    	<unknown>
100001864: 696c2061    	ldpsw	x1, x8, [x3, #-0xa0]
100001868: 42002165    	<unknown>
10000186c: 20747365    	<unknown>
100001870: 73657567    	<unknown>
100001874: 27203a73    	<unknown>
100001878: 20276325    	<unknown>
10000187c: 43534128    	<unknown>
100001880: 253d4949    	psel	p9, p2, p10.b[w13, 3]
100001884: 2c783423    	ldnp	s3, s13, [x1, #-0x40]
100001888: 69682320    	ldpsw	x0, x8, [x25, #-0xc0]
10000188c: 253d7374    	<unknown>
100001890: 756c6c33    	<unknown>
100001894: 32203b29    	orr	w9, w25, #0x7fff
100001898: 6220646e    	<unknown>
10000189c: 20747365    	<unknown>
1000018a0: 73657567    	<unknown>
1000018a4: 27203a73    	<unknown>
1000018a8: 20276325    	<unknown>
1000018ac: 43534128    	<unknown>
1000018b0: 253d4949    	psel	p9, p2, p10.b[w13, 3]
1000018b4: 2c783423    	ldnp	s3, s13, [x1, #-0x40]
1000018b8: 69682320    	ldpsw	x0, x8, [x25, #-0xc0]
1000018bc: 253d7374    	<unknown>
1000018c0: 756c6c33    	<unknown>
1000018c4: 6d000a29    	stp	d9, d2, [x17]
1000018c8: 0070616d    	<unknown>
1000018cc: 424d5953    	<unknown>
1000018d0: 435f4c4f    	<unknown>
1000018d4: 203a544e    	<unknown>
1000018d8: 000a6425    	<unknown>
1000018dc: 72636553    	<unknown>
1000018e0: 61207465    	<unknown>
1000018e4: 65726464    	fnmls	z4.h, p1/m, z3.h, z18.h
1000018e8: 203a7373    	<unknown>
1000018ec: 202c7025    	<unknown>
1000018f0: 61727241    	<unknown>
1000018f4: 64612079    	fmul	z25.h, z3.h, z1.h[4]
1000018f8: 73657264    	<unknown>
1000018fc: 25203a73    	<unknown>
100001900: 54000a70    	bc.eq	0x100001a4c <__cstring+0x1f4>
100001904: 6d206568    	stp	d8, d25, [x11, #-0x200]
100001908: 63696c61    	<unknown>
10000190c: 73756f69    	<unknown>
100001910: 646e6920    	<unknown>
100001914: 69207865    	stgp	x5, x30, [x3, #-0x400]
100001918: 70252073    	adr	x19, 0x10004bd27 <_secret_alloc_base+0x43a7f>
10000191c: 3d70252d    	ldr	b13, [x9, #0xc09]
100001920: 6c6c2325    	ldnp	d5, d8, [x25, #-0x140]
100001924: 52000a78    	eor	w24, w19, #0x7
100001928: 766f6365    	<unknown>
10000192c: 64657265    	<unknown>
100001930: 63657320    	<unknown>
100001934: 3a746572    	<unknown>
100001938: 73252220    	<unknown>
10000193c: 1b000a22    	madd	w2, w17, w0, w2
100001940: 6d33335b    	stp	d27, d12, [x26, #-0xd0]
100001944: 6e697355    	uabdl2.4s	v21, v26, v9
100001948: 20612067    	<unknown>
10000194c: 7669616e    	<unknown>
100001950: 70532065    	adr	x5, 0x1000a7d5f <_secret_alloc_base+0x9fab7>
100001954: 72746365    	<unknown>
100001958: 6f502065    	umlal2.4s	v5, v3, v0[1]
10000195c: 5b1b0a43    	<unknown>
100001960: 73006d30    	<unknown>
100001964: 65726365    	fnmls	z5.h, p0/m, z27.h, z18.h
100001968: 69625f74    	ldpsw	x20, x23, [x27, #-0xf0]
10000196c: 203d2067    	<unknown>
100001970: 202c7025    	<unknown>
100001974: 72636573    	<unknown>
100001978: 625f7465    	<unknown>
10000197c: 25206769    	<unknown>
100001980: 64252025    	fmul	z5.h, z1.h, z5.h[0]
100001984: 25203d20    	<unknown>
100001988: 000a757a    	<unknown>
10000198c: 6e697355    	uabdl2.4s	v21, v26, v9
100001990: 6d6d2067    	ldp	d7, d8, [x3, #-0x130]
100001994: 73207061    	<unknown>
100001998: 65726365    	fnmls	z5.h, p0/m, z27.h, z18.h
10000199c: 25203a74    	<unknown>
1000019a0: 55000a73    	<unknown>
1000019a4: 676e6973    	<unknown>
1000019a8: 67696220    	<unknown>
1000019ac: 63657320    	<unknown>
1000019b0: 20746572    	<unknown>
1000019b4: 72617473    	<unknown>
1000019b8: 676e6974    	<unknown>
1000019bc: 20746120    	<unknown>
1000019c0: 68636163    	<unknown>
1000019c4: 696c2d65    	ldpsw	x5, x11, [x11, #-0xa0]
1000019c8: 6320656e    	<unknown>
1000019cc: 73736f72    	<unknown>
1000019d0: 20676e69    	<unknown>
1000019d4: 66666f28    	<unknown>
1000019d8: 20746573    	<unknown>
1000019dc: 2d206425    	stp	s5, s25, [x1, #-0x100]
1000019e0: 616c203e    	<unknown>
1000019e4: 62207473    	<unknown>
1000019e8: 20657479    	<unknown>
1000019ec: 6c20666f    	stnp	d15, d25, [x19, #-0x200]
1000019f0: 20656e69    	<unknown>
1000019f4: 000a2930    	<unknown>
1000019f8: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
1000019fc: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a00: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a04: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a08: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a0c: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a10: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a14: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a18: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a1c: 2d2d2d2d    	stp	s13, s11, [x9, #-0x98]
100001a20: 7355002d    	<unknown>
100001a24: 20676e69    	<unknown>
100001a28: 75676572    	<unknown>
100001a2c: 2072616c    	<unknown>
100001a30: 6e756f63    	umin.8h	v3, v27, v21
100001a34: 00726574    	<unknown>
100001a38: 6e697355    	uabdl2.4s	v21, v26, v9
100001a3c: 74612067    	<unknown>
100001a40: 63696d6f    	<unknown>
100001a44: 756f6320    	<unknown>
100001a48: 7265746e    	<unknown>
100001a4c: 69735500    	ldpsw	x0, x21, [x8, #-0x68]
100001a50: 6220676e    	<unknown>
100001a54: 73206769    	<unknown>
100001a58: 65726365    	fnmls	z5.h, p0/m, z27.h, z18.h
100001a5c: 73550074    	<unknown>
100001a60: 20676e69    	<unknown>
100001a64: 61666564    	<unknown>
100001a68: 20746c75    	<unknown>
100001a6c: 72636573    	<unknown>
100001a70: 55007465    	<unknown>
100001a74: 7075736e    	adr	x14, 0x1000ec8e3 <_secret_alloc_base+0xe463b>
100001a78: 74726f70    	<unknown>
100001a7c: 76206465    	<unknown>
100001a80: 65756c61    	fnmls	z1.h, p3/m, z3.h, z21.h
100001a84: 68747000    	<unknown>
100001a88: 64616572    	<unknown>
100001a8c: 6572635f    	fnmls	z31.h, p0/m, z26.h, z18.h
100001a90: 00657461    	<unknown>
100001a94: 6c6c616d    	ldnp	d13, d24, [x11, #-0x140]
100001a98: 6520636f    	<unknown>
100001a9c: 74636976    	<unknown>
100001aa0: 6675625f    	<unknown>
100001aa4: 6c616300    	ldnp	d0, d24, [x24, #-0x1f0]
100001aa8: 61726269    	<unknown>
100001aac: 6c5f6574    	ldnp	d20, d25, [x11, #0x1f0]
100001ab0: 6e657461    	uabd.8h	v1, v3, v5
100001ab4: 74007963    	<unknown>
100001ab8: 72656d69    	<unknown>
100001abc: 6400632e    	<unknown>
100001ac0: 00617461    	<unknown>
100001ac4: 2e677641    	uabd.4h	v1, v18, v7
100001ac8: 74696820    	<unknown>
100001acc: 74616c20    	<unknown>
100001ad0: 79636e65    	ldrh	w5, [x19, #0x11b6]
100001ad4: 6c25203a    	stnp	d26, d8, [x1, #-0x1b0]
100001ad8: 202c756c    	<unknown>
100001adc: 2e677641    	uabd.4h	v1, v18, v7
100001ae0: 73696d20    	<unknown>
100001ae4: 616c2073    	<unknown>
100001ae8: 636e6574    	<unknown>
100001aec: 25203a79    	<unknown>
100001af0: 2c756c6c    	ldnp	s12, s27, [x3, #-0x58]
100001af4: 72685420    	<unknown>
100001af8: 6f687365    	fcmla.8h	v5, v27, v8[1], #270
100001afc: 203a646c    	<unknown>
100001b00: 756c6c25    	<unknown>
100001b04: 7665000a    	<unknown>
100001b08: 20746369    	<unknown>
100001b0c: 66667562    	<unknown>
100001b10: 61207265    	<unknown>
100001b14: 636f6c6c    	<unknown>
100001b18: 6c616d00    	ldnp	d0, d27, [x8, #-0x1f0]
100001b1c: 20636f6c    	<unknown>
100001b20: 72636573    	<unknown>
100001b24: 705f7465    	adr	x5, 0x1000c09b3 <_secret_alloc_base+0xb870b>
100001b28: 00656761    	<unknown>
100001b2c: 75716552    	<unknown>
100001b30: 65747365    	fnmls	z5.h, p4/m, z27.h, z20.h
100001b34: 696c2064    	ldpsw	x4, x8, [x3, #-0xa0]
100001b38: 6920656e    	stgp	x14, x25, [x11, #-0x400]
100001b3c: 7865646e    	<unknown>
100001b40: 757a2520    	<unknown>
100001b44: 20736920    	<unknown>
100001b48: 206f6f74    	<unknown>
100001b4c: 6772616c    	<unknown>
100001b50: 6d203b65    	stp	d5, d14, [x27, #-0x200]
100001b54: 6c207861    	stnp	d1, d30, [x3, #-0x200]
100001b58: 20656e69    	<unknown>
100001b5c: 25207369    	<unknown>
100001b60: 000a757a    	<unknown>
100001b64: 6e6e6143    	rsubhn2.8h	v3, v10, v14
100001b68: 7020746f    	adr	x15, 0x1000429f7 <_secret_alloc_base+0x3a74f>
100001b6c: 6563616c    	fnmls	z12.h, p0/m, z11.h, z3.h
100001b70: 63657320    	<unknown>
100001b74: 20746572    	<unknown>
100001b78: 6c207461    	stnp	d1, d29, [x3, #-0x200]
100001b7c: 20656e69    	<unknown>
100001b80: 20757a25    	<unknown>
100001b84: 68746977    	<unknown>
100001b88: 2074756f    	<unknown>
100001b8c: 7661656c    	<unknown>
100001b90: 20676e69    	<unknown>
100001b94: 69676572    	ldpsw	x18, x25, [x11, #-0xc8]
100001b98: 000a6e6f    	<unknown>
100001b9c: 6465654e    	<unknown>
100001ba0: 6e206120    	rsubhn2.16b	v0, v9, v0
100001ba4: 20747865    	<unknown>
100001ba8: 656e696c    	fnmls	z12.h, p2/m, z11.h, z14.h
100001bac: 206f7420    	<unknown>
100001bb0: 736f7263    	<unknown>
100001bb4: 6c203a73    	stnp	d19, d14, [x19, #-0x200]
100001bb8: 5f656e69    	<unknown>
100001bbc: 3d786469    	ldr	b9, [x3, #0xe19]
100001bc0: 2c757a25    	ldnp	s5, s30, [x17, #-0x58]
100001bc4: 5f726e20    	<unknown>
100001bc8: 656e696c    	fnmls	z12.h, p2/m, z11.h, z14.h
100001bcc: 7a253d73    	<unknown>
100001bd0: 43000a75    	<unknown>
100001bd4: 6f6e6e61    	<unknown>
100001bd8: 6c702074    	ldnp	d20, d8, [x3, #-0x100]
100001bdc: 20656361    	<unknown>
100001be0: 72636573    	<unknown>
100001be4: 61207465    	<unknown>
100001be8: 736f7263    	<unknown>
100001bec: 696c2073    	ldpsw	x19, x8, [x3, #-0xa0]
100001bf0: 2520656e    	<unknown>
100001bf4: 7720757a    	<unknown>
100001bf8: 6f687469    	uqshl.2d	v9, v3, #0x28
100001bfc: 6c207475    	stnp	d21, d29, [x3, #-0x200]
100001c00: 69766165    	ldpsw	x5, x24, [x11, #-0x50]
100001c04: 7220676e    	ands	w14, w27, #0x3ffffff
100001c08: 6f696765    	sqshlu.2d	v5, v27, #0x29
100001c0c: 49000a6e    	<unknown>
100001c10: 7265746e    	<unknown>
100001c14: 206c616e    	<unknown>
100001c18: 6f727265    	fcmla.8h	v5, v19, v18[1], #270
100001c1c: 73203a72    	<unknown>
100001c20: 65726365    	fnmls	z5.h, p0/m, z27.h, z18.h
100001c24: 6f642074    	umlal2.4s	v20, v3, v4[2]
100001c28: 6e207365    	uabdl2.8h	v5, v27, v0
100001c2c: 6320746f    	<unknown>
100001c30: 73736f72    	<unknown>
100001c34: 6e696c20    	umin.8h	v0, v1, v9
100001c38: 6f622065    	umlal2.4s	v5, v3, v2[2]
100001c3c: 61646e75    	<unknown>
100001c40: 61207972    	<unknown>
100001c44: 6e692073    	usubl2.4s	v19, v3, v9
100001c48: 646e6574    	<unknown>
100001c4c: 000a6465    	<unknown>
100001c50: 72636553    	<unknown>
100001c54: 705f7465    	adr	x5, 0x1000c0ae3 <_secret_alloc_base+0xb883b>
100001c58: 20656761    	<unknown>
100001c5c: 65736162    	fnmls	z2.h, p0/m, z11.h, z19.h
100001c60: 25203d20    	<unknown>
100001c64: 73202c70    	<unknown>
100001c68: 65726365    	fnmls	z5.h, p0/m, z27.h, z18.h
100001c6c: 203d2074    	<unknown>
100001c70: 28207025    	stnp	w5, w28, [x1, #-0x100]
100001c74: 656e696c    	fnmls	z12.h, p2/m, z11.h, z14.h
100001c78: 757a2520    	<unknown>
100001c7c: 7325202c    	<unknown>
100001c80: 756f6220    	<unknown>
100001c84: 7261646e    	<unknown>
100001c88: 000a2979    	<unknown>
100001c8c: 61727473    	<unknown>
100001c90: 696c6464    	ldpsw	x4, x25, [x3, #-0xa0]
100001c94: 6100676e    	<unknown>
100001c98: 6e67696c    	<unknown>
100001c9c: 74206465    	<unknown>
100001ca0: 6f 00       	<unknown>

Disassembly of section __TEXT,__const:

0000000100001cb0 <__const>:
		...
100001cb8: 004c4b40    	<unknown>
100001cbc: 00000000    	udf	#0x0

0000000100001cc0 <_secret_template>:
100001cc0: 20656854    	<unknown>
100001cc4: 656b6163    	fnmls	z3.h, p0/m, z11.h, z11.h
100001cc8: 20736920    	<unknown>
100001ccc: 696c2061    	ldpsw	x1, x8, [x3, #-0xa0]
100001cd0: 65 21 00    	<unknown>

Disassembly of section __TEXT,__unwind_info:

0000000100001cd4 <__unwind_info>:
100001cd4: 00000001    	udf	#0x1
100001cd8: 0000001c    	udf	#0x1c
100001cdc: 00000005    	udf	#0x5
100001ce0: 00000030    	udf	#0x30
100001ce4: 00000000    	udf	#0x0
100001ce8: 00000030    	udf	#0x30
100001cec: 00000002    	udf	#0x2
100001cf0: 02000000    	<unknown>
100001cf4: 04000003    	add	z3.b, p0/m, z3.b, z0.b
100001cf8: 04000007    	add	z7.b, p0/m, z7.b, z0.b
100001cfc: 02001000    	<unknown>
100001d00: 04000001    	add	z1.b, p0/m, z1.b, z0.b
100001d04: 000005e8    	udf	#0x5e8
100001d08: 00000054    	udf	#0x54
100001d0c: 00000054    	udf	#0x54
100001d10: 00001708    	udf	#0x1708
100001d14: 00000000    	udf	#0x0
100001d18: 00000054    	udf	#0x54
		...
100001d28: 00000003    	udf	#0x3
100001d2c: 0010000c    	<unknown>
100001d30: 0003004c    	<unknown>
100001d34: 00000000    	udf	#0x0
100001d38: 0200000c    	<unknown>
100001d3c: 03000128    	<unknown>
100001d40: 05000160    	orr	z0.s, z0.s, #0xfff
100001d44: 010004f4    	<unknown>
100001d48: 000006ac    	udf	#0x6ac
100001d4c: 030006d8    	<unknown>
100001d50: 06000724    	<unknown>
100001d54: 0000097c    	udf	#0x97c
100001d58: 01000a40    	<unknown>
100001d5c: 02000bc8    	<unknown>
100001d60: 04000c44    	add	z4.b, p3/m, z4.b, z2.b
100001d64: 01000cd8    	<unknown>
100001d68: 02000d24    	<unknown>
100001d6c: 04001060    	add	z0.b, p4/m, z0.b, z3.b
100001d70: 070010a4    	<unknown>
100001d74: 0400001f    	add	z31.b, p0/m, z31.b, z0.b
100001d78: 0400010f    	add	z15.b, p0/m, z15.b, z8.b
100001d7c: 04000000    	add	z0.b, p0/m, z0.b, z0.b
100001d80: 00000000    	udf	#0x0

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
1000040ec: 80100000    	<unknown>
1000040f0: 0000001e    	udf	#0x1e
1000040f4: 80000000    	<unknown>

Disassembly of section __DATA,__data:

0000000100008000 <_secret_default>:
100008000: 00001858    	udf	#0x1858
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
