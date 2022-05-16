
#!/bin/bash 
### WIP ###
source ./env-vars.sh

#use terminus to run 
#add vars to env


## wp cli checks ##
terminus wp $SITE.$ENV -- db size --size_format=mb #get db size
terminus wp $SITE.$ENV -- plugin list #get plugin details
terminus wp $SITE.$ENV -- theme list #get theme details
terminus wp $SITE.$ENV -- core version
terminus wp $SITE.$ENV -- core verify-checksums
terminus wp $SITE.$ENV -- plugin verify-checksums --all
#check for transients
#check cron health