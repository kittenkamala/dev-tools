#!/bin/bash 
### WIP ###
source ./env-vars.sh


## db security checks ##
# sql query for base_64, <script  in _options _post _postmeta _comments

#check db for corruption 

###wp cli checks + checksums probably should use terminus
terminus wp $SITE.$ENV core verify-checksums #todo add those env vars to env-vars.sh
terminus wp $SITE.$ENV plugin verify-checksums --all
terminus wp $SITE.$ENV option get siteurl
terminus wp $SITE.$ENV option get home

#WPScan for vulnerabilities and hacks
wpscan --url $DOMAIN --api-token $WPS_TOKEN