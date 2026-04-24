#!/usr/bin/python3
from argparse import ArgumentParser
from re import compile

COLOURS = ['WHITE', 'GREEN', 'PINK', 'CYAN', 'YELLOW', 'RED', 'BLUE', 'GREY']

ORG = '.org {}'
STRINGN = '.stringn "{}"'
DH = '.dh {}'
DB = '.db {}'

def output_code(output_filename, code):
	with open(output_filename, 'w') as outputf:
		for l in code:
			print(l, file=outputf)
	
def get_msg_byte_length(msg, bracketeer):
	byte_length = 0
	for chunk in bracketeer.findall(msg):
		if not chunk.startswith('{'):
			byte_length += len(chunk)
		elif chunk[:4] in ['{DIG', '{OPT']:
			byte_length += 3
		elif chunk[:3] in ['{DE', '{CO', '{BU', '{f6', '{IT', '{PL', '{AR', '{CH', '{SM', '{ID']:
			byte_length += 2
		else:
			byte_length += 1
	return byte_length

def generate_code(translation):
	code = []
	bracketeer = compile(r'\{[^\}]+\}|[^\{]+')
	cur_block = None
	cur_pos = None
	msg_counter = None
	block_msgs = None
	for l in translation:
		block, msg_count, _, msg = l.split('|')
		if block:
			cur_block = int(block, 16)
			cur_pos = int(block, 16) + int(msg_count) * 2
			msg_counter = 0
			block_msgs = dict()
		code.append(ORG.format(hex(cur_block + msg_counter * 2)))
		if msg in block_msgs:
			cur_msg_pos = block_msgs[msg]
			code.append(DH.format(hex(cur_msg_pos - cur_block)))
		else:
			cur_msg_pos = cur_pos
			block_msgs[msg] = cur_msg_pos
			code.append(DH.format(hex(cur_msg_pos - cur_block)))
			
			code.append(ORG.format(hex(cur_msg_pos)))
			chunks = bracketeer.findall(msg)
			split_msg = []
			for c in chunks:
				if c.startswith('{OP'):
					code.append(STRINGN.format(''.join(split_msg)))
					split_msg = []
					_, option_bytes = c[:-1].split(':')
					code.append(DB.format(','.join(['0xfc', '0x' + option_bytes[:2], '0x' + option_bytes[2:]])))
				elif c.startswith('{f6'):
					code.append(STRINGN.format(''.join(split_msg)))
					split_msg = []
					_, option_byte = c[:-1].split(':')
					code.append(DB.format(','.join(['0xf6', '0x' + option_byte])))
				elif c.startswith('{IT'):
					code.append(STRINGN.format(''.join(split_msg)))
					split_msg = []
					_, option_byte = c[:-1].split(':')
					code.append(DB.format(','.join(['0xfa', '0x' + option_byte])))
				else:
					split_msg.append(c.replace('"', '\\"'))
			if split_msg:
				code.append(STRINGN.format(''.join(split_msg)))
			
			cur_pos += get_msg_byte_length(msg, bracketeer)
		
		code.append('')
		msg_counter += 1
	
	return code

def get_translation(csv_filename):
	with open(csv_filename, 'r') as csvf:
		return [l.rstrip() for l in csvf.readlines()]

def get_args():
	parser = ArgumentParser()
	parser.add_argument('csv')
	parser.add_argument('output')
	return parser.parse_args()

if __name__ == '__main__':
	args = get_args()
	translation = get_translation(args.csv)
	code = generate_code(translation)
	output_code(args.output, code)
