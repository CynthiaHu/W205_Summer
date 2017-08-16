--below row count is based on partial raw dataset but it should be close to actuals
--as it's row count from aggregated tables;

--daily weather
drop table daily_weather;
create table daily_weather
as
select DATE
,avg(PRCP) as PRCP
--,sum(PRCP)/sum(case when PRCP is null then 0 else 1 end) as PRCP2
,sum(SNOW)/sum(case when SNOW is null then 0 else 1 end) as SNOW
,sum(SNWD)/sum(case when SNWD is null then 0 else 1 end) as SNWD
,sum(TMAX)/sum(case when TMAX is null then 0 else 1 end) as TMAX
,sum(TMIN)/sum(case when TMIN is null then 0 else 1 end) as TMIN
,sum(TOBS)/sum(case when TOBS is null then 0 else 1 end) as TOBS
from weather
group by DATE;


--details taxi trip data with weather for python forecast
--but need to include 2 years' data to catch seasonality (month)
drop table taxi_trip_fcst;
create table taxi_trip_fcst
as
select t.TaxiID
,t.TripStartYear
,t.TripStartMonth
,t.TripStartDay
,t.Weekday
,t.pickupcommunity
--,t.dropoffcommunity
,t.Company
,w.PRCP
,w.SNOW
,w.SNWD
,w.TMAX
,w.TMIN
,w.TOBS
,count(TripID) as TripCount
,sum(Fare) as TotalFare
,sum(Tips) as TotalTips
,sum(Tolls) as TotalTolls
,sum(TripTotal) as TripTotal
,sum(Fare)/count(TripID) as FarePerTrip
,sum(TripMiles)/count(TripID) as MilesPerTrip
,sum(TripMinutes)/count(TripID) as MinutePerTrip
,sum(TripMinutes)/count(distinct TaxiID) as DurationPerDriver
,sum(Fare)/sum(TripMinutes) as FarePerMinute
from taxi_trip as t
left join daily_weather as w on t.TripStartDate = w.Date
where t.TripStartDate >= '2015-06-01'
group by t.TaxiID
,t.TripStartYear
,t.TripStartMonth
,t.TripStartDay
,t.Weekday
,t.pickupcommunity
--,t.dropoffcommunity
,t.Company
,w.PRCP
,w.SNOW
,w.SNWD
,w.TMAX
,w.TMIN
,w.TOBS
;

--Trip daily Trend with daily weather data
--if still too many records for tableau, then use year-month only (without date)
--about 883 rows
drop table daily_trend;

create table daily_trend
as
select t.*
,w.PRCP
,w.SNOW
,w.SNWD
,w.TMAX
,w.TMIN
,w.TOBS
from
(select TripStartDate
,count(TripID) as TripCount
,sum(Fare) as TotalFare
,sum(Tips) as TotalTips
,sum(Tolls) as TotalTolls
,sum(TripTotal) as TripTotal
,sum(Fare)/count(TripID) as FarePerTrip
,sum(TripMiles)/count(TripID) as MilesPerTrip
,sum(TripMinutes)/count(TripID) as MinutePerTrip
,sum(TripMinutes)/count(distinct TaxiID) as DurationPerDriver
,sum(Fare)/sum(TripMinutes) as FarePerMinute
from taxi_trip
group by TripStartDate) as t
left join daily_weather as w on t.TripStartDate = w.Date
where t.TripStartDate >= '2015-06-01';


--Trip by Pickup Dropoff Area
--with this table, we may not need separate pickup and dropoff tables
--there are blanks for community variable
--about 3575 rows
drop table PickUp_DropOff;
create table PickUp_DropOff
as
select PickupCommunity
,DropoffCommunity
,count(TripID) as TripCount
,sum(Fare) as TotalFare
,sum(Tips) as TotalTips
,sum(Tolls) as TotalTolls
,sum(TripTotal) as TripTotal
,sum(Fare)/count(TripID) as FarePerTrip
,sum(TripMiles)/count(TripID) as MilesPerTrip
,sum(TripMinutes)/count(TripID) as MinutePerTrip
,sum(TripMinutes)/count(distinct TaxiID) as DurationPerDriver
,sum(Fare)/sum(TripMinutes) as FarePerMinute
from taxi_trip
--where pickupcommunity <> '' and dropoffcommunity <> ''
where TripStartDate >= '2015-06-01'
group by PickupCommunity
,DropoffCommunity;


--Trip by Pick Up Area
--77 rows
drop table PickUpArea;
create table PickUpArea
as
select PickupCommunity
,count(TripID) as TripCount
,sum(Fare) as TotalFare
,sum(Tips) as TotalTips
,sum(Tolls) as TotalTolls
,sum(TripTotal) as TripTotal
,sum(Fare)/count(TripID) as FarePerTrip
,sum(TripMiles)/count(TripID) as MilesPerTrip
,sum(TripMinutes)/count(TripID) as MinutePerTrip
,sum(TripMinutes)/count(distinct TaxiID) as DurationPerDriver
,sum(Fare)/sum(TripMinutes) as FarePerMinute
from taxi_trip
where pickupcommunity <> '' and TripStartDate >= '2015-06-01'
group by PickupCommunity;

--Trip by Drop Off Area
--77 rows
drop table DropOffArea;
create table DropOffArea
as
select DropoffCommunity
,count(TripID) as TripCount
,sum(Fare) as TotalFare
,sum(Tips) as TotalTips
,sum(Tolls) as TotalTolls
,sum(TripTotal) as TripTotal
,sum(Fare)/count(TripID) as FarePerTrip
,sum(TripMiles)/count(TripID) as MilesPerTrip
,sum(TripMinutes)/count(TripID) as MinutePerTrip
,sum(TripMinutes)/count(distinct TaxiID) as DurationPerDriver
,sum(Fare)/sum(TripMinutes) as FarePerMinute
from taxi_trip
where dropoffcommunity <> '' and TripStartDate >= '2015-06-01'
group by DropoffCommunity;


--Trip Pattern by Month/Day/HOUR
--about 20912 rows
drop table timepattern;
create table timepattern
as
select TripStartYear
,TripStartMonth
,TripStartDay
,Weekday
,TripStartHour
,count(TripID) as TripCount
,sum(Fare) as TotalFare
,sum(Tips) as TotalTips
,sum(Tolls) as TotalTolls
,sum(TripTotal) as TripTotal
,sum(Fare)/count(TripID) as FarePerTrip
,sum(TripMiles)/count(TripID) as MilesPerTrip
,sum(TripMinutes)/count(TripID) as MinutePerTrip
,sum(TripMinutes)/count(distinct TaxiID) as DurationPerDriver
,sum(Fare)/sum(TripMinutes) as FarePerMinute
from taxi_trip
where TripStartDate >= '2015-06-01'
group by TripStartYear
,TripStartMonth
,TripStartDay
,Weekday
,TripStartHour;

--Duration bucket analysis
--need to review this query and table further
--don't indent the subquery
drop table duration_fare;
create table duration_fare
as
select t.quantile
,min(t.TripMinutes) as min_mintues
,max(t.TripMinutes) as max_mintues
,sum(t.TripCount) as TripCount
--,sum(t.TotalFare) as TotalFare
--,sum(t.TotalFare)/sum(t.TripMinutes) as FarePerMinute
,sum(t.TotalFare)/sum(t.TripCount) as AverageFare
from
(select 
round(TripMinutes,0) as TripMinutes
,count(TripID) as TripCount
,sum(Fare) as TotalFare
,NTILE(10) over (order by TripMinutes) as quantile
from taxi_trip
where TripStartDate >= '2015-06-01'
group by TripMinutes) t
group by t.quantile;

--Pick up map
--need to filter fewer datapoints at lower granular level for the map: YTD
--about 412 rows, perhapse we don't need to filter the date here
drop table PickUpMap;
create table PickUpMap
as
select 
PickupLatitude
,PickupLongitude
,count(TripID) as TripCount
from taxi_trip
where TripStartDate >='2017-01-01'
and PickupLatitude <> '' and PickupLongitude <> ''
group by 
PickupLatitude
,PickupLongitude;

--drop off map
--need to filter fewer datapoints at lower granular level for the map: YTD
--about 546 rows, perhapse we don't need to filter the date here
drop table DropOffMap;
create table DropOffMap
as
select 
DropoffLatitude
,DropoffLongitude
,count(TripID) as TripCount
from taxi_trip
where TripStartDate >='2017-01-01'
and DropoffLatitude <> '' and DropoffLongitude <> ''
group by 
DropoffLatitude
,DropoffLongitude;

--drop forecast output table for next step
drop table if exists new_data_forecast;
