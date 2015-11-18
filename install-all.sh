#!/bin/bash

osacompile -o chrome-refresh.scpt chrome-refresh.applescript 
osacompile -o safari-refresh.scpt safari-refresh.applescript 

cp Watcher-*.workflow ~/Library/Services/
