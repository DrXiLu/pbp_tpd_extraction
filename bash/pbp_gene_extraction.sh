#!/bin/bash

## Shell script to extract pbp genes from a list of gffs and fastas

set -e
echo "This is the gff list $1"
echo "This is the fasta list $2"
echo "This is the out csv name $3"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
parentdir="$(dirname "$DIR")"
pythondir="${parentdir}/python/"
rdir="${parentdir}/R/"
datadir="${parentdir}/data/"
read -p "Are you sure (Y/N)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Nn]$ ]]
then
    echo "exiting script now"
  else
    ## Lets run through the pbp gene getting pbp1a, 2b 2x
  echo "Extracting pbp1a/ponA now"
  python "${pythondir}pen_checker_cdc.py" \
  $1 $2 "pbp1A" "ponA" "${datadir}pbp1a.faa" 2159 pbp1a_cdc_mic_type.csv

  echo "Extracting pbp2b/penA now"
  python "${pythondir}pen_checker_cdc.py" \
  $1 $2 "pbp2B" "penA" "${datadir}pbp2b.faa" 2042 pbp1a_cdc_mic_type.csv

  echo "Extracting pbp2x/pbpX now"
  python "${pythondir}pen_checker_cdc.py" \
  $1 $2 "pbp2x" "pbpX" "${datadir}pbp2x.faa" 2252 pbp1a_cdc_mic_type.csv

  ## Create the lists of prots for the Rscript to work on

  ls -d $PWD/*pbp1A.prot > pbp1a_prot_list
  ls -d $PWD/*pbp2b.prot > pbp2b_prot_list
  ls -d $PWD/*pbp2x.prot > pbp2x_prot_list

  ## Lets run the Rscript

  Rscript --vanilla "${rdir}AA_df_creator.R" \
  pbp1a_prot_list pbp2b_prot_list pbp2x_prot_list $3
fi




