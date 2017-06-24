-- top 10 best hospital_final_score
-- join hospital dimension table for hospital attributes
select s.providerid
,h.hospitalname
,h.address
,h.city
,h.state
,h.zipcode
,h.countyname
,h.phonenumber
,h.hospitaltype
,h.hospitalownership
,h.emergencyservices
,round(s.effective_score,2) as effective_score
,round(s.readmission_score,2) as readmission_score
,round(s.final_score,2) as average_quality_score
,round(s.std_score,2) as score_variability
from hospital_final_score as s
join hospital as h on s.providerid=h.providerid
order by average_quality_score desc, score_variability asc
limit 10;