--if use hive, below statement can be used to show the column names
--SET hive.cli.print.header=true;

select round(corr(final_score, BaseScore),4) as score_correlation
--,round(corr(final_score, ConsistencyScore),4) as score_consist_corr
--,round(corr(std_score, BaseScore),4) as std_score_corr
,round(corr(std_score, ConsistencyScore),4) as variability_correlation
from hospital_score_survey;