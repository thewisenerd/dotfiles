#!/usr/bin/perl
# StripANSI .. remove ANSI codes from stdin
# Also removes removes backspace bolds and BitchX IRC ^B's
while(<>){s/\e\[[\d;]*.//g;s/(.)\cH\1/$1/g;s/\cB//g;print;}
