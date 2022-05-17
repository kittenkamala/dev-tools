
Developer Debugging Tools


Requirements:
• MySQL[https://dev.mysql.com/doc/mysql-installation-excerpt/5.7/en/]
• MySQL Cli[https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-install.html]
• Terminus[https://pantheon.io/docs/terminus/install]
• WP Scan[https://github.com/wpscanteam/wpscan]

Files:
• env-vars.sh 
    Contains environment variables with blank values that need to be filled in as applicable to the target environment. 
    Included in .gitignore for security purposes, so the repo can be pushed to without exposing those sensative authentication details. 
    The file should be modified on your local.

• wp-db-checks.sh
    Includes env-vars.sh and contains a series of WordPress-specific MySQL Cli database checks

• wp-cli-checks.sh
    Includes env-vars.sh and contains a series of WordPress-specific WP-CLI health checks. Installs the extend-wp-cli plugin[https://github.com/kittenkamala/extend-wp-cli]

Usage:
1. Add values to env-vars.sh
2. From terminal initiate prefered scripts with a `sh <example.sh>` command
    a) `sh wp-cli-checks.sh`
    b) `sh wp-db-checks.sh`
3. Output will write to a wp-db-$SITE.txt or wp-cli-$SITE.txt file in your repo

Recommended workflow is to ceate one env-vars-$SITE.sh file per website with saved values and rename to env-vars.sh when running audits on that site.

Sponsored by Pantheon Systems Inc.