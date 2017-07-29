# due to privacy protection, tweet API keys in tweets.py are hidden. Please update it using your own credentials.
# assume you have installed psycopg2, tweepy, numpy and matplotlib

# switch to w205 user
[root@ip-172-31-28-131 ~]# su - w205

# go to exercise_2 folder
[w205@ip-172-31-28-131 ~]$ cd W205_Summer/exercise_2
[w205@ip-172-31-28-131 exercise_2]$ ls -l

# create psql database and table in advance
[w205@ip-172-31-28-131 exercise_2]$ python create_table.py

# go to extweetwordcount project directory
[w205@ip-172-31-28-131 exercise_2]$ cd extweetwordcount

# run the application
[w205@ip-172-31-28-131 exercise_2]$ sparse run

# use Ctrl+C to exit the program

# go to exercise_2 directory to extract results from psql database
[w205@ip-172-31-28-131 extweetwordcount]$ cd ..
[w205@ip-172-31-28-131 exercise_2]$ ls -l

# return the total number of word (i.e. "will") occurence in the stream
[w205@ip-172-31-28-131 exercise_2]$ python finalresults.py will

# returns all the words in the stream, and their total count of
# occurrences, worted alphabetically, one word per line.
[w205@ip-172-31-28-131 exercise_2]$ python finalresults.py

# returns all the words with a total number of occurrences greater than or
# equal to 3, and less than or equal to 8.
[w205@ip-172-31-28-131 exercise_2]$ python histogram.py 3,8

# returns top 20 words
[w205@ip-172-31-28-131 exercise_2]$ python top20.py
