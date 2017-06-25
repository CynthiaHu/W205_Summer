--Don't Indent
--step 0 - exclude invalid state from hospital dimension table
Drop table hospital_filtered;

Create table hospital_filtered
as 
select *
from hospital
where State not in ('AS','DC','GU','MP','PR','VI');

--step 1 - transform effective tables
--filter effective table with valid score
Drop table effective_filtered;

CREATE TABLE effective_filtered
AS 
SELECT e.providerid
,h.hospitalname
,h.address
,h.city
,h.state
,h.zipcode
,h.countyname
,h.phonenumber
,h.hospitaltype
,h.emergencyservices
,e.condition
,e.measureid
,m.measurename
,e.score
,e.sample
,e.footnote
,m.measurestartdate
,m.measureenddate 
,cast (e.score as float) as score_float
From effective as e
join hospital_filtered as h on e.providerid = h.providerid
join measure as m on e.measureid = m.measureid
Where e.score <> 'Not Available' and e.measureid <> 'EDV'
and (e.condition <> 'Emergency Department' or h.emergencyservices <>'No');


-- scale effective measure score to 0-100
Drop table effective_standard;

Create table effective_standard
As 
Select e.*
, round((e.score_float / m.max_score) * 100,2) as stand_score
From effective_filtered as e
Join (select measureid, max(score_float) as max_score from effective_filtered group by measureid) as m on e.measureid=m.measureid
Where m.max_score <> 0;


--aggregate effective score by measures
Drop table measure_effective_score;

Create table measure_effective_score
As
Select measureid
,measurename
,avg(stand_score) as avg_score
,stddev(stand_score) as std_score
From effective_standard
Group by 
 measureid
,measurename;

--aggregate effective score by hospital
Drop table hospital_effective_score;

Create table hospital_effective_score
as
Select providerid
,hospitalname
,state
,avg(stand_score) as avg_effective_score
,stddev(stand_score) as std_effective_score
From effective_standard
Group by 
providerid
,hospitalname
,state;


--Step 2. Transform readmission tables
--filter readmission table with valid score
--as all scores in this table are rates, there is no need to scale
Drop table readmission_filtered;

CREATE TABLE readmission_filtered
AS 
SELECT r.providerid
,h.hospitalname
,h.address
,h.city
,h.state
,h.zipcode
,h.countyname
,h.phonenumber
,r.measureid
,m.measurename
,r.comparedtonational 
,r.denominator
,r.score
,r.lowerestimate
,r.higherestimate
,r.footnote
,m.measurestartdate
,m.measureenddate 
,cast (r.score as float) as score_float 
From readmission as r
join hospital_filtered as h on r.providerid = h.providerid
join measure as m on r.measureid = m.measureid
Where score <> 'Not Available' and score <= 100;

--aggregate readmission score by measures
Drop table measure_readmission_score;

Create table measure_readmission_score
As
Select measureid
,measurename
,avg(score_float) as avg_score
,stddev(score_float) as std_score
From readmission_filtered
Group by 
 measureid
,measurename;

--aggregate readmission score by hospital
Drop table hospital_readmission_score;

Create table hospital_readmission_score
as
Select providerid 
,hospitalname
,state
,avg(score_float) as avg_readmission_score
,stddev(score_float) as std_readmission_score
From readmission_filtered
Group by 
providerid
,hospitalname
,state;

--Step 3. JOIN/Combine Effective and Readmission hospital tables to get final score by hospital
--calculate hospital score variability across all measures
Drop table hospital_volatility;

Create table hospital_volatility
as
select a.providerid
,stddev(a.stand_score) as std_score
,count(a.measureid) as measure_count
from
(select providerid
,measureid
,stand_score
from effective_standard
union all
select providerid
,measureid
,score_float as stand_score
from readmission_filtered) a
group by a.providerid;

-- for effective score (0-100), the higher the better; 
-- for readmission measures (0-100), the lower the rates the better;
-- thus define final score = effective score - readmission score
-- use inner join as if the hospital just has one type of score, it will be excluded from the comparison 

Drop table hospital_final_score;

Create table hospital_final_score
As
select e.providerid
,e.hospitalname
,e.state
,e.avg_effective_score as effective_score
,r.avg_readmission_score as readmission_score
,e.avg_effective_score-r.avg_readmission_score as final_score
,v.std_score
,v.measure_count
from hospital_effective_score as e
join hospital_readmission_score as r on e.providerid=r.providerid
join hospital_volatility as v on r.providerid=v.providerid
where v.std_score > 0;
--exclude zero variability as these hospitals only have one measure with valid score


--aggreagte final score by state
Drop table state_final_score;

Create table state_final_score
As
Select state
,avg(effective_score) as effective_score
,avg(readmission_score) as readmission_score
,avg(effective_score) - avg(readmission_score) as final_score
,count(distinct providerid) as hospital_count
From hospital_final_score
Group by state;

--Step 4. Combine Effective and Readmission measure tables to get final score by procedure
Drop table measure_score;

Create table measure_score
As
Select measureid
,measurename
,avg_score
,std_score
From measure_effective_score
UNION ALL
Select measureid
,measurename
,avg_score
,std_score
From measure_readmission_score;

--Step 5. Join hospital final score table with survey table
--still use inner join here as if there is no survey data for a hospital,
--it doesn't make sense to do the correlation analysis between score and response
Drop table hospital_score_survey;

Create table hospital_score_survey
As
select h.*
,cast(s.hcahpsbasescore as float) as BaseScore
,cast(s.hcahpsconsistencyscore as float) as ConsistencyScore
from hospital_final_score as h
join survey as s on h.providerid = s.providerid;


