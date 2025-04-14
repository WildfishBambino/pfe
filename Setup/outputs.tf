output "cd_user_access_key_id" {
    description = "AWS KeyID for CD user"
    value = aws_iam_access_key.cd.id
}

output "cd_user_access_key_secret" {
   description = "password for CD user"
   value = aws_iam_access_key.cd.secret 
   sensitive = true
}

output "ecr_repo_app" {
    description = "ECR app repo URL"
    value = aws_ecr_repository.app.repository_url
}

output "ecr_repo_proxy" {
    description = "ECR proxy repo URL"
    value = aws_ecr_repository.proxy.repository_url
}