#!/usr/bin/env python

import os
import re
import time
import datetime
import sys
import signal
import subprocess

def exit_gracefully(signum, frame):
	signal.signal(signal.SIGINT, original_sigint)
	try:
		if raw_input("\nreally quit? (y/n)> ").lower().startswith('y'):
			print("quitting")
			stop_server()

	except KeyboardInterrupt:
		print("\nkeyhandler override")
		print("quitting")
		stop_server()

	# restore the exit gracefully handler here
	signal.signal(signal.SIGINT, exit_gracefully)

def stop_server():
	print "stop"
	server_stop = time.time()
	print ( "server run for %s seconds" % (int)( server_stop - server_start ) )
	#subprocess.call(["mv", def_file, file_name])
	subprocess.call((("mv {0} {1}").format(def_file, file_name)), shell=True)
	sys.exit()

if __name__ == '__main__':
	original_sigint = signal.getsignal(signal.SIGINT)
	signal.signal(signal.SIGINT, exit_gracefully)
	subprocess.call(["mkdir", "-p", "/home/thewisenerd/logs"])
	file_name = datetime.datetime.now().strftime("/home/thewisenerd/logs/log_%d%b_%H-%M.txt")
	def_file = "/home/thewisenerd/logs/zzz_last.txt"
	if os.path.isfile(file_name):
		file_name = datetime.datetime.now().strftime("/home/thewisenerd/logs/log_%d%b_%H-%M-%S.txt")
	server_start = time.time()
	subprocess.call("adb logcat | tee %s" % def_file, shell=True)
