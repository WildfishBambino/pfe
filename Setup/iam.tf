####      Creating user and access key for CD

resource "aws_iam_user" "cd" {
    name = "cd-user"
}

resource "aws_iam_access_key" "cd" {
    user = aws_iam_user.cd.name
}

###       Defining IAM policy for s3 and Dynamodb table 

data "aws_iam_policy_document" "tf_backend" {
    statement {
        effect = "Allow"
        actions = ["s3:ListBucket"]
        resources = ["arn:aws:s3:::${var.tf-state-bucket}"]
    }
    
    statement {
        effect = "Allow"
        actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        resources = [
            "arn:aws:s3:::${var.tf-state-bucket}/tf-state-deploy/*",
            "arn:aws:s3:::${var.tf-state-bucket}/tf-state-deploy-env/*"
        ]
    }

    statement {
        effect = "Allow"
        actions = [
            "dynamodb:DescribeTable",
            "dynamodb:GetItem", 
            "dynamodb:PutItem",
            "dynamodb:DeleteItem"
        ]
        resources = ["arn:aws:dynamodb:*:*:table/${var.tf-state-lock}"]
    }
}


### Allow CD user to use s3 and DynamoDB table 

resource "aws_iam_policy" "tf_backend" {
    name = "${aws_iam_user.cd.name}-tf-s3-dynamodb"
    policy = data.aws_iam_policy_document.tf_backend.json
}

### Attaching the policy to the CD user 

resource "aws_iam_user_policy_attachment" "tf_backend" {
    user = aws_iam_user.cd.name
    policy_arn = aws_iam_policy.tf_backend.arn
}