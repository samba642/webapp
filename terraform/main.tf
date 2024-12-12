module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "devops-assessment-cluster"
  cluster_version = "1.25"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_ids
}
