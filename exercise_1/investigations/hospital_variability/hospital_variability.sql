--if use hive, below statement can be used to show the column names
--SET hive.cli.print.header=true;

-- top 10 procedures with the greatest variability between hospitals
select s.measureid as MeasureID
,round(s.std_score,2) as ScoreVariability
,round(s.avg_score,2) as AverageScore
,m.measurename as MeasureName
,m.measurestartdate as MeasureStartDate
,m.measureenddate as MeasureEndDate
from measure_score as s
join measure as m on s.measureid = m.measureid
order by ScoreVariability desc
limit 10;
