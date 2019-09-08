#!/usr/bin/env python3

import os
import glob
import csv
from xlsxwriter.workbook import Workbook

import sys

import argparse
parser = argparse.ArgumentParser()
parser.add_argument('-o', '--output', help='output file', required=True)
parser.add_argument('FILE', nargs='+')
args = parser.parse_args()

wb_output = args.output
files = args.FILE
workbook = Workbook(wb_output, {'strings_to_numbers': True})
for csvfile in files:
    basename, ext = os.path.splitext(os.path.basename(csvfile))
    worksheet = workbook.add_worksheet(basename)
    with open(csvfile, 'rt', encoding='utf8') as f:
        reader = csv.reader(f)
        for r, row in enumerate(reader):
            for c, col in enumerate(row):
                worksheet.write(r, c, col)
workbook.close()