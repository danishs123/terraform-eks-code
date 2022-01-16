module "eks" {
  source = "./modules/eks"

  project                     =   "${var.project}"
  environment                 =   "${var.environment}"
  public-subnet-ids           =   "${var.public-subnet-ids}"
  private-subnet-ids          =   "${var.private-subnet-ids}"
  eks-version                 =   "${var.eks-version}"
  eks-cluster-iam-role-arn    =   "${module.iam.cluster-iam-role-arn}"
  eks-cluster-sg-id           =   ["${module.sg.cluster-security-groups}"]
  service_depends_on          =   ["${module.iam.cluster-iam-role-arn}"]
}

module "iam" {
  source = "./modules/iam"

  project               =   "${var.project}"
  environment           =   "${var.environment}"
}

module "sg" {
  source = "./modules/sg"

  project               =   "${var.project}"
  environment           =   "${var.environment}"
  cidr-blocks           =   "${var.cidr-blocks}"
  vpc-id                =   "${var.vpc-id}"
}

module "nodes" {
  source = "./modules/nodes"

  eks-name                  =   "${module.eks.eks-name}"
  node-role-arn             =   "${module.iam.node-iam-role-arn}"
  node-group-name           =   flatten(["${var.node-group-name}"])
  node-group-count          =   "${var.node-group-count}"
  node-private-subnet-ids   =   "${var.node-private-subnet-ids}"
  ami-type                  =   "${var.ami-type}"
  ec2-instance-type         =   "${var.ec2-instance-type}"
  disk-size                 =   "${var.disk-size}"
  node-security-groups      =   ["${module.sg.node-security-groups}"]
  desired-size              =   "${var.desired-size}"
  max-size                  =   "${var.max-size}"
  min-size                  =   "${var.min-size}"
  ec2-ssh-key               =   "${var.ec2-ssh-key}"
  node_service_depends_on   =   ["${module.iam.node-iam-role-arn}"]
}