#!/bin/bash

IFS_DEFAULT=$IFS    #store default seperator
INPUT_FILE=$1       #arg1 =  path to csv file
INPUT_FILE_TRIMMED=$(echo "$INPUT_FILE" | cut -f 1 -d '.')
START=$2            #line to start
END=$3              #line to end
FILECOUNT=1
COUNTER=$START      #counter caounts from start value
IFS=","             #use comma as seperator
TMP_FOLDER="tmp-${INPUT_FILE_TRIMMED}-${START}-${END}"
TMP_FILE="input-${START}-${END}.csv"   #temp csv file for parsing


rm -rf ${TMP_FOLDER}    #delete old tempfolder if needed
mkdir -p ${TMP_FOLDER}  #create temp folder
 
#create parsed csv file with only the first two columns and the sleceted rows
awk -F, 'NR=='$START' ,NR=='$END' { print $1","$2}' $INPUT_FILE>"${TMP_FOLDER}/${TMP_FILE}"

while read col1 col2    #read both columns from temp file
do
    say -v Anna $COUNTER"[[ slnc 1000 ]]" $col1 "[[ slnc 1000 ]]" -o "${TMP_FOLDER}/$(printf %05d $FILECOUNT).${COUNTER}.en.aiff"
    let FILECOUNT+=1
    say -v Kanya $col2 "[[ slnc 7000 ]] "  -o "${TMP_FOLDER}/$(printf %05d $FILECOUNT).${COUNTER}.th.aiff"
    let FILECOUNT+=1
    let COUNTER+=1
done< "${TMP_FOLDER}/${TMP_FILE}"

IFS=$IFS_DEFAULT

sox $(ls ${TMP_FOLDER}/*.aiff | sort -n) "${INPUT_FILE_TRIMMED}-${START}-${END}.wav"
ffmpeg -i "${INPUT_FILE_TRIMMED}-${START}-${END}.wav" "${INPUT_FILE_TRIMMED}-${START}-${END}.mp3"
