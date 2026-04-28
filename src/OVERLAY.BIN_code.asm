@char_dist		equ 0x6
@char_width		equ 0x6
@chars_per_line	equ 0x20
@item_desc_off	equ 0x1350
@f9_code_off	equ 0x119c
@puzzle_off		equ 0x2400

; /// TEXT HACKS ///
; Update X coord to draw chars
; @char_dist px apart
.org 0x1bd160
li		v0,@char_dist
mult	v0,a3
lhu		v0,0x4(t0)
mflo	v1
addu	v0,v1
nop
nop

; Make char vertex 2 X coord be
; @char_width px away from vertex 1
.org 0x1bd1a8
addiu	v0,@char_width

; Make char vertex 4 X coord be
; @char_width px away from vertex 1
.org 0x1bd208
addiu	v0,@char_width

; Make char texture be
; @char_width px wide
; 0x800f9158
.org 0x1bd068
sb		s3,0xf(s0)
sb		r0,0x7(s0)
sb		r0,0xe(s0)
j		0x80100af4
sb		s3,0x17(s0)
sb		s3,0x16(s0)

; 0x80100af4
.org 0x1c4a04
li		s3,@char_width
j		0x800f916c
sb		s3,0x6(s0)

; 0x800f9a80
.org 0x1bd990
addiu	v1,a1,@char_width

; Allow more chars per line
; Options menu
; 0x801d1388
.org 0x4a9388
sw		v0,0x10(sp)
li		v0,0x6
sw		v0,0x20(sp)
li		v0,0x1

; 0x801d1cd8
.org 0x4a9cd8
sw		v0,0x10(sp)
li		v0,0x6
sw		v0,0x20(sp)
li		v0,0x1

; 0x801d1eac
.org 0x4a9eac
sw		v0,0x10(sp)
li		v0,0x6
sw		v0,0x20(sp)
li		v0,0x1

; Screen adjust
; 0x801d24f8
.org 0x4aa4f8
sw		v1,0x18(sp)
sw		r0,0x20(sp)
sw		v0,0x24(sp)
sw		v0,0x28(sp)
lw		a0,0x18(s0)
jal		0x800fa050
li		a3,-0x1a
lui		a0,0x800a
li		v1,0x1e
sw		v1,0x10(sp)

; Subtitles
; 0x800f7ef4
.org 0x1bbe04
sb		v1,0x8be(s1)
j		0x80100ac0
sb		r0,0xb(s1)
sb		r0,0x9(s1)

; 0x80100ac0
.org 0x1c49d0
li		v1,@chars_per_line
j		0x800f7f00
sb		v1,0x8bc(s1)

; In-game dialogues
; 0x800f7e5c
.org 0x1bbd6c
sb		a0,0x8be(s1)
j		0x80100acc
sb		r0,0xb(s1)
sb		v1,0x9(s1)

; 0x80100acc
.org 0x1c49dc
li		a0,@chars_per_line
j		0x800f7e68
sb		a0,0x8bc(s1)

; Instructions
; 0x801d56b8
.org 0x4ad6b8
sw		v0,0x18(sp)
j		0x80100ae8
sw		v0,0x20(sp)

; 0x80100ae8
.org 0x1c49f8
li		v0,@chars_per_line
j		0x801d56c4
sw		v0,0x10(sp)

; 0x800fa054
.org 0x1bdf64
li		v1,@chars_per_line

; Fix characters for item options
; "USE", "EQUIP", "EXIT", etc.
; Make char poly/texture 7px wide
; 0x800ef070
.org 0x1b2f80
li		s7,0x47

; 0x800ef35c
.org 0x1b326c
li		s6,0x47

; 0x800ef198
.org 0x1b30a8
addiu	t0,v1,0x7

; 0x800ef484
.org 0x1b3394
addiu	t0,v1,0x7

; 0x800ef1ec
.org 0x1b30fc
addiu	s6,0x7

; 0x800ef4d8
.org 0x1b33e8
addiu	s5,0x7

; 0x800ef200
.org 0x1b3110
addiu	s7,0x7

; 0x800ef4ec
.org 0x1b33fc
addiu	s6,0x7

; Read 5 chars instead of 4
; 0x800ef278
.org 0x1b3188
slti	v0,s4,0x5

; 0x800ef564
.org 0x1b3474
slti	v0,s4,0x5

; /// OFFSET TABLES ///
; Change position of offset
; table for f9 codes button
; shorthands
; 0x800f974c
.org 0x1bd65c
addiu	v1,@f9_code_off

; Change position of offset
; table for item descriptions
; 0x800eb5f0
.org 0x1af500
addiu	a1,@item_desc_off

; 0x800ec6d8
.org 0x1b05e8
addiu	a1,@item_desc_off

; 0x800ec6f4
.org 0x1b0604
addiu	a1,@item_desc_off

; 0x800ec714
.org 0x1b0624
addiu	a1,@item_desc_off

; 0x800ec72c
.org 0x1b063c
addiu	a1,@item_desc_off

; 0x800ec748
.org 0x1b0658
addiu	a1,@item_desc_off

; 0x800ec8dc
.org 0x1b07ec
addiu	a1,@item_desc_off

; 0x800ec940
.org 0x1b0850
addiu	a1,@item_desc_off

; 0x800ecaf8
.org 0x1b0a08
addiu	a1,@item_desc_off

; 0x800ecb1c
.org 0x1b0a2c
addiu	a1,@item_desc_off

; 0x800ece18
.org 0x1b0d28
addiu	v1,@item_desc_off

; 0x800ecfb4
.org 0x1b0ec4
addiu	a1,@item_desc_off

; 0x800ed4f0
.org 0x1b1400
addiu	a1,@item_desc_off

; 0x800ed150
.org 0x1b1060
addiu	a1,@item_desc_off

; 0x800ed508
.org 0x1b1418
addiu	a1,@item_desc_off

; 0x800edf54
.org 0x1b1e64
addiu	t0,@item_desc_off

; 0x800ee000
.org 0x1b1f10
addiu	a1,@item_desc_off

.org 0x1b1f18
addiu	a1,@item_desc_off

; 0x800ee028
.org 0x1b1f38
lhu		v0,@item_desc_off(a1)

.org 0x1b1f40
addiu	a1,@item_desc_off

.org 0x1b1f48
addiu	a1,@item_desc_off

; 0x800ef080
.org 0x1b2f90
addiu	v0,@item_desc_off

; 0x800ef36c
.org 0x1b327c
addiu	v1,@item_desc_off

; Change position of offset
; table for puzzles, lift,
; etc.
; 0x800fad2c
.org 0x1bec3c
addiu	s1,s5,@puzzle_off

; 0x800fad8c
.org 0x1bec9c
lhu		a1,@puzzle_off(s5)

; 0x800fadcc
.org 0x1becdc
addiu	t2,v0,@puzzle_off

; 0x800faf50
.org 0x1bee60
addiu	a1,@puzzle_off

; 0x800fafa4
.org 0x1beeb4
addiu	a1,@puzzle_off

; 0x800fafb8
.org 0x1beec8
addiu	a1,@puzzle_off

; 0x800fafd4
.org 0x1beee4
addiu	a1,@puzzle_off

; 0x800faff4
.org 0x1bef04
addiu	a1,@puzzle_off

; 0x800fb024
.org 0x1bef34
addiu	a1,@puzzle_off

; 0x800fb064
.org 0x1bef74
addiu	a1,@puzzle_off

; 0x800fb1d0
.org 0x1bf0e0
addiu	s0,@puzzle_off

; 0x800fb3d8
.org 0x1bf2e8
addiu	a1,@puzzle_off

; 0x800fb464
.org 0x1bf374
addiu	a1,@puzzle_off

; 0x800fb49c
.org 0x1bf3ac
addiu	a1,@puzzle_off

; 0x800fb5a8
.org 0x1bf4b8
addiu	a1,@puzzle_off

; 0x800fb5c0
.org 0x1bf4d0
addiu	a1,@puzzle_off

; 0x800fb920
.org 0x1bf830
addiu	a1,@puzzle_off

; 0x800fb968
.org 0x1bf878
addiu	a1,@puzzle_off

; 0x800fbcf0
.org 0x1bfc00
addiu	a1,@puzzle_off


; /// GRAPHICS PLACEMENT ///
; Controls menu
; Selection arrow Y pos
; 0x801d310c
.org 0x4ab10c
addiu	a3,-0x50

; Options menu
; Selection arrow Y pos
; 0x801d2194
.org 0x4aa194
addiu	a3,-0x50

; BGM and SFX vol arrows X pos
; 0x801d21ec
.org 0x4aa1ec
li		a2,-0x2e

; 0x801d228c
.org 0x4aa28c
li		a2,-0x4

; 0x801d2330
.org 0x4aa330
li		a2,-0x2e

; 0x801d23d0
.org 0x4aa3d0
li		a2,-0x4

; Rumble selector
; Y pos
; 0x801d206c
.org 0x4aa06c
li		a3,-0x39

; X pos
; 0x801d20a0
.org 0x4aa0a0
li		a2,0x18
mult	a2,v1
mflo	a2
addiu	a2,-0x29

; 0x800f17c4
.org 0x1b56d4
addiu	s4,0xa
addiu	t1,0xc

; 0x800f1a58
.org 0x1b5968
addiu	t1,0x6

; 0x800f17b4
.org 0x1b56c4
addiu	s4,0x10

; 0x800f17bc
.org 0x1b56cc
addiu	t1,0x12

; Stereo/mono selector
; X pos
; 0x801d211c
.org 0x4aa11c
li		a2,-0x29

; Y pos
; 0x801d2138
.org 0x4aa138
li		a3,-0x21

; Since "sutereo" and "monoraru"
; have the same amount of chars
; in Japanese, the game makes the
; selection frames the same size
; for both. This requires a wee
; more involved hack to make
; them different sizes in English.
; Check if we're pointing to
; "STEREO" or "MONO" to determine
; the frame width.
; 0x800f1e44
.org 0x1b5d54
lw		s3,0x90(sp)
lhu		t1,0x28(sp)
lw		s3,0x5358(s3)
move	a0,r0
j		0x80101e50
lbu		s3,0x10(s3)

; 0x80101e50
.org 0x1c5d60
li		a1,0x1
bne		s3,r0,narrow
nop
; Wide frame for "stereo"
addiu	s3,s2,0x22
addiu	s5,t1,0x22
j		0x800f1e5c
move	s4,s3

; Narrow frame for "mono"
narrow:
addiu	s3,s2,0x16
addiu	s5,t1,0x16
j		0x800f1e5c
move	s4,s3

;~ ; 0x800f1e44
;~ .org 0x1b5d54
;~ addiu	s3,s2,0x21

;~ ; 0x800f1e58
;~ .org 0x1b5d68
;~ addiu	s5,t1,0x21

; 0x801d20fc
.org 0x4aa0fc
li		a2,0x7

; Screen adjustment
; Arrow X pos
; 0x801d2a30
.org 0x4aaa30
li		a2,-0x44

; Arrow Y pos
; 0x801d2a34
.org 0x4aaa34
li a3,0xc

; Memcard screen
; Arrow X pox
; 0x801d9288
.org 0x4b7a88
addiu	a2,-0x90

; Arrow Y pox
; 0x801d929c
.org 0x4b7a9c
addiu	v0,0x2a

; start screen
; Selection arrow Y pos
; on "CONTINUE"
.org 0x1167ba
.dh 0x25

; Selection arrow X pos
; on "OPTIONS"
.org 0x1167c4
.dh 0xffd4

; on "EASY MODE"
.org 0x1167ca
.dh 0xffc6

; on "NORMAL MODE"
.org 0x1167d0
.dh 0xffb8

; on "BACK"
.org 0x1167d6
.dh 0xffe1

; Augury book YES/NO arrow X pos
; 0x801d4ec8
.org 0x4acec8
li		a2,-0x3c

; Move death screen arrow Y pos
; 1px up
; 0x800fc90c
.org 0x1c081c
addiu	a3,-0xe

; Use item gem arrow X pos
; 0x800fbf80
.org 0x1bfe90
li		a2,-0x52

; Y pos
; 0x800fbfc8
.org 0x1bfed8
addiu	a3,0x40

; Demon Tower code puzzle
; selection arrow X pos
; 0x800fbe68
.org 0x1bfd78
sll		a2,t0,0x3
addu	a2,t0
sll		a2,0x1
addiu	a2,-0x4b

; 0x800fbec8
.org 0x1bfdd8
sll		a2,t0,0x3
addu	a2,t0
sll		a2,0x1
addiu	a2,-0x4b

; Demon Tower lift floor 
; selection arrow X pos
; 0x800fbf30
.org 0x1bfe40
sll		a2,a3,0x4
subu	a2,a3
sll		a2,0x1
addiu	a2,-0x64

; End game exit arrow Y pos
; 0x80162320
.org 0x1ceb20
li		v0,0x49

; 0x8017b5e0
.org 0x1e7de0
.db 0x56

; "SAVE GAME" arrow Y pos
; 0x8017b5e2
.org 0x1e7de2
.db 0x49

; CONTROLS screen
; Button actions X pos
; Type A
; 0x801d5e7d
.org 0x4ade7d
.db 0x3c

.org 0x4adea1
.db 0xae

.org 0x4adec5
.db 0xa8

.org 0x4adee9
.db 0x28

.org 0x4adf0d
.db 0xa0

.org 0x4adf31
.db 0x41

.org 0x4adf55
.db 0x3d

.org 0x4adf79
.db 0xa2

; Type B
; 0x801d5f9d
.org 0x4adf9d
.db 0x2c

.org 0x4adfc1
.db 0xae

.org 0x4adfe5
.db 0x44

.org 0x4ae009
.db 0x9f

.org 0x4ae02d
.db 0xa0

.org 0x4ae051
.db 0x3d

.org 0x4ae075
.db 0x9d

.org 0x4ae099
.db 0x42

; Type C
; 0x801d60bd
.org 0x4ae0bd
.db 0xa4

.org 0x4ae0e1
.db 0x37

.org 0x4ae105
.db 0xa4

.org 0x4ae129
.db 0x28

.org 0x4ae14d
.db 0x40

.org 0x4ae171
.db 0xb5

.org 0x4ae195
.db 0x9d

.org 0x4ae1b9
.db 0x42
