-- top 10 procedures with the greatest variability between hospitals
	select s.measureid
	,m.measurename
	,m.measurestartdate
	,m.measureenddate
	,s.std_score
	,s.avg_score
	from measure_score as s
	join measure as m on s.measureid = m.measureid
	order by std_score desc
	limit 10;
