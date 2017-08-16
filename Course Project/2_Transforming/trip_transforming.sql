--weather data
--average temperature is all blank, using temperature at the time of observation
--remove some blank rows and get daily aggregated values for Chicago across three Stations
--a lot of missing values (blank) for snow and temperature variables
drop table weather;
create table weather
as
select
STATION
,NAME
,cast(LATITUDE as float) as LATITUDE
,cast(LONGITUDE as float) as LONGITUDE
,cast(ELEVATION as float) as ELEVATION
,from_unixtime(unix_timestamp(DATE,'MM/dd/yyyy'),'yyyy-MM-dd') as DATE
,cast(PRCP as float) as PRCP
,PRCP_ATTRIBUTES
,cast(SNOW as float) as SNOW
,SNOW_ATTRIBUTES
,cast(SNWD as float) as SNWD
,SNWD_ATTRIBUTES
,cast(TMAX as float) as TMAX
,TMAX_ATTRIBUTES
,cast(TMIN as float) as TMIN
,TMIN_ATTRIBUTES
,cast(TOBS as float) as TOBS
,TOBS_ATTRIBUTES
from weather_raw
where from_unixtime(unix_timestamp(DATE,'MM/dd/yyyy'),'yyyy-MM-dd') >= '2015-06-01'
and PRCP <> '' --and SNOW <> '' and SNWD <> '' and TOBS <> ''
;


--convert time variable from string to datetime
--convert fare related variables from string to number
--extract Year/Month/Day/Hour/weekday variables for later analysis
--filter year: select past three years' data
--there may be more efficient way to transform above time variables
--it takes long time for this step, about 19 mintues for 6M records; use spark sql instead of hive?
drop table taxi_trip;
create table taxi_trip
as
select
TripID
,TaxiID
,from_unixtime(unix_timestamp(TripStartTime,'MM/dd/yyyy hh:mm:ss a'),'yyyy-MM-dd HH:mm:ss') as TripStartTime
,from_unixtime(unix_timestamp(TripEndTime,'MM/dd/yyyy hh:mm:ss a'),'yyyy-MM-dd HH:mm:ss') as TripEndTime
,from_unixtime(unix_timestamp(TripStartTime,'MM/dd/yyyy hh:mm:ss a'),'EEEE') as Weekday
,To_Date(from_unixtime(unix_timestamp(TripStartTime,'MM/dd/yyyy hh:mm:ss a'),'yyyy-MM-dd HH:mm:ss')) as TripStartDate
,Year(from_unixtime(unix_timestamp(TripStartTime,'MM/dd/yyyy hh:mm:ss a'),'yyyy-MM-dd HH:mm:ss')) as TripStartYear
,Month(from_unixtime(unix_timestamp(TripStartTime,'MM/dd/yyyy hh:mm:ss a'),'yyyy-MM-dd HH:mm:ss')) as TripStartMonth
,Day(from_unixtime(unix_timestamp(TripStartTime,'MM/dd/yyyy hh:mm:ss a'),'yyyy-MM-dd HH:mm:ss')) as TripStartDay
,Hour(from_unixtime(unix_timestamp(TripStartTime,'MM/dd/yyyy hh:mm:ss a'),'yyyy-MM-dd HH:mm:ss')) as TripStartHour
,TripSeconds/60 as TripMinutes
,cast(case when TripMiles='' then 0.0 else TripMiles end as float) as TripMiles
,PickupTract
,DropoffTract
,PickupCommunity
,DropoffCommunity
,COALESCE(cast(substr(Fare,2,length(Fare)-1) as float),CAST(0 AS BIGINT)) as Fare
,COALESCE(cast(substr(Tips,2,length(Tips)-1) as float),CAST(0 AS BIGINT)) as Tips
,COALESCE(cast(substr(Tolls,2,length(Tolls)-1) as float),CAST(0 AS BIGINT)) as Tolls
,COALESCE(cast(substr(Extras,2,length(Extras)-1) as float),CAST(0 AS BIGINT)) as Extras
,COALESCE(cast(substr(TripTotal,2,length(TripTotal)-1) as float),CAST(0 AS BIGINT)) as TripTotal
,PaymentType
,Company
,PickupLatitude
,PickupLongitude
,PickupLocation
,DropoffLatitude
,DropoffLongitude
,DropoffLocation
,CommunityAreas
from taxi_trip_raw
where To_Date(from_unixtime(unix_timestamp(TripStartTime,'MM/dd/yyyy hh:mm:ss a'),'yyyy-MM-dd HH:mm:ss')) >= '2015-06-01'
;

--check data type
--describe taxi_trip;

--convert variables to appropriate type for new data set
drop table new_data;
create table new_data
as
select
from_unixtime(unix_timestamp(TripStartDate,'MM/dd/yyyy'),'yyyy-MM-dd') as TripStartDate
,startdate_str
,tripstartyear
,tripstartmonth
,tripstartday
,weekday
,cast(prcp as float) as prcp
,cast(snow as float) as snow
,cast(snwd as float) as snwd
,cast(tmax as float) as tmax
,cast(tmin as float) as tmin
,cast(tobs as float) as tobs
,pickupcommunity
from new_data_raw;
