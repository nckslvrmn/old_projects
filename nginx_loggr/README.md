# nginx_loggr
This is a diamond collector to scrape nginx logs. This was written based on the logster nginx collector. I wanted it to be more minimal as it was unecessary to run both logster and diamond.

This python diamond collector requires diamond (of course), and the pygtail module.

The collector is made to work with the default nginx log format. If this is different, the regex can be changed to match your current log format.