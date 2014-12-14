#!/bin/bash

BIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DISTANCE=$1
INPUT_ROOT="$PWD/$2"
LIST_FILE="$PWD/$3"
OUTPUT_ROOT="$PWD/$4"

if [ ! -d $OUTPUT_ROOT ]; then
  mkdir -p $OUTPUT_ROOT
fi

if [ ! -d $INPUT_ROOT ]; then
  echo "Could not find PDB files in the path specified ($INPUT_ROOT)."
  exit 1
fi

Files=`ls $INPUT_ROOT/`

for File in $Files
do
  Row=`grep ${File:0:4} $LIST_FILE`
  echo $ADDR
  while IFS=' ' read -ra ADDR; do
    for i in "${ADDR[@]}"; do
      Filename="$Row.graph"
      echo "**************************** Processing  $Filename ****************************"
      $BIN_DIR/pdbtograph.py -a CA -d $DISTANCE $INPUT_ROOT/$File $OUTPUT_ROOT/$Filename
    done
  done <<< "$Row"
done
