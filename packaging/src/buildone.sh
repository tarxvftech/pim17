#!/bin/sh
cd $1
abuild checksum
abuild -r
cd -
