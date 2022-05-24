#!/bin/bash 
### WIP ###
source ./env-vars.sh

### Wake up Environment | Auth Dashboard user sess" ###
echo "<b>Waking up Environment</b>" 
terminus env:wake $SITE.$ENV
terminus auth:login --email=$EMAIL

### MYSQL Health Checks ###
echo "Health Checks"  && echo "MySQL Health Checks" > wp-db-checks-$SITE.txt
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
mysqlcheck -a -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB >> wp-db-checks-$SITE.txt #check and analyze db tables database for corruption -  anlyze locks table instead of duplicating

### WordPress Specific database bloat checks ###
echo "Bloat Checks" && echo "MySQL Bloat Checks" >> wp-db-checks-$SITE.txt
## Options Autoload data
echo "-- wp_options all autoloads --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="SELECT * FROM ${DB_PREFIX}_options WHERE autoload LIKE 'yes';" >> wp-db-checks-$SITE.txt
#largest autoloads
echo "-- wp_options largest autoloads --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="SELECT LENGTH(option_value),option_name FROM ${DB_PREFIX}_options WHERE autoload='yes' ORDER BY length(option_value) DESC LIMIT 500;" >> wp-db-checks-$SITE.txt
#autoload transients
echo "-- wp_options autoload transients --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="SELECT * FROM ${DB_PREFIX}_options WHERE autoload = 'yes' AND option_name like '%transient%';" >> wp-db-checks-$SITE.txt

## WP Specific Post tables bloat checks
echo "Posts bloat checks"
#revisions
echo "-- post revisions --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_posts where post_type = 'revision';" >> wp-db-checks-$SITE.txt
#trash
echo "-- trash posts --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_posts where post_status = 'trash';" >> wp-db-checks-$SITE.txt
#stale relationships and post meta
echo "-- stale relationships --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from from ${DB_PREFIX}_term_relationships where _term_taxonomy_id=1 and object_id not in (select id from ${DB_PREFIX}_posts);" >> wp-db-checks-$SITE.txt
echo "--  stale post meta --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_postmeta as m left join ${DB_PREFIX}_posts as p on m.post_id = p.id where p.id is null;" >> wp-db-checks-$SITE.txt
#spam
echo "-- spam posts --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_comments where comment_approved = 'spam';" >> wp-db-checks-$SITE.txt
##Comments
#trash
echo "-- trash comments --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_comments where comment_status = 'trash';" >> wp-db-checks-$SITE.txt
#pingbacks
echo "-- pingbacks --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_comments where comment_approved = 'pingback';" >> wp-db-checks-$SITE.txt
#unapproved
echo "-- unapproved comments --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_comments where comment_approved = '0';" >> wp-db-checks-$SITE.txt

#expired sessions#
echo "-- expired woo sessions --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute=";" >> wp-db-checks-$SITE.txt
echo "-- wp_options wp sessions rows --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from ${DB_PREFIX}_options where option_name LIKE '%_wp_session_%';" >> wp-db-checks-$SITE.txt


## check for indexes ##
echo "Check for Indexes"
echo "-- Indexes on all tables --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="SELECT DISTINCT TABLE_NAME, INDEX_NAME FROM INFORMATION_SCHEMA.STATISTICS;" >> wp-db-checks-$SITE.txt

#check charset 

#get size of every table
echo "Table Size" && echo "-- Size of all tables --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="SHOW TABLE STATUS;" >> wp-db-checks-$SITE.txt

## check for duplicate entries in yoast indexables table ##
echo "Yoast Indexables" && echo "-- Yoast Indexables Duplicate entries --" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="select * from wp_yoast_indexable
where exists (
    select 1 from wp_yoast_indexable wyi2
    where wyi2.object_id = wp_yoast_indexable.object_id
    and wyi2.object_type = wp_yoast_indexable.object_type
    and wyi2.id < wp_yoast_indexable.id
);" >> wp-db-checks-$SITE.txt

##check for slow queries ##
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="SELECT SQL_CALC_FOUND_ROWS ${DATABASE}.${DB_PREFIX}_posts.ID;" >> wp-db-checks-$SITE.txt

## Check Database Collation / Charset ##
#global collation
echo "Collation" && echo "-- Collation Checks--" >> wp-db-checks-$SITE.txt
mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="
SHOW VARIABLES LIKE 'collation%';" >> wp-db-checks-$SITE.txt

mysql -u $SQL_USER -p$SQL_PASS -h $SQL_HOST -P $SQL_PORT $SQL_DB --execute="
SELECT 
   default_character_set_name, 
   default_collation_name
FROM information_schema.schemata 
WHERE schema_name = 'Pantheon';" >> wp-db-checks-$SITE.txt



# SELECT CONCAT('ALTER TABLE `',  wp_options, '` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;')
# FROM information_schema.TABLES AS T, information_schema.`COLLATION_CHARACTER_SET_APPLICABILITY` AS C
# WHERE C.collation_name = T.table_collation
# AND T.table_schema = 'pantheon'
# AND
# (
#     C.CHARACTER_SET_NAME != 'utf8mb4'
#     OR
#     C.COLLATION_NAME != 'utf8mb4_unicode_520_ci'
# );