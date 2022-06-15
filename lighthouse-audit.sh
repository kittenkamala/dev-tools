#!/bin/bash 
### WIP ###
source ./env-vars.sh

lighthouse $URL --output html --output-path ./lighthouse-audit-$SITE.html