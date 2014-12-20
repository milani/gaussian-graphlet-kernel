#!/bin/bash

INPUT_LIST="$1"
OUTPUT_ROOT="$2"

while getopts ":h" opt; do
  case $opt in
    h)
      echo "usage: pdbdownloader.sh dataset output_root_directory" >&2
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

if [ ! -s "$INPUT_LIST" ]; then
	echo "Dataset is empty or does not exists."
	exit 1
fi

if [ "$OUTPUT_ROOT" == "" ]; then
	echo "Output directory is not set."
	exit 1
fi

if [ ! -d "$OUTPUT_ROOT" ]; then
  mkdir -p $OUTPUT_ROOT
fi

# Read file lines into LIST array
IFS=$'\n'
set -f
LIST=(`cat $INPUT_LIST -T`)

# Ignore header of the list and loop through the items
for LINE in "${LIST[@]:1}"
do
	`cd $OUTPUT_ROOT && wget http://www.rcsb.org/pdb/files/${LINE:0:4}.pdb.gz`
done
