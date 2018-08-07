provider "aws" {
  region = "us-east-1"
}

variable "ssh_key" {
  default = "test"
}

resource "aws_cloudformation_stack" "techtest" {
  name = "techtest-stack"


  parameters {
    SSHKey = "${var.ssh_key}"
  }

  template_body = <<STACK
AWSTemplateFormatVersion: "2010-09-09"
Description: "Tech test vpc, subnet, ec2, Region: us-east-1 only"
Parameters:
  SSHKey:
    Description: SSH key
    Type: AWS::EC2::KeyPair::KeyName

Resources:
  VPC:
    Type: 'AWS::EC2::VPC'
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsSupport: 'true'
      EnableDnsHostnames: 'true'
      InstanceTenancy: default
      Tags:
        - Key: env
          Value: techtest
        - Key: Name
          Value: techtest

  InternetGateway:
    Type: 'AWS::EC2::InternetGateway'
    Properties:
      Tags:
        - Key: env
          Value: techtest

  AttachGateway:
    Type: 'AWS::EC2::VPCGatewayAttachment'
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref InternetGateway

  RouteTable:
    Type: 'AWS::EC2::RouteTable'
    Properties:
      VpcId: !Ref VPC
      Tags:
        - Key: env
          Value: techtest

  Route:
    Type: 'AWS::EC2::Route'
    DependsOn: AttachGateway
    Properties:
      RouteTableId: !Ref RouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref InternetGateway

  PublicSubnet:
    Type: "AWS::EC2::Subnet"
    Properties:
      AvailabilityZone: !Select [ 0, !GetAZs '' ]
      CidrBlock: 10.0.10.0/24
      MapPublicIpOnLaunch: 'true'
      VpcId: !Ref VPC
      Tags:
        - Key: env
          Value: techtest

  SubnetRouteTableAssociation:
    Type: 'AWS::EC2::SubnetRouteTableAssociation'
    Properties:
      SubnetId: !Ref PublicSubnet
      RouteTableId: !Ref RouteTable

  EC2InstanceSecurityGroup:
    Properties:
      GroupDescription: Allow inbound on port 22 from anywhere
      SecurityGroupIngress:
        - FromPort: '22'
          IpProtocol: tcp
          CidrIp: 0.0.0.0/0
          ToPort: '22'
      VpcId: !Ref 'VPC'
    Type: AWS::EC2::SecurityGroup

  EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-b70554c8
      InstanceType: t2.nano
      KeyName: !Ref SSHKey
      SecurityGroupIds:
      - !Ref EC2InstanceSecurityGroup
      SubnetId: !Ref PublicSubnet
      Tags:
        - Key: env
          Value: techtest
        - Key: Name
          Value: techtest

STACK
}
