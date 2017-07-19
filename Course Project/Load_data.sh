# assuming already start hadoop, postgres and metastore
# to save file in /data folder where 100GB EBS volume attached
# run as a root user to avoid any permission issues 

cd /data
# Get data into EC2 instance, the file is about 41GB, 111M rows
# avg speed: 2.27M/s. total time 4h 36m
mkdir taxi_trip
cd taxi_trip/
wget -v -O Taxi_Trips.csv "http://data.cityofchicago.org/api/views/wrvz-psew/rows.csv?accessType=DOWNLOAD"

# check number of records which takes a while
ls
wc -l Taxi_Trips.csv

# view top 2 records
head -2 Taxi_Trips.csv

# Put the file into HDFS
# strip the header line, cannot use the same file names otherwise it will delete all records
tail -n +2 Taxi_Trips.csv  > Taxi_Trips_No_Header.csv

# next, move local files to HDFS
# for creating hive tables later, save files in separate subfolders under project folder
hdfs dfs -mkdir taxi_trip_project
hdfs dfs -mkdir taxi_trip_project/taxi_trip

# move files to the folders
hdfs dfs -put Taxi_Trips_No_Header.csv taxi_trip_project/taxi_trip

# check directory and files are in the right place
hdfs dfs -ls /user/w205/taxi_trip_project/taxi_trip

