
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Spark HDFS Connectivity Issue Incident
---

The Spark HDFS Connectivity Issue Incident refers to a situation where there is a problem with the connectivity between Apache Spark and Hadoop Distributed File System (HDFS). This can result in Spark being unable to access data stored in HDFS or facing performance issues due to slow connectivity. This type of incident can be caused by various factors such as network issues, misconfiguration, or software bugs. It can impact the overall functioning of Spark-based applications and require immediate attention to ensure smooth operations.

### Parameters
```shell
export PORT="PLACEHOLDER"

export NAMENODE="PLACEHOLDER"

export PATH_TO_HADOOP_CONFIGURATION_DIRECTORY="PLACEHOLDER"

export PATH_TO_SPARK_CONFIGURATION_DIRECTORY="PLACEHOLDER"

export HDFS_SERVICE_NAME="PLACEHOLDER"

export SPARK_SERVICE_NAME="PLACEHOLDER"
```

## Debug

### Check if Spark is running
```shell
systemctl status spark | grep 'Active: active (running)' || echo 'Spark is not running'
```

### Check if HDFS is running
```shell
systemctl status hdfs | grep 'Active: active (running)' || echo 'HDFS is not running'
```

### Check if Spark can connect to HDFS via Hadoop command line
```shell
spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode client --driver-memory 1g --executor-memory 1g --executor-cores 1 --num-executors 1 /path/to/examples.jar yarn-client hdfs://${NAMENODE}:${PORT}/ || echo 'Spark cannot connect to HDFS'
```

### Check if HDFS can be accessed via Hadoop command line
```shell
hdfs dfs -ls hdfs://${NAMENODE}:${PORT}/ || echo 'Cannot access HDFS via Hadoop command line'
```

### Incorrect configuration of Spark or HDFS settings
```shell
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


```

## Repair

### Try restarting the Spark and HDFS services to see if that resolves the connectivity issue.
```shell


#!/bin/bash



# Restart Spark and HDFS services

service ${SPARK_SERVICE_NAME} restart

service ${HDFS_SERVICE_NAME} restart



# Check if services have started successfully

if (( $(ps -ef | grep -v grep | grep ${SPARK_SERVICE_NAME} | wc -l) > 0 )) && (( $(ps -ef | grep -v grep | grep ${HDFS_SERVICE_NAME} | wc -l) > 0 )); then

    echo "Spark and HDFS services restarted successfully."

else

    echo "Failed to restart Spark and HDFS services."

fi


```