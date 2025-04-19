resource "aws_ecr_repository" "app" {
    name = "app-demo"
    image_tag_mutability = "MUTABLE"
    force_delete = true

    image_scanning_configuration {
        ## this needs to be checked "it will disable image vulnerability scanning
        ## will keep it disabled for now 
        scan_on_push = false            
    }   
}

resource "aws_ecr_repository" "proxy" {
    name = "app-demo-proxy"
    image_tag_mutability = "MUTABLE"
    force_delete = true                             
}

#### ECR Access 

data "aws_iam_policy_document" "ecr" {
    statement {
        effect = "Allow"
        actions = ["ecr:GetAuthorizationToken"]
        resources = ["*"]
    }

    statement {
        effect = "Allow"
        actions = [
            "ecr:CompleteLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:InitiateLayerUpload",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage"
        ]
        resources = [
            aws_ecr_repository.app.arn,
            aws_ecr_repository.proxy.arn,
        ]
    }
}

resource "aws_iam_policy" "ecr" {
    name = "${aws_iam_user.cd.name}-ecr"
    policy = data.aws_iam_policy_document.ecr.json
}


resource "aws_iam_user_policy_attachment" "ecr" {
    user = aws_iam_user.cd.name
    policy_arn = aws_iam_policy.ecr.arn
}