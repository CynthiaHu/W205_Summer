# import requied packages
from sklearn.linear_model import Ridge
import numpy as np
import pandas as pd
from sklearn.cross_validation import train_test_split
# from sklearn.metrics import mean_squared_error
# from sklearn.metrics import r2_score
from pyspark import SparkContext
from pyspark.sql import HiveContext

# create Hive Context
sc = SparkContext("local", "simple app")
sqlContext = HiveContext(sc)
# there are some warnings but it should be ok
# input data
rdd = sqlContext.sql("select * from taxi_trip_fcst where TripStartYear >=2016 limit 5000")
df_trip = rdd.toPandas()
# new data for forecast
rdd2 = sqlContext.sql("select * from new_data")
df_new = rdd2.toPandas()

# omit some EDA and sanity check in the .py script which is done in a separate jupyter notebook

# select features and remove null for key variables
columns = ['tripstartmonth', 'weekday','pickupcommunity', 'prcp', 'snow', 'snwd', 'tmax', 'tmin',
       'tobs', 'tripcount', 'totalfare','durationperdriver']
df1 = pd.DataFrame(df_trip, columns=columns)
df1 = df1.dropna()
df1['pickupcommunity']=df1['pickupcommunity'].astype(str)
df1['tripstartmonth']=df1['tripstartmonth'].astype(str)
top_community = ['8','32','28','76','6','7','33','24','56','3']
df1['pickupcommunity']=[c if c in top_community else 'other' for c in df1['pickupcommunity']]
# df1.describe()

# treat month/day/weekday as categorical variables
categorical = ['tripstartmonth', 'weekday','pickupcommunity']
numerical = ['prcp', 'snow', 'snwd', 'tmax', 'tmin','tobs']
# create dummy variables for categorical features
df1_dummy = pd.get_dummies(df1[categorical])
# df1_dummy.head()

# combine numerical features and categorical features
df2 = pd.concat([df1[numerical], df1_dummy], axis=1)

# Partition the dataset in train + validation sets
# could choose to forecast # of trips or total fare or total duration per day per driver
y_du = df1['durationperdriver']
X_train, X_test, y_du_train, y_du_test = train_test_split(df2, y_du, test_size = 0.2, random_state = 0)

y_fa = df1['totalfare']
X_train, X_test, y_fa_train, y_fa_test = train_test_split(df2, y_fa, test_size = 0.2, random_state = 0)

# fit a regularized linear regression model for duration forecast
rdg = Ridge(alpha=2.0)  # alpha is regularization strength
rdg.fit(X_train, y_du_train)
test_pred_du = rdg.predict(X_test)
train_pred_du = rdg.predict(X_train)

# fit a regularized linear regression model for totalfare forecast
rdg2 = Ridge(alpha=1.0)  # alpha is regularization strength
rdg2.fit(X_train, y_fa_train)
test_pred_fa = rdg2.predict(X_test)
train_pred_fa = rdg2.predict(X_train)

# forecast new dataset
# this would be a mock up for the dashboard
df_new['pickupcommunity']=df_new['pickupcommunity'].astype(str)
df_new['tripstartmonth']=df_new['tripstartmonth'].astype(str)
# convert the new data to the same structure as training data
other = ['tripstartdate','startdate_str']
df_new_dummy = pd.get_dummies(df_new[categorical])
df2_new = pd.concat([df_new[numerical], df_new_dummy], axis=1)
df2_new = df2_new.dropna()
df2_new = df2_new[list(X_train.columns)]

# apply the fit models to new data set to get forecast
new_pred_du = rdg.predict(df2_new)
new_pred_fa = rdg2.predict(df2_new)

# combine forecast with original new data set
df_new = df_new[df_new['weekday'] != '']
df_new['DurationFcst'] = new_pred_du #372
df_new['FareFcst'] = new_pred_fa
# due to linear regression limitation, some forecast are negative
# override negative forecast with zero
df_new.loc[df_new['DurationFcst']<0,'DurationFcst'] = 0
df_new.loc[df_new['FareFcst']<0,'FareFcst'] = 0


# write df_new to hive table
# df_new.to_csv('NewDataForecast.csv') # write to /data where the pyspark is
# convert panda dataframe to spark dataframe
sdf = sqlContext.createDataFrame(df_new)
# send spark dataframe to hive
sdf.registerTempTable("temp")
# sqlContext.sql("drop table if exists new_data_forecast")
sqlContext.sql("create table new_data_forecast as select * from temp")


