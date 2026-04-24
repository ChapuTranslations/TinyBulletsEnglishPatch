#!/usr/bin/python3
from pathlib import Path
from argparse import ArgumentParser
from subprocess import check_output
from struct import unpack

CLUT_FLAG = 0x8

def insert_pixel_data_into(pixel_data, dest_filepath, dest_img_pos):
	with open(dest_filepath, 'br+') as destf:
		pixel_data_pos = get_tim_pixel_data_start_pos(destf, dest_img_pos)
		destf.seek(pixel_data_pos)
		destf.write(pixel_data) 

def get_tim_pixel_data_start_pos(img_obj, img_start_pos):
	#Skip magic number (first 4 bytes)
	img_obj.seek(img_start_pos + 4)
	# Read flag word (next 4 bytes)
	flag = unpack('<I', img_obj.read(4))[0]
	# Check for CLUT
	if flag & CLUT_FLAG:		
		# Read CLUT size
		clut_size = unpack('<I', img_obj.read(4))[0]
		# Beginning of pixel data
		# 4 bytes magic number + 4 bytes flag word + CLUT size + 12 bytes pixel header
		return img_start_pos + 4 + 4 + clut_size + 12
	else:
		# Beginning of pixel data
		# 4 bytes magic number + 4 bytes flag word + 12 bytes pixel header
		return img_start_pos + 4 + 4 + 12

def insert_images(from_dir, to_dir):
	images = check_output(f'ls {from_dir}*.tim', shell=True, text=True)
	for i in images.split('\n')[:-1]:
		image_path = Path(i)
		dest_file, dest_img_pos = image_path.stem.split('_')
		with open(image_path, 'br') as imgf:
			pixel_data_pos = get_tim_pixel_data_start_pos(imgf, 0)
			imgf.seek(pixel_data_pos)
			pixel_data = imgf.read()
		insert_pixel_data_into(pixel_data, to_dir + dest_file, int(dest_img_pos, 16))

def get_args():
	parser = ArgumentParser()
	parser.add_argument('image_dir')
	parser.add_argument('target_dir')
	return parser.parse_args()

if __name__ == '__main__':
	args = get_args()
	insert_images(args.image_dir, args.target_dir)
