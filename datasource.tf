data "aws_ami" "myapp-ami" {
  owners = ["self"]
  most_recent = true

  filter {
    name = "tag:Name"
    values = ["myapp-version-*"]
        }
  filter {
        name = "tag:env"
    values = ["prod"]
        }
  filter {
        name = "tag:project"
    values = ["uber"]
        }
}
