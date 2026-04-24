; Save file text
.org 0x4b92c4
.sjisn "Ｔｉｎｙ　"
.dh 0x0

; Add space before play time
; in sprintg format string for
; save file text
.org 0x4ae932
.sjisn "　"

; New start address for sprintf
; format with extra space
; 0x801d6eb4
.org 0x4b56b4
addiu	a1,0x132


; Death options
; 0x800b278b
.org 0x17669b
.stringn "TRY AGAIN{NL}QUIT{NL}"
.db 0xfc,0x02,0x00
.stringn "{END}"
