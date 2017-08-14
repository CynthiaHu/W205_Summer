# assuming already start hadoop, postgres and metastore
# to save file in /data folder where 100GB+ EBS volume attached
# run as a root user to avoid any permission issues 
cd $HOME
cd /data
mkdir taxi_trip
cd taxi_trip/

#download weather data
wget -O weather.csv http://s3.amazonaws.com/cynthiahuw205/weather_data.csv
wc -l weather.csv
# view top 2 records
head -2 weather.csv

#download new data for forecast, it's more like a mockup
wget -O newdata.csv http://s3.amazonaws.com/cynthiahuw205/newdata.csv
# view top 2 records
head -2 newdata.csv

# Get taxi_trip data into EC2 instance, the file is about 41GB, 111M rows
# avg speed: 2.27M/s. total time 4h 36m
wget -v -O Taxi_Trips.csv "http://data.cityofchicago.org/api/views/wrvz-psew/rows.csv?accessType=DOWNLOAD"
# view top 2 records
head -2 Taxi_Trips.csv
# check number of records which takes a while
ls
wc -l Taxi_Trips.csv


# Put the file into HDFS
# strip the header line, cannot use the same file names otherwise it will delete all records
tail -n +2 weather.csv > weather_no_header.csv
tail -n +2 newdata.csv > newdata_no_header.csv
tail -n +2 Taxi_Trips.csv  > Taxi_Trips_No_Header.csv


# next, move local files to HDFS
# for creating hive tables later, save files in separate subfolders under project folder
hdfs dfs -mkdir taxi_trip_project
hdfs dfs -mkdir taxi_trip_project/taxi_trip
hdfs dfs -mkdir taxi_trip_project/weather
hdfs dfs -mkdir taxi_trip_project/newdata

# move files to the folders
hdfs dfs -put Taxi_Trips_No_Header.csv taxi_trip_project/taxi_trip
hdfs dfs -put weather_no_header.csv taxi_trip_project/weather
hdfs dfs -put newdata_no_header.csv taxi_trip_project/newdata

# check directory and files are in the right place
hdfs dfs -ls /user/w205/taxi_trip_project/taxi_trip
hdfs dfs -ls /user/w205/taxi_trip_project/weather
hdfs dfs -ls /user/w205/taxi_trip_project/newdata



 



