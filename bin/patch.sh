#!/bin/bash
wget $1.diff --output-document=patch.diff;
patch -p1 <./patch.diff
rm ./patch.diff

