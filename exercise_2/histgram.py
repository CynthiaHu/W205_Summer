import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

if len(sys.argv) != 2:
	print "please provide two integers in below format: n1,n2"
	exit(1)

conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()

k1 = sys.argv[1].split(',')[0]
k2 = sys.argv[1].split(',')[1]

cur.execute("select word, count from tweetwordcount where count between %s and %s", (k1, k2))
records = cur.fetchall()
for rec in records:
	print rec[0],": ", rec[1]

conn.commit()
conn.close()
