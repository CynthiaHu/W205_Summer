# assuming already start hadoop, postgres and metastore
# and switch to w205 user

cd $HOME

# Get data into EC2 instance
mkdir hospital_files
cd hospital_files/
wget -O Hospital_Revised_Flatfiles https://data.medicare.gov/views/bg9k-emty/files/Nqcy71p9Ss2RSBWDmP77H1DQXcyacr2khotGbDHHW_s?content_type=application%2Fzip%3B%20charset%3Dbinary&filename=Hospital_Revised_Flatfiles.zip
unzip Hospital_Revised_Flatfiles
ls

# Put relevant files into HDFS
# first, remove space in the file name
mv "Hospital General Information.csv" Hospital_General_Information.csv
mv "Timely and Effective Care - Hospital.csv" Timely_and_Effective_Care_Hospital.csv
mv "Readmissions and Deaths - Hospital.csv" Readmissions_and_Deaths_Hospital.csv
mv "Measure Dates.csv" Measure_Dates.csv

# second, strip the header line
tail -n +2 Hospital_General_Information.csv  > Hospital_No_Header.csv
tail -n +2 Timely_and_Effective_Care_Hospital.csv > Effective_Care_Hospital_No_Header.csv
tail -n +2 Readmissions_and_Deaths_Hospital.csv > Readmission_Hospital_No_Header.csv
tail -n +2 Measure_Dates.csv > Measure_Dates_No_Header.csv
tail -n +2 hvbp_hcahps_05_28_2015.csv > Survey_Response_No_Header.csv

# next, move local files to HDFS
# for creating hive tables later, save files in separate subfolders under hospital compare
hdfs dfs -mkdir hospital_compare
hdfs dfs -mkdir hospital_compare/hospital
hdfs dfs -mkdir hospital_compare/effective
hdfs dfs -mkdir hospital_compare/readmission
hdfs dfs -mkdir hospital_compare/measure
hdfs dfs -mkdir hospital_compare/survey
# move files to the folders
hdfs dfs -put Hospital_No_Header.csv hospital_compare/hospital
hdfs dfs -put Effective_Care_Hospital_No_Header.csv hospital_compare/effective
hdfs dfs -put Readmission_Hospital_No_Header.csv hospital_compare/readmission
hdfs dfs -put Measure_Dates_No_Header.csv hospital_compare/measure
hdfs dfs -put Survey_Response_No_Header.csv hospital_compare/survey

# check directory and files are in the right place
hdfs dfs -ls /user/w205/hospital_compare


