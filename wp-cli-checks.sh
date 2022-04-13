
#!/bin/bash 
### WIP ###
source ./env-vars.sh

#use terminus to run 
#add vars to env


## wp cli checks ##
terminus wp $DOMAIN.$ENV db size --size_format=mb #get db size
terminus wp $DOMAIN.$ENV plugin list #get plugin details
terminus wp $DOMAIN.$ENV theme list #get theme details
terminus wp $DOMAIN.$ENV core version
#check for transients
#check cron health