
#!/bin/bash 
### WIP ###
source ./env-vars.sh

#use terminus to run 
#add vars to env


## wp cli checks ##
echo "-- wp_options siteurl value --" > wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- option get siteurl >> wpcli-audit-$SITE.txt
echo "-- wp_options home url value --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- option get home >> wpcli-audit-$SITE.txt
echo "-- wp core version --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- core version >> wpcli-audit-$SITE.txt
echo "-- checksums for wp core integrity --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- core verify-checksums >> wpcli-audit-$SITE.txt
echo "-- wp_content directory file path --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- eval 'echo WP_CONTENT_DIR;' >> wpcli-audit-$SITE.txt #get wp-content dir file path 
echo "-- wp-config.php file path --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- config path >> wpcli-audit-$SITE.txt #spit out wp-config.php file path
echo "-- wp-config.php values --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- config list >> wpcli-audit-$SITE.txt #spit out wp-config values
echo "-- installed plugins --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- plugin list >> wpcli-audit-$SITE.txt #get plugin details
echo "-- checksums for plugin integrity --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- plugin verify-checksums --all >> wpcli-audit-$SITE.txt #verify plugin checksums
echo "-- installed themes --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- theme list  >> wpcli-audit-$SITE.txt #get theme details
echo "-- admin users --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- user list | grep administrator >> wpcli-audit-$SITE.txt #get admin user list
echo "-- wp-cron test --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- cron test >> wpcli-audit-$SITE.txt #verify wp-cron is working
echo "-- wp-cron event list --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- cron event list >> wpcli-audit-$SITE.txt #check wp-cron status
echo "-- what object cache is in place --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- cache type >> wpcli-audit-$SITE.txt #get type of object cache
echo "-- database size in MB --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- db size --size_format=mb >> wpcli-audit-$SITE.txt #get db size
echo "-- tables in database --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- db tables >> wpcli-audit-$SITE.txt #list db tables
echo "-- database corruption--" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- db check >> wpcli-audit-$SITE.txt #check db for corruption
echo "-- wp_options list of all options --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- option list >> wpcli-audit-$SITE.txt #spit out options in db
echo "-- wp_options autoload count --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- option list --autoload=on --format=total_bytes >> wpcli-audit-$SITE.txt #get size of all autoloads
echo "--wp_options largest transients --" >> wpcli-audit-$SITE.txt
terminus wp $SITE.$ENV -- option list --search="*_transient_*" --fields=option_name,size_bytes | sort -n -k 2 | tail >> wpcli-audit-$SITE.txt #find biggest transients