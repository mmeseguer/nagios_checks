# nagios_checks

Nagios PowerShell checks.

# check_veeam_license_expiration.ps1

Script to check the expiration date of Veeam Backup and Replication license via Nagios.

The script can take two arguments:

    W: Threshold for the warning state (in days).
    C: Threshold for the critical state (in days).

If no arguments are given:

    OK: More than 7 days left for the license to expire.
    Warning: Between 7 and 3 days left for the license to expire.
    Critical: Two or less days for the license to expire, or, license expired.

Basic use example: check_veeam_license_expiration.ps1 -w 5 -c 2
