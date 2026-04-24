# "Tiny Bullets" PS1 English translation patch

This includes all the necessary code to patch the game and translate it to English.
Patcher script is Linux only, but it should be easy to replicate the same steps in a .bat in Windows.

## What you'll need:
*	Java and Wine installed on your system.
*	A copy of the game ("Tiny Bullets (Japan)"), with the .cue and .bin extracted in the "bin" folder.
*	MD5 for Tiny Bullets (Japan).bin should be 9380f92615ec380e9dc178f9898d8a63

##	You'll also need the following executables in the "tools" folder:
*	armips.exe
*	jpsxdec.jar
*	jpsxdec-lib.jar
*	psxinject.exe (part of the psximager suite)

Simply give run permissions to patcher.py and execute. If everything's in order, it'll dropped a patched .bin of the game in the bin folder and you'll be able to play it in English.

## Changelog:
###	v1.0:
*	Initial commit. The game is fully playable with the code as it stands.

##	About this patch:
### Credits
*	Chapu - Programming/hacking, Translation, QA/Playtesting
*	Etokapa - Graphics, Proofreading, QA/Playtesting

## Notes
I included the scripts used to extract the Japanese text and reinsert the translation. Look for text_extractor.py and text_inserter.py in the scripts folder.
The game (thankfully) uses a simple way of addressing text. The script and messages are organized in blocks, preceded by a table of half-word (two bytes) offsets that mark the start of each different line since the beginning of the block. Because of space constraints, I had to move some blocks around in OVERLAY.BIN just to make everything fit. The problem is that block start addresses are hard-coded in assembly, hence the *stupid* amount of lines in the "OFFSET TABLES" section of OVERLAY.BIN_code.asm.
Another wee peculiarity of the game is that many images/textures (most notably the charset and end credits) are stored in non-standard TIM files. They are effectively CLUTted 4bpp images, but the header reports them as CLUTless 16bpp, and the actual CLUTs are stored at the end of the pixel data section. Nothing particularly difficult to solve with a simple hex editor, but this is the reason why the image_inserter.py script only reads and reinserts the pixel data from the modified images. No need to mangle a perfectly good TIM just so that it complies with the game's ludicrous logic if we can simply skip the header and put just the pixels in there!
Also of note, if the charset we used looks familiar that's because I shamelessly stole it from "Meremanoid". I needed a 6px wide font and that one looked nice enough. The digits though were stolen from the "Parasite Eve" charset instead, since the ones from "Meremanoid" are pretty dismal.

As usual, feel free to use and modify this code to translate the game to other languages or do whatever you want with it. Code should be free: I was only able to learn ROM hacking thanks to the kindness of people who shared their code publicly for everyone to study it. If you use this code, dropping me a line with a simple "Thank you" and a heads-up for your project would be appreciated, but is by no means mandatory.
