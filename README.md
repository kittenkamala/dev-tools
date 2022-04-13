
This repo contains some developer tools for debugging poor performance in an application.

• env-vars.sh 
    Contains environment variables with blank values that need to be filled in as applicable to the target environment. 
    Included in .gitignore for security purposes, so the repo can be pushed to without exposing those sensative authentication details. 
    The file should be modified on your local.
• wp-db-checks.sh
    Includes env-vars.sh and contains a series of WordPress-specific MySQL Cli database checks
• wp-db-checks.sh
    Includes env-vars.sh and contains a series of WordPress-specific WP-CLI health checks

Requires:
• MySQL
• MySQL Cli
• Terminus

Sponsored by Pantheon Systems Inc.