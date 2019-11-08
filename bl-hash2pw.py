#!/usr/bin/env python3
# Take a breach list in format USERNAME@MAIL.COM:PASSWORD
# Search for PASSWORDs in hash format, replace with cleartext
# passwords from .pot files

import argparse
import bisect
from os import path

OV = '\x1b[0;33m' # verbose
OR = '\x1b[0;34m' # routine
OE = '\x1b[1;31m' # error
OM = '\x1b[0m'    # mischief managed

file_path = path.dirname(path.realpath(__file__))

parser = argparse.ArgumentParser()
parser.add_argument("dump", help="dump file with hashes")
parser.add_argument("pot", help=".pot file to use for hash substitutions")
parser.add_argument("out", help="file to store updated dump")
parser.add_argument("-v", "--verbosity", action="count", default=0, help="be more verbose")
args = parser.parse_args()

if __name__ == '__main__':
  if args.verbosity > 0:
    print(f"{OV}Running program over {OR}{args.dump}{OV}, with pot file {OR}{args.pot}{OV}, outputting to {OR}{args.out}{OM}")
  if True:

    # put the pot list into a bisect-able list
    hashes = []
    passes = []
    hashfile = open(args.pot,'r')
    line = hashfile.readline().strip()
    hashcount = 0
    hashlength = len(line.split('$')[2].split(':')[1]) # 0000702d245d30da1147ac8dff4bf3ba18216174
    while line != '':
      if ':' in line: # SHA1 lines look like $dynamic_26$0000702d245d30da1147ac8dff4bf3ba18216174:dance77
        hashes += [line.split('$')[2].split(':')[0]] # 0000702d245d30da1147ac8dff4bf3ba18216174
        passes += [line.split('$')[2].split(':')[1]] # dance77
      line = hashfile.readline().strip()
      hashcount += 1
    if args.verbosity > 0:
      print(f'{OV}Read {OR}{hashcount}{OV} lines from pot file{OM}')
    hashfile.close()
    # create target file
    outfile = open(args.out,"w")
    # read dump file
    dumpfile = open(args.dump,'r')
    line = dumpfile.readline().strip()
    replacecount = 0
    linecount = 0
    while line != '':
      linecount += 1
      if args.verbosity > 1: print(f'{OV}Current line is {OR}{line}{OM}')
      if args.verbosity > 0 and linecount % 500000000 == 0: # gimme something every 500M lines
        print(f'{OV}Current line is {OR}{linecount}{OV}, looks like: {OR}{line}{OM}')
      if ':' in line:
        hash = line.split(':')[1].lower()
      else:
        hash = ''
      if len(hash) == hashlength: # looks like right length?
        b = bisect.bisect_left(hashes,hash)
        if b != hashcount and hashes[b] == hash:
          line = line.replace(hash,passes[b])
          replacecount += 1
      outfile.write(line+'\n')
      line = dumpfile.readline().strip()
    if args.verbosity > 0:
        print(f'{OV}Replaced {OR}{replacecount}{OV} hashes with cleartext passwords')
    outfile.close()
    dumpfile.close()
  else: #except  Exception as ex: # catch exceptions
    print(f'{OE}*** Exception: {OR}{ex}{OM}') 