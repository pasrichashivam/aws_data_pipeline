resource "aws_glue_catalog_database" "analytics_db" {
  name = "${var.app_name}_${var.environment}_analytics"
}
