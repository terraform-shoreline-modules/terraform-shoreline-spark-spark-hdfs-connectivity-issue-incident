

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