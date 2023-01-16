#!/bin/bash

RED=$'\e[1;31m'
GREEN=$'\e[1;32m'
DEFAULT_COLOR=$'\e[0m'

REGEX_INT='^[0-9]$'

if [[ -z "$1" ]]
then
	echo "${RED}No input file given$DEFAULT_COLOR" 
	exit 2
fi 

if [[ ! -f "$1" ]]
then
	echo "${RED}File does not exist$DEFAULT_COLOR"
	exit 2
fi

INPUT_FILE=$1			#arg1 =  path to csv file
INPUT_FILE_TRIMMED=$(echo "$INPUT_FILE" | cut -f 1 -d '.')
INPUT_FILE_LENGTH=$(cat "$INPUT_FILE" | wc -l | xargs) 

read -p "Line to start (default 1): " START

if [[ -z "$START" ]]
then
    START=1			#line to start (default=1)
elif [[ ! $START =~ $REGEX_INT ]] || [[ $START -lt 1 ]]				#check for integer and input > 0
then
	echo "${RED}Invalid input$DEFAUL_COLOR"
	exit 2
fi

read -p "Line to end (default ${INPUT_FILE_LENGTH}): " END

if [[ -z "$END" ]]
then
	END=$INPUT_FILE_LENGTH 		#line to end (default=last line in input file)
elif [[ ! $END =~ $REGEX_INT ]] || [[ $START -gt $INPUT_FILE_LENGTH ]]		#check for integer and input <= input file length
then
    echo "${RED}Invalid input$DEFAUL_COLOR"
    exit 2
fi

VOICE_1=$2			#arg2 = voice for language 1
VOICE_2=$3			#arg3 = voice for language 2

OUTPUT_FORMAT=$4    		#arg4 = optional output format [mp3]

FILECOUNT=1
COUNTER=$START      		#counter caounts from start value

IFS_DEFAULT=$IFS    		#store default seperator
IFS=","             		#use comma as seperator

TMP_FOLDER="tmp-${INPUT_FILE_TRIMMED}-${START}-${END}"
TMP_FILE="input-${START}-${END}.csv"		#temp csv file for parsing


rm -rf ${TMP_FOLDER}		#delete old tempfolder if needed
mkdir -p ${TMP_FOLDER}		#create temp folder

echo "${GREEN}Parsing $(($END-$START+1)) lines from ${INPUT_FILE}$DEFAULT_COLOR"
 
#create parsed csv file with only the first two columns and the sleceted rows
awk -F, 'NR=='$START' ,NR=='$END' { print $1","$2}' $INPUT_FILE>"${TMP_FOLDER}/${TMP_FILE}"

while read col1 col2		#read both columns from temp file
do
    say -v $VOICE_1 $COUNTER"[[ slnc 1000 ]]" $col1 "[[ slnc 1000 ]]" -o "${TMP_FOLDER}/$(printf %05d $FILECOUNT).${COUNTER}.lang1.aiff"
    let FILECOUNT+=1
    say -v $VOICE_2 $col2 "[[ slnc 5000 ]] "  -o "${TMP_FOLDER}/$(printf %05d $FILECOUNT).${COUNTER}.lang2.aiff"
    let FILECOUNT+=1
    let COUNTER+=1
done< "${TMP_FOLDER}/${TMP_FILE}"

IFS=$IFS_DEFAULT

sox $(ls ${TMP_FOLDER}/*.aiff | sort -n) "${INPUT_FILE_TRIMMED}-${START}-${END}.wav"

if [[ "$OUTPUT_FORMAT" = "mp3" ]]
then 
    ffmpeg -hide_banner -loglevel error -i "${INPUT_FILE_TRIMMED}-${START}-${END}.wav" "${INPUT_FILE_TRIMMED}-${START}-${END}.mp3"
    rm "${INPUT_FILE_TRIMMED}-${START}-${END}.wav"
fi
