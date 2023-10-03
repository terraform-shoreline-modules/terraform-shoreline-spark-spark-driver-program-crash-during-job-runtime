terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "spark_driver_program_crash_during_job_runtime" {
  source    = "./modules/spark_driver_program_crash_during_job_runtime"

  providers = {
    shoreline = shoreline
  }
}