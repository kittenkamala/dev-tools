#!/bin/bash 
### WIP ###
source ./env-vars.sh

##Wake up Environment | Auth Dashboard user sess"
terminus env:wake $SITE.$ENV
terminus auth:login --email=$EMAIL

## MYSQL Health Checks ##

echo "MySQL Health Checks" > wp-db-checks-$SITE.txt
## Show current sql processes and their status ##
echo "-- Process List --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="show full processlist;" >> wp-db-checks-$SITE.txt
## Spit out MyISAM Tables ##
echo "-- InnoDB Tables --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="show table status where engine = 'innodb';" >> wp-db-checks-$SITE.txt
## Spit out MyISAM Tables ##
echo "-- MyISAM Tables --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="show table status where engine = 'myisam';" >> wp-db-checks-$SITE.txt
##check for deadlocks##
echo "-- Deadlocks --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="SHOW ENGINE INNODB STATUS;" >> wp-db-checks-$SITE.txt
## mysqlcheck ##
mysqlcheck -c -a -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB >> wp-db-checks-$SITE.txt #check and analyze db tables database for corruption -  anlyze locks table instead of duplicating

## WordPress Specific database bloat checks ##
echo "MySQL Bloat Checks" > wp-db-checks-$SITE.txt
echo "-- wp_options wp_sessions rows --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_options where option_name LIKE '%_wp_session_%';" >> wp-db-checks-$SITE.txt
echo "-- wp_options autoloads --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="SELECT * FROM ${DB_PREFIX}_options WHERE autoload LIKE 'yes';" >> wp-db-checks-$SITE.txt
echo "-- wp_options autoload transients --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="SELECT * FROM ${DB_PREFIX}_options WHERE autoload = 'yes' AND option_name like '%transient%';" >> wp-db-checks-$SITE.txt
echo "-- post revisions --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_posts where post_type = 'revision';" >> wp-db-checks-$SITE.txt
echo "-- trash posts --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_posts where post_status = 'trash';" >> wp-db-checks-$SITE.txt
echo "-- expired relationships --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from from ${DB_PREFIX}_term_relationships where _term_taxonomy_id=1 and object_id not in (select id from $DB_PREFIX_posts);" >> wp-db-checks-$SITE.txt
echo "--  stale post meta --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_postmeta as m left join prefix_posts as p on m.post_id = p.id where p.id is null;" >> wp-db-checks-$SITE.txt
echo "-- spam posts --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_comments where comment_approved = 'spam';" >> wp-db-checks-$SITE.txt
echo "-- trash comments --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_comments where comment_approved = 'trash';" >> wp-db-checks-$SITE.txt
echo "-- pingbacks --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_comments where comment_approved = 'pingback';" >> wp-db-checks-$SITE.txt
echo "-- unapproved comments --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_comments where comment_approved = '0';" >> wp-db-checks-$SITE.txt
#expired woo sessions#
echo "-- expired woo sessions --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute=";" >> wp-db-checks-$SITE.txt
#check for indexes
#check charset 
#show autoload details
#add Lindsey's checks from confluence

