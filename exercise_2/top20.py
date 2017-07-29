import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT
import numpy as np
import matplotlib.pyplot as plt

conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
cur = conn.cursor()

cur.execute("select word, count from tweetwordcount order by count desc limit 20")
records = cur.fetchall()
lab = [l[0] for l in records]
val =[l[1] for l in records]

y_pos = np.arange(len(lab))

plt.bar(y_pos, val, align='center', alpha=0.5)
plt.xticks(y_pos, lab)
plt.ylabel('Count')
plt.title('tweet word count')
 
plt.show()

conn.commit()
conn.close()
