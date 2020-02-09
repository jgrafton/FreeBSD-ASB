# FreeBSD-ASB
Check out FreeBSD head and automatically compile and install into a virual disk image

## crontab entry
``` 0 3 * * * /home/jgrafton/FreeBSD-ASB/autobuild.cron.sh /home/jgrafton/FreeBSD-ASB > /home/jgrafton/FreeBSD-ASB/autobuild.log 2>&1 ```
