#!/bin/bash

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "Error: Missing Arguments"
    echo "Usage: $0 <projectName> <topDesignName>"
    exit 1
fi

# Arguments
projectName=$1
topDesignName=$2

# Create directories
mkdir -p $projectName/dig/cons
mkdir -p $projectName/dig/rtl
mkdir -p $projectName/conf
mkdir -p $projectName/syn/cons
mkdir -p $projectName/syn/script
mkdir -p $projectName/pnr/script

# Create links and files
ln -s /path/to/pdk/ $projectName/pdk 
ln -s ../../dig/cons/${topDesignName}_constraints.tcl $projectName/syn/cons/${topDesignName}_constraints.tcl

# Copy configuration file 
cp ./create_project_area/conf.tcl $projectName/conf/conf.tcl
# Copy synthesis scripts
cp ./create_project_area/script/syn/Makefile $projectName/syn/script/Makefile
cp ./create_project_area/script/syn/syn_script.tcl $projectName/syn/script/syn_script.tcl
# Copy pnr scripts
cp ./create_project_area/script/pnr/Makefile $projectName/pnr/script/Makefile
cp ./create_project_area/script/pnr/fp.tcl $projectName/pnr/script/fp.tcl
cp ./create_project_area/script/pnr/power.tcl $projectName/pnr/script/power.tcl
cp ./create_project_area/script/pnr/place.tcl $projectName/pnr/script/place.tcl

cat <<EOF 
Project $projectName created successfully
Please do the following: 
    copy the rtl files to dig/rtl/
    copy digital constraints file to dig/cons/
    change pdk link to the right parent folder
EOF

