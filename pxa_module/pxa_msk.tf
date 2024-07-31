resource "aws_msk_cluster" "msk" {
  cluster_name           = "${local.pxa_prefix}-msk"
  kafka_version          = "3.6.0"
  number_of_broker_nodes = local.pxa_config.msk.number_of_broker_nodes

  broker_node_group_info {
    instance_type  = local.pxa_config.msk.instance_type
    client_subnets = local.vpc.subnets.private
    storage_info {
      ebs_storage_info {
        volume_size = local.pxa_config.msk.volume_size
      }
    }
    security_groups = [aws_security_group.sg_allow_msk.id]
  }
  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.lg_msk.name
      }
    }
  }
  configuration_info {
    arn      = aws_msk_configuration.msk_config.arn
    revision = aws_msk_configuration.msk_config.latest_revision
  }
  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
    }
  }
  client_authentication {
    unauthenticated = true
  }

  tags = {
    Name        = "${local.pxa_prefix}-msk"
    Project     = "${local.pxa_project_name}"
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_cloudwatch_log_group" "lg_msk" {
  name = "/aws/msk/${local.pxa_prefix}"

  tags = {
    Name        = "${local.pxa_prefix}-lg-msk"
    Project     = "${local.pxa_project_name}"
    Customer    = var.PROJECT_CUSTOMER
    Environment = var.PROJECT_ENV
    Terraform   = true
  }
}

resource "aws_msk_configuration" "msk_config" {
  kafka_versions = ["3.4.0"]
  name           = "${local.pxa_prefix}-msk-config"

  server_properties = <<PROPERTIES
auto.create.topics.enable = true
delete.topic.enable = true
default.replication.factor=3
min.insync.replicas=1
num.io.threads=8
num.network.threads=5
num.partitions=1
num.replica.fetchers=2
offsets.topic.replication.factor=1
replica.lag.time.max.ms=30000
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
socket.send.buffer.bytes=102400
unclean.leader.election.enable=false
zookeeper.session.timeout.ms=18000
PROPERTIES
}


