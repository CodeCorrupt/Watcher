#!/bin/bash

# Process Arguments
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
ruby=0
service=0

function usage {
    echo "Usage: $0 -[h|?] -[r|s|b]"
    echo ""
    echo "  -h/?:   Show this help message"
    echo ""
    echo "  -r:     Install the ruby script."
    echo "            Ruby script can be run in a terminal session to do the same as the service."
    echo "              run \"./watcher.rb\" for assistance."
    echo ""
    echo "  -s:     Install the workflow service."
    echo "            This will allow you to right click on the folder you want to watch."
    echo "            From there, at the bottome select \"Services\" and choose"
    echo "            Watcher-Safari or Watcher-Chrome depending on the browser you use."
    echo "            From there you enter the keyword in the URL of pages to refresh."
    echo "              ie: \"localhost\""
    echo ""
    echo "  -b      Install both Ruby and Services"
}

# If there are no arguments then print usage
if [ "$#" -lt 1 ]
then
    usage
    exit
fi

# Read in arguments
while getopts "h?rsb" opt; do
    case "$opt" in
        h|\?)
            usage
            exit
            ;;  
        r)  ruby=1
            ;;  
        s)  service=1
            ;;  
        b)  ruby=1
            service=1
            ;;  
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

# Actual code...

if [ "$ruby" -eq "1" ]
then
    echo "Installing Ruby script"
    osacompile -o chrome-refresh.scpt chrome-refresh.applescript 
    osacompile -o safari-refresh.scpt safari-refresh.applescript 
fi

if [ "$service" -eq "1" ]
then
    echo "Installing Services"
    cp -r Watcher-*.workflow ~/Library/Services/
fi
