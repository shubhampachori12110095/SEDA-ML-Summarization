#!/bin/sh

#  load_data.sh
#  
#
#  Created by Hobey Kuhn on 11/18/13.
#


SOLR_XML_DIR="../data/solr_xml_files"
SOLR_CONFIG_DIR="/home/vagrant"




# configure path to json files
# NOTE: DUC PATH NOT CONFIGURED
if [ "${1}" = "Australia" ]; then
    # Obtains and unzips the Australian dataset if not alraedy present
    echo "Retrieving dataset..."
    sh getAustralianDataset.sh
    data_path="../data/corpus/fulltext/*"

else
    echo "Invalid input in command line. Please read the README to learn how to use this script!"
    exit
fi

# INDEXING:
# Parse XML for SOLR Format
if [ -d "$SOLR_XML_DIR" ]; then
    echo "skipping conversion..."
else
    mkdir "$SOLR_XML_DIR"
    echo "Converting files into a format compatible with SOLR"
    for f in ${data_path}
    do
        filename=`basename "${f}"`
    if [ "${1}" = "Australia" ]; then
        python australia_xml_parser.py "${f}" "${SOLR_XML_DIR}/${filename}"
    fi
    done
fi

# PUT data from path onto SOLR
echo "Posting files to SOLR"

# moving core configuration to hard dir
cp -a "solr_config" "${SOLR_CONFIG_DIR}"

if [ "${1}" = "Australia" ]; then
    if [ -e "${SOLR_CONFIG_DIR}/solr_config/collection1/core.properties" ]; then
        # skip creating new core
        echo "Core already exists... If you are creating a new core, please clear the old one before posting!"
	exit
    else
        # create new core
        echo "Building new SOLR core..."
        curl "http://localhost:8983/solr/admin/cores?action=CREATE&name=AustralianDataset&instanceDir=/home/vagrant/solr_config/collection1"
    fi
    # post files to core
    java -Durl=http://localhost:8983/solr/AustralianDataset/update -jar post.jar "${SOLR_XML_DIR}/*.xml"
fi



