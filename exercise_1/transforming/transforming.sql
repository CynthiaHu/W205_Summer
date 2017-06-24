--step 1 - transform effective tables

	--filter effective table with valid score
	Drop table effective_filtered;

	CREATE TABLE effective_filtered
	AS 
	SELECT e.*
	,cast (e.score as float) as score_float
	,h.HospitalType
	,h.EmergencyServices
	From effective as e
	join hospital as h on e.providerid = h.providerid
	Where score <> 'Not Available' and measureid <> 'EDV'
	and (e.condition <> 'Emergency Department' or h.EmergencyServices <>'No');


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
	,[state]
	,avg(stand_score) as avg_effective_score
	,stddev(stand_score) as std_effective_score
	From effective_standard
	Group by 
	providerid
	,hospitalname
	,[state];

	
--Step 2. Transform readmission tables
	--filter readmission table with valid score
	--as all scores in this table are rates, there is no need to scale
	Drop table readmission_filtered;

	CREATE TABLE readmission_filtered
	AS 
	SELECT *
	, cast (score as float) as score_float 
	From readmission
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
	,[state]
	,avg(score_float) as avg_readmission_score
	,stddev(score_float) as std_readmission_score
	From readmission_filtered
	Group by 
	providerid
	,hospitalname
	,[state];

--Step 3. JOIN/Combine Effective and Readmission hospital tables to get final score by hospital
    -- for effective score (0-100), the higher the better; 
	-- for readmission measures (0-100), the lower the rates the better;
	-- thus define final score = effective score - readmission score
	
	-- keep all records from both tables; use union and aggregation strategy instead of 
	-- full outer join to simplify the process
	Drop table hospital_final_score;

	Create table hospital_final_score
	As
	Select providerid
	,hospitalname
	,[state]
	,sum(effective_score) as effective_score
	,sum(readmission_score) as readmission_score
	,sum(effective_score)-sum(readmission_score) as final_score
	,stddev(sum(effective_score)-sum(readmission_score)) as std_final_score
	from
	(Select providerid
	,hospitalname
	,[state]
	,avg_effective_score as effective_score
	,0 as readmission_score
	From hospital_effective_score
	Union All
	Select providerid
	,hospitalname
	,[state]
	,0 as effective_score
	,avg_readmission_score as readmission_score
	From hospital_readmission_score) a
	Group by 
	providerid
	,hospitalname
	,[state];


	--aggreagte final score by state
	Drop table state_final_score;

	Create table state_final_score
	As
	Select [state]
	,avg(effective_score) as effective_score
	,avg(readmission_score) as readmission_score
	,avg(effective_score) - avg(readmission_score) as final_score
	,count(distinct providerid) as hospital_count
	From hospital_final_score
	Group by [state];

--Step 4. Combine Effective and Readmission measure tables to get final score by procedure
	Drop table measure_score;
	
	Create table measure_score
	As
	Select measureid
	,measurename
	,avg_score
	,std_score
	From measure_effective_score
	UNION
	Select measureid
	,measurename
	,avg_score
	,std_score
	From measure_readmission_score
	
--Step 5. Join hospital final score table with survey table
	--still use inner join here as if there is no survey data for a hospital,
	--it doesn't make sense to do the correlation analysis between score and response
	Drop table hospital_score_survey;
	
	Create table hospital_score_survey
	As
	select h.*
	,cast(h.HCAHPSBaseScore as float) as BaseScore
	,cast(h.HCAHPSConsistencyScore as float) as ConsistencyScore
	from hospital_final_score as h
	join survey as s on h.providerid = s.providerid
	
	
