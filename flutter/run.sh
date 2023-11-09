#!/bin/bash
###########################################
# run.sh
#
# Script to run flutter against a local engine.
###########################################
PATH_TO_ENGINE=${FLUTTER_ENGINE}
bold=$(tput bold)
normal=$(tput sgr0)
opts=()
builds=()

function prompt() {
  echo "Choose an engine to run:"
  i=0
  dir="${PATH_TO_ENGINE}/out"
  for f in "$dir"/* 
  do
    file_name=$(basename ${f})
    if [[ "$file_name" != "host_"* ]]; then
      option=$((i+1))
      echo "${bold}${option})${normal} ${file_name}"
      opts[$((i))]=$option
      builds[$((i))]=$file_name
      i=$((i + 1))      
    fi
  done
  echo "${bold}q)${normal} quit"
  read -n1 -p "Enter choice (q to quit): " choice

  if [[ ${choice} == "q" ]]; then
    echo -e "\nQuitting."
    exit 0
  elif [[ " ${opts[*]} " = *" $choice "* ]]; then
    BUILD=${builds[$((choice - 1))]}
  else
    echo -e "\nChoice must be either 1, 2, or q. Exiting."
    exit 1
  fi
}

while getopts 'p:h' arg; do
  case "$arg" in
    p)
      PATH_TO_ENGINE="${OPTARG}"
      ;;
    h)
      echo "usage: $(basename $0) [-p (optional path to engine, defaults to \$FLUTTER_ENGINE)]"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if [ -z "${PATH_TO_ENGINE}" ]; then
  echo "You must either set the \$FLUTTER_ENGINE environment variable to the path of your engine or run again with -p"
  exit 1
fi

prompt
echo -e "\nflutter run --local-engine-src-path $PATH_TO_ENGINE --local-engine=$BUILD"
flutter run --local-engine-src-path $PATH_TO_ENGINE --local-engine=$BUILD
