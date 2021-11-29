resource "aws_db_instance" "giffon" {
  allocated_storage               = 20
  engine                          = "mysql"
  engine_version                  = "5.7.33"
  instance_class                  = "db.t2.micro"
  name                            = "giffon"
  username                        = "master"
  parameter_group_name            = "default.mysql5.7"
  copy_tags_to_snapshot           = true
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  publicly_accessible             = true
  skip_final_snapshot             = true
  tags = {
    "workload-type" = "other"
  }
}
