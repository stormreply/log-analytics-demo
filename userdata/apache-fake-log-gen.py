#!/usr/bin/python
import time
import datetime
import numpy
import random
import argparse
from faker import Faker
from random import randint
from tzlocal import get_localzone

local = get_localzone()

parser = argparse.ArgumentParser(__file__, description="Fake Apache Log Generator")
parser.add_argument("--number", "-n", help="Number of lines per minute", default=60, type=float)

args = parser.parse_args()

faker = Faker()

timestr = time.strftime("%Y%m%d-%H%M%S")

out_file_name = '/apache/logs/access_log_'+timestr+'.log'
# out_file_name = '/dev/stdout'
out_file = open(out_file_name,'w')

response = ["200","404","500","301"]
verb = ["GET","POST","DELETE","PUT"]
resources = ["/list","/wp-content","/wp-admin","/explore","/search/tag/list","/app/main/posts","/posts/posts/explore","/apps/cart.jsp?appID="]
ualist = [faker.firefox, faker.chrome, faker.safari, faker.internet_explorer, faker.opera]

number_gauss = int(random.gauss(args.number, int(args.number / 20)))
sleep_ms = int(60 / number_gauss * 1000)
sleep_gauss = int(random.gauss(sleep_ms, int(sleep_ms / 20)))

def rri(n):
    return random.randint(int(n*950), int(n*1050)) / 1000

while (True):

    now = datetime.datetime.now()
    delta_ms = random.randint(-2000, 2000)
    delta = datetime.timedelta(milliseconds=delta_ms)
    rt = now + delta

    ip = faker.ipv4()
    dt = rt.strftime('%d/%b/%Y:%H:%M:%S')
    tz = datetime.datetime.now(local).strftime('%z')
    vrb = numpy.random.choice(verb,p=[0.6,0.1,0.1,0.2])

    uri = random.choice(resources)
    if uri.find("apps")>0:
        uri += str(random.randint(1000,10000))

    resp = numpy.random.choice(response,p=[n for n in [0.9,0.04,0.02,0.04]])
    byt = int(random.gauss(5000,50))
    referer = faker.uri()
    useragent = numpy.random.choice(ualist,p=[0.5,0.3,0.1,0.05,0.05] )()
    out_file.write('%s - - [%s %s] "%s %s HTTP/1.0" %s %s "%s" "%s"\n' % (ip,dt,tz,vrb,uri,resp,byt,referer,useragent))
    out_file.flush()

    time.sleep(sleep_gauss / 1000)
