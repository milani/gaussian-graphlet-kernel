#!/bin/bash

INPUT_LIST="$1"
OUTPUT_ROOT="$2"

if [ ! -d $OUTPUT_ROOT ]; then
  mkdir -p $OUTPUT_ROOT
fi

LIST=`cat $INPUT_LIST`

for LINE in $LIST
do
	`cd $OUTPUT_ROOT && wget http://www.rcsb.org/pdb/files/${LINE:0:4}.pdb.gz`
done
