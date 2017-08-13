# need to use python 2.7 or 3.0 for the forecast

# let's install python 3 as a root user
sudo yum install python34

# also need to install the appropriate pip version for python3.4
curl https://bootstrap.pypa.io/get-pip.py | python3.4
python3.4 -m pip install -U setuptools

# then install the package for the selected version of python
python3.4 -m pip install pandas
python3.4 -m pip install numpy
python3.4 -m pip install matplotlib
python3.4 -m pip install sklearn
python3.4 -m pip install scipy

# before start pyspark, set up the python version
cd /data
su - w205
export PYSPARK_PYTHON=python3
/data/spark15/bin/pyspark


