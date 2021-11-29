resource "aws_db_instance" "giffon" {
  allocated_storage               = 20
  engine                          = "mysql"
  engine_version                  = "5.7.33"
  instance_class                  = "db.t2.micro"
  name                            = "giffon"
  username                        = "master"
  parameter_group_name            = aws_db_parameter_group.giffon-mysql57.name
  copy_tags_to_snapshot           = true
  deletion_protection             = true
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  publicly_accessible             = true
  skip_final_snapshot             = true
  tags = {
    "workload-type" = "other"
  }
}

resource "aws_db_parameter_group" "giffon-mysql57" {
  name_prefix = "giffon-mysql57-"
  family      = "mysql5.7"

  parameter {
    name         = "gtid-mode"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "enforce_gtid_consistency"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "binlog_format"
    value = "ROW"
  }
}
