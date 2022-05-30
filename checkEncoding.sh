#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
set -o noclobber

function validate_localization(){

	echo "--------------------------------------------------------------------------------------------------------------------------------"
	declare -i TOTAL=0
	declare -i GOOD=0
	declare -i BAD=0
	
	for f in ./localisation/*.yml
	do
		if [ "$(file -b --mime-encoding "$f")" = utf-8 ];then
			# echo -e "${GREEN}{$f} encoding is good.${NC}"
			GOOD+=1
		else
			echo -e "${RED}{$f} encoding is wrong!${NC}"
			file -i $f
			BAD+=1
		fi
		  TOTAL+=1
	done
	echo -e "\n		${GREEN}${GOOD}${NC}/${TOTAL} localization files encoding validated.\n"
	if [[ $BAD > 0 ]]; then
		echo -e "\n		${RED}${BAD}${NC}/${TOTAL} ${RED}decicion files have a wrong or unknown encoding!${NC}\n"
		exit 1
	fi
}

function validate_events(){
	
	echo "--------------------------------------------------------------------------------------------------------------------------------"
	declare -i TOTAL=0
	declare -i GOOD=0
	declare -i NEUTRAL=0
	declare -i BAD=0
	
	for f in ./events/*.txt
	do
		if [ "$(file -b --mime-encoding "$f")" = us-ascii ];then
			# echo -e "${GREEN}{$f} encoding is good.${NC}"
			GOOD+=1
		elif [ "$(file -b --mime-encoding "$f")" = iso-8859-1 ]; then
			# echo -e "${YELLOW}{$f} encoding is in european ascii!${NC}"
			GOOD+=1
			NEUTRAL+=1
		elif [ "$(file -b --mime-encoding "$f")" = unknown-8bit ]; then
			echo -e "${YELLOW}{$f} encoding is unknown!${NC}"
			file -i $f
			GOOD+=1
			NEUTRAL+=1
		else
			echo -e "${RED}{$f} encoding is wrong!${NC}"
			file -i $f
			BAD+=1
		fi
		  TOTAL+=1
	done
	
	echo -e "\n		${GREEN}${GOOD}${NC}/${TOTAL} ${GREEN}event files encoding validated.${NC}\n"
	if [[ $NEUTRAL > 0 ]]; then
		echo -e "\n		${YELLOW}${NEUTRAL}${NC}/${TOTAL} ${YELLOW}event files encoding are in european ascii or unknown.${NC}\n"
	fi
	if [[ $BAD > 0 ]]; then
		echo -e "\n		${RED}${BAD}${NC}/${TOTAL} ${RED}event files have a wrong encoding!${NC}\n"
		exit 1
	fi
}

function validate_decisions(){
	
	echo "--------------------------------------------------------------------------------------------------------------------------------"
	declare -i TOTAL=0
	declare -i GOOD=0
	declare -i NEUTRAL=0
	declare -i BAD=0
	
	for f in ./decisions/*.txt
	do
		if [ "$(file -b --mime-encoding "$f")" = us-ascii ];then
			# echo -e "${GREEN}{$f} encoding is good.${NC}"
			GOOD+=1
		elif [ "$(file -b --mime-encoding "$f")" = iso-8859-1 ]; then
			echo -e "${YELLOW}{$f} encoding is in european ascii!${NC}"
			file -i $f
			GOOD+=1
			NEUTRAL+=1
		elif [ "$(file -b --mime-encoding "$f")" = unknown-8bit ]; then
			echo -e "${YELLOW}{$f} encoding is unknown!${NC}"
			file -i $f
			GOOD+=1
			NEUTRAL+=1
		else
			echo -e "${RED}{$f} encoding is wrong!${NC}"
			file -i $f
			BAD+=1
		fi
		  TOTAL+=1
	done
	
	echo -e "\n		${GREEN}${GOOD}${NC}/${TOTAL} ${GREEN}decision files encoding validated.${NC}\n"
	if [[ $NEUTRAL > 0 ]]; then
		echo -e "\n		${YELLOW}${NEUTRAL}${NC}/${TOTAL} ${YELLOW}decision files encoding are in european ascii or unknown.${NC}\n"
	fi
	if [[ $BAD > 0 ]]; then
		echo -e "\n		${RED}${BAD}${NC}/${TOTAL} ${RED}decision files have a wrong encoding!${NC}\n"
		exit 1
	fi
}

function help_function()
{
   echo ""
   echo "Usage: $0 -e -l -d"
   echo -e "\t-e Check events folder files encoding"
   echo -e "\t-l Check localization folder files encoding"
   echo -e "\t-d Check decisions folder files encoding"
   exit 1
}

while getopts "eld" opt
do
	case "$opt" in
		e ) validate_events ;;
		l ) validate_localization ;;
		d ) validate_decisions ;;
		: ) help_function ;;
		\? ) help_function ;;
	esac
done
