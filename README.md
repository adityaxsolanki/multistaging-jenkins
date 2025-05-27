
<p align="center">
  <img src="./9b14c1cc-d40f-442c-8e55-e781fa3bde45.png" alt="AppSquadz Logo" width="200" />
</p>

# POC: Importing Manually Created AWS Resources into Terraform Modules

## ✅ Objective
Demonstrate how manually created AWS resources can be imported into Terraform state and restructured into reusable modules for future IaC management.

## 👨‍💻 Author
Aditya – DevOps Intern

## 🛩 Tools Used
- Terraform v1.x
- AWS CLI
- AWS Services: EC2, RDS (MySQL), VPC, S3, Security Groups

## 🧠 What This Proves
- Legacy infrastructure can be managed with Terraform without re-creating it.
- Resources can be modularized post-import for clean, DRY code.
- Terraform state can stay in sync with real infrastructure.

---

## 🏷️ Project Structure

```
terraform-import-poc/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── provider.tf
├── modules/
│   ├── ec2/
│   ├── rds/
│   ├── s3/
│   ├── vpc/
│   └── security_group/
└── README.md
```

---

## 🔧 Terraform Import Commands

```bash
terraform import module.vpc.aws_vpc.main vpc-0f92a9d68599ec2fa
terraform import module.ec2.aws_instance.web i-0de22d71b7c07407a
terraform import module.rds.aws_db_instance.mysql mydb
terraform import module.sg.aws_security_group.main sg-066b4eb78b84710ca
terraform import module.s3.aws_s3_bucket.bucket aditya-demo-bucket-01
```

---

## 🪪 Steps to Run

1. Create a project directory and initialize it:
   ```bash
   mkdir terraform-import-poc && cd terraform-import-poc
   terraform init
   ```

2. Create standard Terraform files:
   ```bash
   touch main.tf variables.tf outputs.tf terraform.tfvars provider.tf
   mkdir -p modules/{ec2,rds,s3,vpc,security_group}
   ```

3. Inside each module folder (e.g., `modules/ec2/`), create:
   ```bash
   touch main.tf variables.tf outputs.tf
   ```

4. Write resource definitions in each module based on your manual AWS setup. Example for EC2:
   ```hcl
   // modules/ec2/main.tf
   resource "aws_instance" "web" {
     ami           = var.ami
     instance_type = var.instance_type
     subnet_id     = var.subnet_id
     key_name      = var.key_name
     tags = {
       Name = "ImportedEC2"
     }
   }
   ```

5. Use module blocks in `main.tf` to call each module.

6. Run `terraform init` to initialize modules.

7. Use the above import commands to map real AWS resources to Terraform.

8. Run `terraform plan` to verify state.

9. Apply if needed:
   ```bash
   terraform apply
   ```

---

## 📌 Notes
- Use separate state files per environment in production.
- Consider using remote backends for collaboration (e.g., S3 + DynamoDB).
