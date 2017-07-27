--create base hive table
--though defined data type below, it still shows string when use describe table command
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