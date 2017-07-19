--filter year, remove invalid records

--add trip duration in minutes

drop table trip_test;

create table trip_test
as
select *, from_unixtime(unix_timestamp(tripstarttime,'MM/dd/yyyy hh:mm:ss a'),'yyyy-MM-dd HH:mm:ss') as tripstart
from taxi_trip_raw limit 5;

select tripstarttime, tripstart from trip_test;
