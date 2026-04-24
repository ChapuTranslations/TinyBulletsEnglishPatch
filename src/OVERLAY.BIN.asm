.Open "exe/src_OVERLAY.BIN", "exe/OVERLAY.BIN", 0x0

.include "src/OVERLAY.BIN_code.asm"
.include "src/OVERLAY.BIN_text.asm"
.include "src/OVERLAY.BIN_extra_text.asm"
.include "src/OVERLAY.BIN_credits.asm"

.Close
