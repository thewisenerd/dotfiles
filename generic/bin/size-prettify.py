#!/usr/bin/env python2

#  author: thewisenerd <thewisenerd@protonmail.com>
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#

import re

from sys import stdin
from os import isatty

import argparse
from argparse import RawTextHelpFormatter

parser = argparse.ArgumentParser(description="""\
do 'stuff' with size -A -d output piped in

example:
  size -A -d test.elf | size-prettify.py -S "flash 256k .isr_vector .text .rodata .init_array .fini_array .data" -S "ram 32k .data .bss ._user_heap_stack"
\
""", formatter_class=RawTextHelpFormatter)
verbose = False
pretty = False

# https://stackoverflow.com/a/7098372
def mon_stdin():
	ip = ""
	while True:
		c = stdin.read(1)
		if not c:
			break;
		ip += c

	for line in ip.split('\n'):
		yield line

def usage():
	global parser
	parser.print_help()

def read_size(s):
	scopy = s
	size = 0
	multiplier = 1
	valid_size_suffix = ['k', 'm', 'g']
	base = 10

	def get_multiplier(m):
		if m == 'k':
			return 1024
		if m == 'm':
			return 1024 ** 2
		if m == 'g':
			return 1024 ** 3

	if not s:
		return None

	if len(s) == 0:
		return None

	if s[-1].isalpha():
		if s[-1].lower() in valid_size_suffix:
			multiplier = get_multiplier(s[-1].lower())
			s = s[:-1]
		else:
			print("invalid size suffix in argument: " + s)
			return None

	if len(s) > 2 and s[1].lower() == 'x':
		base = 16

	try:
		size = int(s, base)
	except ValueError:
		print("invalid size argument: " + s)
		return None

	return size * multiplier

def parse_arg_sections(sections):
	ret = []

	for s in sections:
		arr = re.sub(' +', ' ', s.strip()).split(' ')

		if len(arr) < 3:
			print("invalid section argument: " + s)

		name = arr[0]
		size = read_size(arr[1])

		if not size:
			print("invalid section argument: " + s)
			quit(1)

		arr = arr[2:]

		ret.append((name, size, tuple(arr)))

	return ret

def parse_line_size(l, m):
	rstr = re.escape(m)
	rstr += "\s+([0-9]+)\s+([0-9]+)"

	matches = re.search(rstr, l)

	if not matches:
		return None

	if len(matches.groups()) != 2:
		return None

	try:
		ret = int(matches.group(1))
	except:
		return None

	return ret

def parse(sections):
	global verbose

	size_max = {}
	size_calc = {}
	section_list = {}
	ret = {}

	for s in sections:
		size_max[s[0]] = s[1]
		size_calc[s[0]] = 0
		section_list[s[0]] = s[2]

	def line_startswith(l, s):
		for x in s:
			if l.startswith(x):
				return x
		return None

	try:
		for line in mon_stdin():
			for s in section_list:
				linematch = line_startswith(line, section_list[s])
				if linematch:
					size_section = parse_line_size(line, linematch)
					if not size_section:
						print("unable to parse output line: " + line)
						quit(1)
					if verbose:
						print("mem:" + s + ";\n section: " + linematch + ";\n size: " + str(size_section) + "\n")
					size_calc[s] += size_section
	except KeyboardInterrupt:
		sys.stdout.flush()
		pass

	for s in sections:
		ret[s[0]] = ( size_calc[s[0]], size_max[s[0]], float(size_calc[s[0]])/float(size_max[s[0]]) )

	return ret

def output(p):
	global pretty

	if not pretty:
		for m in p:
			print(m + ": " + str(p[m][0]) + " bytes (" + "{0:.2f}".format(p[m][2] * 100) + "%)")
	else:
		from prettytable import PrettyTable
		t = PrettyTable(['memory', 'size', 'total', 'used'])
		t.align = "r"
		t.align['memory'] = "c"
		for m in p:
			t.add_row([m, p[m][0], p[m][1], "{0:.2f}%".format(p[m][2] * 100)])
		print(t)

def main():
	global parser
	global verbose
	global pretty

	parser.add_argument("-v", "--verbose", dest="verbose", action='store_true',
						help="verbose output")
	parser.add_argument("-p", "--pretty", dest="pretty", action='store_true',
						help="pretty output. requires PTable module")
	parser.add_argument("-S", "--section", dest="section", default=None,
					help="""\
define a section in the following format;
	NAME SIZE SYM1 SYM2 SYM3
use SIZE as zero to skip size usage calculation
\
					""", action='append')

	options = parser.parse_args()

	is_pipe = not isatty(stdin.fileno())

	if not is_pipe or not options.section:
		usage()
		quit(1)

	if options.verbose:
		verbose = True

	if options.pretty:
		pretty = True

	sections = parse_arg_sections(options.section)
	sizes = parse(sections)

	output(sizes)

if __name__ == '__main__':
	main()
