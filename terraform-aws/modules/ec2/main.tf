resource "aws_instance" "ec2-instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  count         = var.instance_count
  user_data = base64encode(file("${path.module}/user-data.sh")) 

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  vpc_security_group_ids = var.security_group_ids
  
  subnet_id = element(var.subnet_ids, count.index % length(var.subnet_ids))

  tags = merge(
    {
      Name        = "${var.environment}-${var.application}"
      Environment = var.environment
      Owner       = var.owner
      CostCenter  = var.cost_center
      Application = var.application
    },
    var.tags
  )
}