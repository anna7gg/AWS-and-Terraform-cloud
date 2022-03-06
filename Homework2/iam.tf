resource "aws_iam_role" "s3_write" {
  name = "s3_write"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
      tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "s3_write_profile" {
  name = "s3_write_profile"
  role = aws_iam_role.s3_write.name
}
resource "aws_iam_role_policy" "write_s3_policy" {
  name = "write_s3_policy"
  role = aws_iam_role.s3_write.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}