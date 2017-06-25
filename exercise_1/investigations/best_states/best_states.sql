--if use hive, below statement can be used to show the column names
--SET hive.cli.print.header=true;

--top 10 states of high-quality care

select state
,round(final_score,2) as final_score
,hospital_count	
from state_final_score
order by final_score desc
limit 10;
	