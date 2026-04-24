#!/usr/bin/python3
from argparse import ArgumentParser
from struct import unpack
from pathlib import Path

COLOURS = ['WHITE', 'GREEN', 'PINK', 'CYAN', 'YELLOW', 'RED', 'BLUE', 'GREY']
BUTTONS = ['D', 'CIRCLE', 'X', 'SQUARE', 'TRIANGLE', 'R1', 'L2', 'R2', 'L1']

def output_messages(output_filename, msgs):
	with open(output_filename, 'w') as outputf:
		for block in msgs:
			print('|'.join([hex(block), f"{msgs[block]['count']}", msgs[block]['msgs'][0]]), file=outputf)
			for m in msgs[block]['msgs'][1:]:
				print('|'.join(['', '', m]), file=outputf)

def get_offsets_by_block(inputf, blocks):
	offsets_by_block = dict()
	for block in blocks:
		offsets_by_block[block] = []
		inputf.seek(block)
		first_offset = unpack('<H', inputf.read(2))[0]
		offsets_by_block[block].append(first_offset)
		while inputf.tell() < first_offset + block:
			offset = unpack('<H', inputf.read(2))[0]
			offsets_by_block[block].append(offset)
		
	return offsets_by_block

def get_messages(blocks_filename, charset):
	with open(blocks_filename, 'r') as blocksf:
		blocks_per_filename = blocksf.readlines()
	
	for b in blocks_per_filename:
		input_filename, blocks = b.split('|')
		input_filename = Path(input_filename)
		blocks = [int(b, 16) for b in blocks.rstrip().split(',')]
	
		msgs = dict()
		with open(input_filename, 'br') as inputf:
			offsets_by_block = get_offsets_by_block(inputf, blocks)
			for block, offsets in offsets_by_block.items():
				msgs[block] = {'count':len(offsets), 'msgs':[]}
				for o in offsets:
					msg = []
					inputf.seek(block + o)
					while True:
						c = int.from_bytes(inputf.read(1), 'little')
						
						if c < 0xf0:
							msg.append(charset[c])
						else:
							match c:
								case 0xf0:
									msg.append('{END}')
									msgs[block]['msgs'].append(''.join(msg))
									break
								case 0xf1:
									msg.append('{NL}')
								case 0xf2:
									c = int.from_bytes(inputf.read(1), 'little') | 0x100
									msg.append(charset[c])
								case 0xf3:
									c = int.from_bytes(inputf.read(1), 'little') | 0x200
									msg.append(charset[c])
								case 0xf4:
									msg.append('{BP}')
								case 0xf6:
									msg.append(f'{{f6:{inputf.read(1).hex()}}}')
								case 0xf7:
									msg.append(f'{{DELAY:{inputf.read(1).hex()}}}')
								case 0xf9:
									msg.append(f'{{DIGITS:{inputf.read(1).hex()}{inputf.read(1).hex()}}}')
								case 0xfa:
									msg.append(f'{{ITEM:{inputf.read(1).hex()}}}')
								case 0xfb:
									msg.append(f'{{COLOUR:{COLOURS[int.from_bytes(inputf.read(1), "little")]}}}')
								case 0xfc:
									msg.append(f'{{OPTIONS:{inputf.read(1).hex()}{inputf.read(1).hex()}}}')
								case 0xfd:
									msg.append(f'{{BUTTON:{BUTTONS[int.from_bytes(inputf.read(1), "little")]}}}')
								case _:
									msg.append(f'{{{c:x}}}')
	
		output_filename = f'{input_filename.stem}.csv'
		output_messages(output_filename, msgs)

def get_charset():
	with open('charset.txt', 'r') as charsetf:
		lines = charsetf.readlines()
	
	return [c.rstrip('\n') for c in lines]

def get_args():
	parser = ArgumentParser()
	parser.add_argument('input')
	# ~ parser.add_argument('output')
	return parser.parse_args()

if __name__ == '__main__':
	args = get_args()
	charset = get_charset()
	get_messages(args.input, charset)
	# ~ output_messages(args.output, messages)
