variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev"
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
        Component = "frontend"
    }
}

variable "zone_name" {
  default = "akhildev.online"
}

# created as part of jenkins CD
variable "app_version"{

}

variable "instance_password" {
  description = "SSH password for the ec2-user account used during golden-AMI provisioning. Supply via a gitignored terraform.tfvars or TF_VAR_instance_password — never commit a value here."
  type        = string
  sensitive   = true
}
