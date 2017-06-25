--if use hive, below statement can be used to show the column names
--SET hive.cli.print.header=true;

-- top 10 best hospital_final_score
-- join hospital dimension table for hospital attributes
-- for readable output, not all hospital attributes are printed out
select s.providerid as ProviderID
,s.measure_count as MeasureCount
,round(s.effective_score,2) as EffectiveScore
,round(s.readmission_score,2) as ReadmissionScore
,round(s.final_score,2) as AverageQualityScore
,round(s.std_score,2) as ScoreVariability
,h.state as State
,h.hospitalownership as HospitalOwnership
,h.emergencyservices as EmergencyServices
,h.hospitaltype as HospitalType
,h.hospitalname as HospitalName
--,h.address as Address
--,h.city as City
--,h.zipcode as ZipCode
--,h.countyname as CountryName
--,h.phonenumber as PhoneNumber
from hospital_final_score as s
join hospital_filtered as h on s.providerid=h.providerid
order by AverageQualityScore desc, ScoreVariability asc
limit 10;