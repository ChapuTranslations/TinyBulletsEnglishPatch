#!/usr/bin/python3
from subprocess import run
VERSION = 1.1

if __name__ == '__main__':
	# Create IDX file
	run('java -jar tools/jpsxdec.jar -f bin/Tiny\ Bullets\ \(Japan\).bin -x bin/tb.idx', shell = True)
	
	# Extract data files
	files = [(1,'SCPS_101.30'), (2,'OVERLAY.BIN'), (20,'ALLDATA.BIN')]
	for i,f in files:
		run(f'java -jar tools/jpsxdec.jar -x bin/tb.idx -i {i} -dir exe/', shell = True)
		run(f'mv exe/{f} exe/src_{f}', shell=True)
	
	# Create translated code files
	run('scripts/text_inserter.py scripts/translated_overlay.csv src/OVERLAY.BIN_text.asm', shell=True)
	run('scripts/text_inserter.py scripts/translated_alldata.csv src/ALLDATA.BIN_text.asm', shell=True)
	
	# Compile
	run('wine tools/armips.exe main\.asm', shell=True)
	
	# Insert images
	run('scripts/image_inserter.py assets/ exe/', shell=True)
	
	# Insert modified data files into bin
	run(f'cp bin/Tiny\ Bullets\ \(Japan\).bin exe/Tiny\ Bullets\ \(English\ v{VERSION}\).bin', shell=True)
	run(f'cp bin/Tiny\ Bullets\ \(English\ v{VERSION}\).cue exe/Tiny\ Bullets\ \(English\ v{VERSION}\).cue', shell=True)
	run(f'wine tools/psxinject.exe -v exe/Tiny\ Bullets\ \(English\ v{VERSION}\).bin SCPS_101\.30 exe/SCPS_101\.30', shell=True)
	run(f'wine tools/psxinject.exe -v exe/Tiny\ Bullets\ \(English\ v{VERSION}\).bin OVERLAY\.BIN exe/OVERLAY\.BIN', shell=True)
	run(f'wine tools/psxinject.exe -v exe/Tiny\ Bullets\ \(English\ v{VERSION}\).bin ALLDATA\.BIN exe/ALLDATA\.BIN', shell=True)
	
	# Clean up
	run(f'mv exe/Tiny\ Bullets\ \(English\ v{VERSION}\).bin bin/Tiny\ Bullets\ \(English\ v{VERSION}\).bin', shell=True)
	run('rm exe/*', shell=True)
	run('rm src/OVERLAY.BIN_text.asm', shell=True)
	run('rm src/ALLDATA.BIN_text.asm', shell=True)
	run('rm bin/tb.idx', shell=True)
	run('rm *.log', shell=True)
