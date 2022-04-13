#!/bin/bash 
### WIP ###
source ./env-vars.sh

## MYSQL Health Checks ##
mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P 13727 $MYSQL_DATABASE --execute="
show full processlist;
show table status where engine = 'innodb';
show table status where engine = 'myisam';" > test.txt

##WP Specific db bloat checks##
mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -h $MYSQL_HOST -P 13727 $MYSQL_DATABASE --execute="
select * from $MYSQL_DB.$DB_PREFIX_options where option_name like '_wp_session_%';
SELECT * FROM $DB_PREFIX_options WHERE autoload = 'yes';
SELECT * FROM $DB_PREFIX_options WHERE autoload = 'yes' AND option_name like '%transient%';
select * from $DB_PREFIX_posts where post_type = 'revision';
select * from $DB_PREFIX_posts where post_type = 'trash';
select * from from $DB_PREFIX_term_relationships where _term_taxonomy_id=1 and object_id not in (select id from $DB_PREFIX_posts);
select * from $DB_PREFIX_postmeta as m left join prefix_posts as p on m.post_id = p.id where p.id is null;
select * from $DB_PREFIX_comments  where comment_approved = 'spam';
select * from $DB_PREFIX_comments  where comment_approved = 'trash';
select * from $DB_PREFIX_comments  where comment_approved = 'pingback';
select * from $DB_PREFIX_comments  where comment_approved = '0';
" > db-checks.txt
##check for deadlocks##
#expired woo sessions#
#check for indexes
#check charset 

## mysqlcheck ##
mysqlcheck -c $SQL_DB  -u $SQL_USER -p$SQL_PASS #check database for corruption
mysqlcheck -c $SQL_DB  -u $SQL_USER -p$SQL_PASS #analyze db, this is better bc it locks table instead of duplicating
