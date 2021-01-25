#!/usr/bin/env python

import datetime
import diamond.collector
from pygtail import Pygtail
import re
import sys
import time

class LoggrCollector(diamond.collector.Collector):

    def process_metrics(self):
        new_metrics = {key: value/float(self.config['interval']) for (key, value) in self.metrics.iteritems()}
        total_requests = new_metrics['http_1xx'] + new_metrics['http_2xx'] + new_metrics['http_3xx'] + new_metrics['http_4xx'] + new_metrics['http_5xx']
        if total_requests == 0:
            average_request_time = 0.0
        else:
            average_request_time = new_metrics['request_time'] / total_requests
        new_metrics['average_request_time'] = average_request_time
        new_metrics['total_requests'] = total_requests
        self.metrics = new_metrics

    def collect(self):
        self.logfile = '/var/log/nginx/access.log'
        self.offsetfile = '/tmp/nginx-access.log.offset'
        reg = re.compile('.*HTTP/1.\d\" (?P<http_status_code>\d{3}) "(?P<request_time>[\d\.]+)" .*')
        self.update_logfile()
        tailer = Pygtail(self.logfile, offset_file=self.offsetfile)
        self.metrics = dict(http_1xx=0, http_2xx=0, http_3xx=0, http_4xx=0, http_5xx=0, request_time=0.0)
        lines = tailer.readlines()
        if lines is not None:
            for line in lines:
                try:
                    regMatch = reg.search(line)
                    if regMatch:
                        linebits = regMatch.groupdict()
                        status = linebits['http_status_code']
                        if not linebits['request_time'] == '-':
                            self.metrics['request_time'] += float(linebits['request_time'])
                        self.metrics["http_" + status[:1] + "xx"] += 1

                except Exception(line):
                    print("regmatch or contents failed with {}".format(line))
        
        self.process_metrics()
        for metric in self.metrics:
            self.publish(metric, self.metrics[metric], precision=2)
