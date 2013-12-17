#!/bin/bash

# Get the directory of this script to use in reference to
SCRIPT_PATH=$( cd $(dirname $0) ; pwd -P )

ROUGE_FILE_NAME="ROUGE-1.5.5.tgz"
ROUGE_URL="https://www.dropbox.com/s/plcw48pi0rjzkge/${ROUGE_FILE_NAME}"
DOT_ROUGE_INSTALLED=".rougeinstalled"

if [ ! -f "${DOT_ROUGE_INSTALLED}" ]; then
	echo "Installing ROUGE.\n"

	echo "${ROUGE_URL}" -O "${SCRIPT_PATH}/${ROUGE_FILE_NAME}"
	wget "${ROUGE_URL}" -O "${SCRIPT_PATH}/${ROUGE_FILE_NAME}"

	perl -MCPAN -e 'force install XML::DOM'

	tar -zxvf "${ROUGE_FILE_NAME}"

	rm "${ROUGE_FILE_NAME}"

	touch "${DOT_ROUGE_INSTALLED}"
else
	echo "Rouge installed.\n"
fi
