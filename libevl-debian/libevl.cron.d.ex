#
# Regular cron jobs for the libevl package.
#
0 4	* * *	root	[ -x /usr/bin/libevl_maintenance ] && /usr/bin/libevl_maintenance
