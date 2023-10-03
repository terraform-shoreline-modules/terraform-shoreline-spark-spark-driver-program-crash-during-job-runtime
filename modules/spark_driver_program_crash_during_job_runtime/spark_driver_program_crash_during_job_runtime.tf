resource "shoreline_notebook" "spark_driver_program_crash_during_job_runtime" {
  name       = "spark_driver_program_crash_during_job_runtime"
  data       = file("${path.module}/data/spark_driver_program_crash_during_job_runtime.json")
  depends_on = [shoreline_action.invoke_spark_driver_memory_check,shoreline_action.invoke_increase_spark_memory]
}

resource "shoreline_file" "spark_driver_memory_check" {
  name             = "spark_driver_memory_check"
  input_file       = "${path.module}/data/spark_driver_memory_check.sh"
  md5              = filemd5("${path.module}/data/spark_driver_memory_check.sh")
  description      = "Insufficient memory resources allocated to the Spark driver program."
  destination_path = "/agent/scripts/spark_driver_memory_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "increase_spark_memory" {
  name             = "increase_spark_memory"
  input_file       = "${path.module}/data/increase_spark_memory.sh"
  md5              = filemd5("${path.module}/data/increase_spark_memory.sh")
  description      = "Increase the resources allocated to the Spark driver program, such as increasing the memory or the number of CPU cores."
  destination_path = "/agent/scripts/increase_spark_memory.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_spark_driver_memory_check" {
  name        = "invoke_spark_driver_memory_check"
  description = "Insufficient memory resources allocated to the Spark driver program."
  command     = "`chmod +x /agent/scripts/spark_driver_memory_check.sh && /agent/scripts/spark_driver_memory_check.sh`"
  params      = ["MEMORY_SIZE"]
  file_deps   = ["spark_driver_memory_check"]
  enabled     = true
  depends_on  = [shoreline_file.spark_driver_memory_check]
}

resource "shoreline_action" "invoke_increase_spark_memory" {
  name        = "invoke_increase_spark_memory"
  description = "Increase the resources allocated to the Spark driver program, such as increasing the memory or the number of CPU cores."
  command     = "`chmod +x /agent/scripts/increase_spark_memory.sh && /agent/scripts/increase_spark_memory.sh`"
  params      = ["PATH_TO_SPARK_CONF","MEMORY_SIZE","NEW_MEMORY_SIZE"]
  file_deps   = ["increase_spark_memory"]
  enabled     = true
  depends_on  = [shoreline_file.increase_spark_memory]
}

