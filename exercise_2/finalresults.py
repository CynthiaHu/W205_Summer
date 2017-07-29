import sys
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT


conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()

if len(sys.argv) == 1:
	cur.execute("SELECT word, count from tweetwordcount order by word")
	records = cur.fetchall()
	for rec in records:
		print rec[0], rec[1]

if len(sys.argv) == 2:
	word = sys.argv[1]
	cur.execute("SELECT word, count from tweetwordcount where word=%s", (word, ))
	
	records2 = cur.fetchall()
	for rec in records2:
		print "Total number of occurrences of of %s: %d" %(rec[0], rec[1])		

if len(sys.argv) > 2:
	print "please only provide zero or one argument."
	exit(1)

conn.commit()
conn.close()
