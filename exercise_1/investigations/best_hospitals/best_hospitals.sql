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
,s.final_score as average_quality_score
,s.std_final_score as score_variability
from hospital_final_score as s
join hospital as h on s.providerid=h.providerid
order by s.final_score desc
limit 10;