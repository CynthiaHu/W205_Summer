--create base hive table
--though defined data type below, they are all string in hive
drop table taxi_trip_raw;

create external table taxi_trip_raw
(
TripID    string,
TaxiID    string,
TripStartTime    string,
TripEndTime    string,
TripSeconds    float,
TripMiles    float,
PickupTract    string,
DropoffTract    string,
PickupCommunity    float,
DropoffCommunity    float,
Fare    float,
Tips    float,
Tolls    float,
Extras    float,
TripTotal    float,
PaymentType    string,
Company    string,
PickupLatitude    float,
PickupLongitude    float,
PickupLocation    string,
DropoffLatitude    float,
DropoffLongitude    float,
DropoffLocation    string,
CommunityAreas    string

)

ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/taxi_trip_project/taxi_trip';

--weather table
drop table weather_raw;

create external table weather_raw
(
STATION    string,
NAME    string,
LATITUDE    float,
LONGITUDE    float,
ELEVATION    float,
DATE    string,
PRCP    float,
PRCP_ATTRIBUTES    string,
SNOW    float,
SNOW_ATTRIBUTES    string,
SNWD    float,
SNWD_ATTRIBUTES    string,
TMAX    float,
TMAX_ATTRIBUTES    string,
TMIN    float,
TMIN_ATTRIBUTES    string,
TOBS    float,
TOBS_ATTRIBUTES    string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/taxi_trip_project/weather';


--new data for forecast
drop table new_data_raw;
create external table new_data_raw
(
tripstartdate    string,
startdate_str    string,
tripstartyear    string,
tripstartmonth   string,
tripstartday    string,
weekday    float,
prcp       float,
snow       float,
snwd       float,
tmax       float,
tmin       float,
tobs       float,
pickupcommunity    string

)

ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/taxi_trip_project/newdata';
