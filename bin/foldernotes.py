#! /usr/bin/env python3

# todo: clean unwanted imports
import sys
import os
import base64
import errno
import hashlib

## remove appdirs dependency in case you want static folder
#  and define your own custom folder
from appdirs import *
appname = "FolderNotes"
appauthor = "thewisenerd"
notesdir = user_data_dir(appname, appauthor);
#
# notesdir = "/home/thewisenerd/.foldernotes"
##

def getnotepath(note):
  return notesdir + os.sep + note

def touch(fname, times=None):
  with open(fname, 'a'):
    os.utime(fname, times)

if __name__ == '__main__':

  # gracefully try to make folder for notes
  try:
    os.makedirs(notesdir)
  except OSError as exception:
    if exception.errno != errno.EEXIST:
      raise

  # the current "note" in question
  note = hashlib.sha256(os.getcwd().encode('utf-8')).hexdigest();

  # prefix dir
  note = getnotepath(note);

  # if note !exists
  if not os.path.exists( note ):
    touch( note );

  # jump to editor
  os.execvp("nano", ["nano", note]);
