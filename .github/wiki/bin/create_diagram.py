"""
It uses diagrams lib to create infrastructure diagram.

Installation details: https://diagrams.mingrammer.com/docs/getting-started/installation
"""
from diagrams import Cluster, Diagram
from diagrams.aws.compute import Fargate
from diagrams.aws.database import ElastiCache, RDS
from diagrams.aws.network import ALB
from diagrams.aws.storage import S3
from diagrams.aws.security import SecretsManager
from diagrams.aws.compute import EC2Instance
from diagrams.aws.management import Cloudwatch
from diagrams.generic.network import Subnet
from diagrams.aws.compute import ECR


def main():
    with Diagram("Infrastructure Diagram", show=False):
        SecretsManager("Secrets Manager")
        S3("S3")

        entry = Subnet("Entry")

        lb = ALB("ALB")

        Cloudwatch("CloudWatch")

        ecr = ECR("AWS ECR")

        with Cluster("VPC"):
            bastion = EC2Instance("Bastion")

            with Cluster("Auto scaling groups"):
                with Cluster("ap-southeash-1a"):
                    fargate_zone_one = Fargate("Fargate")
                with Cluster("ap-southeash-1b"):
                    fargate_zone_two = Fargate("Fargate")

                fargate_list = [fargate_zone_one, fargate_zone_two]

            db_primary = RDS("AZ RDS")
            cache = ElastiCache("AZ ElastiCache")

            entry >> lb >> fargate_list
            entry >> bastion
            fargate_list >> db_primary
            fargate_list >> cache
            ecr >> fargate_list


if __name__ == "__main__":
    main()
