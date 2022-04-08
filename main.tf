resource "aws_instance"  "myapp-instance" {

  ami                     =    data.aws_ami.myapp-ami.id
  instance_type           =    "t2.micro"
  key_name                =    aws_key_pair.devopsnew.id
  vpc_security_group_ids  =    ["add your sec.grp ID"]
  tags = {
    Name = "myapp"
  }
}

resource "aws_key_pair" "devopsnew" {

  key_name = "devopsnew1"
  public_key = file("path to your key.pub")
  tags = {
    Name = "devopsnew1"
  }
}
