#!/usr/bin/python2
from __future__ import print_function
import time, sys, yaml, os
from daemon import runner
import datetime as dt
import pytz
from dateutil import parser
import getpass
import calendar
import numpy as np
import traceback



def check_if_time(frequency,trigger_day,time_zone_string,trigger_time,tolerance):
    today = dt.date.today()
    if frequency=='weekly':
        assert trigger_day in [calendar.day_name[x] for x in xrange(7)], "Unrecognized day name."
        isDay = (calendar.day_name[today.weekday()]==trigger_day)
        if not(isDay): return False
    elif frequency=='nightly' or frequency=='daily':
        pass
    else:
        raise NotImplementedError

    timezone=pytz.timezone(time_zone_string)
    time_now = dt.datetime.now(tz=timezone)

    datestring = dt.datetime.strftime(dt.datetime.today().date(),format='%b %d %Y')

    passtime = trigger_time
    dtin = parser.parse(passtime)
    dtin_aware = timezone.localize(dtin)
    if abs((dtin_aware-time_now).total_seconds())<tolerance:
        return True
    else:
        return False
        
    

class App():
    def __init__(self,daemon_command,yaml_file,time_interval_sec=60,tolerance_seconds=240):
        self.dir = os.path.dirname(os.path.abspath(__file__))
        self.stdin_path = '/dev/null'
        self.stdout_path = self.dir+'/syncact_out_'+str(time.time())+".log"
        self.stderr_path = self.dir+'/syncact_err_'+str(time.time())+".log"
        self.pidfile_path =  '/tmp/syncact_daemon.pid'
        self.pidfile_timeout = 5
        self.interval = time_interval_sec
        self.tolerance = tolerance_seconds
        assert self.tolerance>self.interval

        self.last_day = -1

        if daemon_command!="stop":
            with open('settings.yaml') as f:
                self.settings = yaml.safe_load(f)
            print("syncact: Daemon is running.")
            

    def run(self):
        
        while True:

            now_day = dt.datetime.today().day
            if check_if_time(self.settings['frequency'],
                             None,
                             self.settings['time_zone'],
                             self.settings['trigger_time'],
                             tolerance=self.tolerance) and (now_day!=self.last_day_reminder):
                print("Starting sync...")
                self.last_day_reminder = dt.datetime.today().day
                                
            
            time.sleep(self.interval)



def main(argv):
    try:
        yamlFile = sys.argv[2]
    except:
        assert sys.argv[1]=="stop", "No settings yaml file specified."
        yamlFile = None

    app = App(sys.argv[1],yamlFile)
    daemon_runner = runner.DaemonRunner(app)
    daemon_runner.do_action()
    
if (__name__ == "__main__"):
    main(sys.argv)
