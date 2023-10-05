resource "shoreline_notebook" "spark_hdfs_connectivity_issue_incident" {
  name       = "spark_hdfs_connectivity_issue_incident"
  data       = file("${path.module}/data/spark_hdfs_connectivity_issue_incident.json")
  depends_on = [shoreline_action.invoke_config_check,shoreline_action.invoke_restart_spark_hdfs_services]
}

resource "shoreline_file" "config_check" {
  name             = "config_check"
  input_file       = "${path.module}/data/config_check.sh"
  md5              = filemd5("${path.module}/data/config_check.sh")
  description      = "Incorrect configuration of Spark or HDFS settings"
  destination_path = "/agent/scripts/config_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_spark_hdfs_services" {
  name             = "restart_spark_hdfs_services"
  input_file       = "${path.module}/data/restart_spark_hdfs_services.sh"
  md5              = filemd5("${path.module}/data/restart_spark_hdfs_services.sh")
  description      = "Try restarting the Spark and HDFS services to see if that resolves the connectivity issue."
  destination_path = "/agent/scripts/restart_spark_hdfs_services.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_config_check" {
  name        = "invoke_config_check"
  description = "Incorrect configuration of Spark or HDFS settings"
  command     = "`chmod +x /agent/scripts/config_check.sh && /agent/scripts/config_check.sh`"
  params      = ["PATH_TO_HADOOP_CONFIGURATION_DIRECTORY","PATH_TO_SPARK_CONFIGURATION_DIRECTORY"]
  file_deps   = ["config_check"]
  enabled     = true
  depends_on  = [shoreline_file.config_check]
}

resource "shoreline_action" "invoke_restart_spark_hdfs_services" {
  name        = "invoke_restart_spark_hdfs_services"
  description = "Try restarting the Spark and HDFS services to see if that resolves the connectivity issue."
  command     = "`chmod +x /agent/scripts/restart_spark_hdfs_services.sh && /agent/scripts/restart_spark_hdfs_services.sh`"
  params      = ["HDFS_SERVICE_NAME","SPARK_SERVICE_NAME"]
  file_deps   = ["restart_spark_hdfs_services"]
  enabled     = true
  depends_on  = [shoreline_file.restart_spark_hdfs_services]
}

