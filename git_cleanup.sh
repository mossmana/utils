#!/bin/sh
######################################################
# git-cleanup.sh
#
# Convenience script for deleting local git branches
######################################################
arr=($(git branch))
len=${#arr[@]}
if [[ ${len} > 0 ]]; then
   while :
   do
      i=1
      echo "-----------------"
      echo "Choose branch(es)"
      echo
      echo " e.g. 1,5,7-10"
      echo "-----------------"
      for (( j=0; j<${len}; j+=1 )); do
         echo "   $i) ${arr[j]}"
         options[i]=${arr[j]}
         i=$((i+1))
      done
      read -p "Options: " opt
      re='^[0-9]+([,|-]?[0-9]+)*$'
      if [[ $opt =~ $re ]]; then
         shopt -s nocasematch
         IFS=',' read -a selections <<< "$opt"
         for selection in "${selections[@]}"
         do
            if [[ $selection == *"-"* ]]; then
               IFS='-' read -a range <<< "$selection"
               for (( k=${range[0]}; k<=${range[${#range[@]}-1]}; k++)); do
                  branch=${arr[$k-1]}
                  read -p "Delete $branch (y/n)? " confirm
                  if [[ $confirm =~ (y|yes) ]]; then
                     echo "git branch -D $branch"
                     git branch -D $branch
                     echo
                  fi
               done
            else
               branch=${arr[$selection-1]}
               read -p "Delete $branch (y/n)? " confirm
               if [[ $confirm =~ (y|yes) ]]; then
                  echo "git branch -D $branch"
                  git branch -D $branch
                  echo
               fi
            fi
         done
         break
      fi
      echo "Please enter a valid input."
      sleep 1
   done
else
   echo "No branches detected."
   exit 1
fi

exit 0 

