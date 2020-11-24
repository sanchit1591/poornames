# poornames
Wrote a bash script to filter out poorly named files in a directory recursively

Specifications taken into consideration:- 
1) A file name component must contain only ASCII letters, ‘.’, ‘-’, and ‘_’.
2) A file name component cannot start with ‘-’.
3) Except for ‘.’ and ‘..’, a file name component cannot start with ‘.’.
4) A file name component must not contain more than 14 characters.
5) No two files in the same directory can have names that differ only in case.
