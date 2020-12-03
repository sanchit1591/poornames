
#!/usr/bin/bash

# CS 35L HOMEWORK (ASSIGNMENT 3)
# Created By - Sanchit Agarwal

find_nr ( ) {
   # filter all the invalid files
   # last grep in invalid files is for 14 letter directories
   invalid_files=$(echo "$1" | xargs -d "\n" ls -A -1 -p -N --show-control-chars |
                   grep -E ".{15,}|[^A-Za-z._/-]|^\.|^-" |
                   grep -E -v "^[A-Za-z_][A-Za-z_./-]{13}\/")
   
   # filter all the valid files with duplicate names
   valid_files=$(find "$1" -mindepth 1 -maxdepth 1 |
                   grep -E "\/[A-Za-z._/-]{1,14}$" |
                   grep -E -v "\/\.|\/-" | sort -f | uniq -iD)
   IFS=$'\n'

   # iterate over invalid files
   # append a "/" to input directory if not supplied with a "/"
   for i_file in $invalid_files;
   do
       if [[ "$1" =~ \/$ ]]; then
           echo "${1}${i_file}"
       else
           echo "${1}/${i_file}"
       fi
   done
   
   # iterate over the valid files
   # if a file is a directory -> append a "/" to it 
   for v_file in $valid_files;
   do
       if [ -d ${v_file} ]; then
           echo "${v_file}/"
       else
           echo "$v_file"
       fi
   done
}


find_r ( ) {
 dirs=$(find $1 -type d)
 IFS=$'\n'
 for dir in $dirs; do
     find_nr $dir
 done
}

r="f"

if [ $# -eq 0 ]; then
    if [ -r "." ]; then
        find_nr "."
    else
        echo "This directory cannot be read!" 1>&2
    fi
fi


if [ "$1" = "-r" ]; then
    r="t"
    shift
fi

if [ $# -eq 0 ]; then
    if [ -r "." ]; then
        find_r "."
    else
        echo "This directory cannot be read!" 1>&2
    fi
elif [ $# -ge 2 ]; then
    echo "Invalid Arguments!" 1>&2
    exit 1
elif [[ "$1" =~ ^-.* ]]; then
    echo "Invalid Argument starting with "-"" 1>&2
    exit 1
elif [ -L "$1" ]; then
    echo "Given argument is not a directory" 1>&2
    exit 1
elif [ -d "$1" ]; then
    if [ -r "$1" ]; then
        if [ $r = "f" ]; then
            find_nr "$1"
        elif [ $r = "t" ]; then
            find_r "$1"
        fi
    elif [ ! -r "$1" ]; then
        echo "This directory cannot be read!" 1>&2
    fi
elif [ ! -d "$1" ]; then
    echo "Given argument is not a directory" 1>&2
    exit 1
else
    echo "Missed a case!" 1>&2
 fi
