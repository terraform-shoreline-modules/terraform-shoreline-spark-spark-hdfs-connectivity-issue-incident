bash

#!/bin/bash



# Set the paths to the Spark and Hadoop configuration files

SPARK_CONF_DIR=${PATH_TO_SPARK_CONFIGURATION_DIRECTORY}

HADOOP_CONF_DIR=${PATH_TO_HADOOP_CONFIGURATION_DIRECTORY}



# Check if the configuration files exist

if [ ! -f "${SPARK_CONF_DIR}/spark-defaults.conf" ] || [ ! -f "${HADOOP_CONF_DIR}/core-site.xml" ] || [ ! -f "${HADOOP_CONF_DIR}/hdfs-site.xml" ]; then

  echo "ERROR: Spark or Hadoop configuration files not found"

  exit 1

fi



# Check if the configuration files have the correct settings

if ! grep -q "spark.master" "${SPARK_CONF_DIR}/spark-defaults.conf"; then

  echo "ERROR: spark.master configuration not found in Spark configuration file"

  exit 1

fi



if ! grep -q "fs.defaultFS" "${HADOOP_CONF_DIR}/core-site.xml"; then

  echo "ERROR: fs.defaultFS configuration not found in Hadoop core-site.xml file"

  exit 1

fi



if ! grep -q "dfs.replication" "${HADOOP_CONF_DIR}/hdfs-site.xml"; then

  echo "ERROR: dfs.replication configuration not found in Hadoop hdfs-site.xml file"

  exit 1

fi



# If all checks pass, print a success message

echo "Spark and Hadoop configurations are correct"

exit 0