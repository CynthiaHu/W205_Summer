drop table hospital;

create external table hospital
(
ProvideID string,
HospitalName string,
Address string,
City string,
[State] string,
ZIPCode string,
CountyName string,
PhoneNumber string,
HospitalType string, 
HospitalOwnership string,
EmergencyServices string
)

ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/hospital' ;


drop table effective;

create external table effective
(
ProviderID string,
HospitalName string,
Address string,
City string,
[State] string,
ZIPCode string,
CountyName string,
PhoneNumber string,
Condition string,
MeasureID string,
MeasureName string,
Score string,
Sample string,
Footnote string,
MeasureStartDate string,
MeasureEndDate string)

ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/effective'   
;


drop table readmission;

create external table readmission
(
ProviderID string,
HospitalName string,
Address string,
City string,
[State] string,
ZIPCode string,
CountyName string,
PhoneNumber string,
MeasureName string,
MeasureID string,
ComparedToNational string,
Denominator string,
Score string,
LowerEstimate string,
HigherEstimate string,
Footnote string,
MeasureStartDate string,
MeasureEndDate string
)

ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/readmission'   
;

drop table measure;

create external table measure
(
MeasureName string,
MeasureID string,
MeasureStartQuarter string,
MeasureStartDate string,
MeasureEndQuarter string,
MeasureEndDate string
)

ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/measure'   
;


drop table survey;

create external table survey
(
ProviderID string,
HospitalName string,
Address string,
City string,
[State] string,
ZIPCode string,
CountyName string,
CommunicationwithNursesAchievementPoints string,
CommunicationwithNursesImprovementPoints string,
CommunicationwithNursesDimensionScore string,
CommunicationwithDoctorsAchievementPoints string,
CommunicationwithDoctorsImprovementPoints string,
CommunicationwithDoctorsDimensionScore string,
ResponsivenessofHospitalStaffAchievementPoints string,
ResponsivenessofHospitalStaffImprovementPoints string,
ResponsivenessofHospitalStaffDimensionScore string,
PainManagementAchievementPoints string,
PainManagementImprovementPoints string,
PainManagementDimensionScore string,
CommunicationaboutMedicinesAchievementPoints string,
CommunicationaboutMedicinesImprovementPoints string,
CommunicationaboutMedicinesDimensionScore string,
CleanlinessandQuietnessofHospitalEnvironmentAchievementPo string,
CleanlinessandQuietnessofHospitalEnvironmentImprovementPo string,
CleanlinessandQuietnessofHospitalEnvironmentDimensionScor string,
DischargeInformationAchievementPoints string,
DischargeInformationImprovementPoints string,
DischargeInformationDimensionScore string,
OverallRatingofHospitalAchievementPoints string,
OverallRatingofHospitalImprovementPoints string,
OverallRatingofHospitalDimensionScore string,
HCAHPSBaseScore string,
HCAHPSConsistencyScore string
)

ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/survey'   
;
