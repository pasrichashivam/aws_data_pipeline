resource "aws_emrserverless_application" "spark_app" {
  name          = "data-engineering-app"
  release_label = "emr-6.15.0"
  type          = "SPARK"

  initial_capacity {
    initial_capacity_type = "Driver"
    initial_capacity_config {
      worker_count = 1
      worker_configuration {
        cpu    = "2 vCPU"
        memory = "4 GB"
      }
    }
  }
}
