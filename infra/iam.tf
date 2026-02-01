resource "aws_iam_role" "emr_serverless_role" {
  name = local.app_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "emr-serverless.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  tags = {
    Name = local.app_role_name
  }
}

resource "aws_iam_policy" "emr_policy" {
  name = "emr-serverless-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "bucketActions",
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.source_bucket}"
        ]
      },
      {
        "Sid": "GlueCatalog",
        Effect = "Allow"
        Action = [
          "glue:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "Logs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
	"Statement": [
		{
			"Action": [
				"s3:GetObject",
				"s3:ListBucket"
			],
			"Effect": "Allow",
			"Resource": [
				"arn:aws:s3:::raw-bucket-dev-source",
        "arn:aws:s3:::${var.artifacts_bucket}/*"

			],
			"Sid": "bucketActions"
		},
		{
			"Action": [
				"glue:*"
			],
			"Effect": "Allow",
			"Resource": "*",
			"Sid": "GlueCatalog"
		},
		{
      "Effect": "Allow",
      "Action": "iam:PassRole",
      "Resource": [
          "arn:aws:iam::${var.account}:role/service-role/AmazonMWAA-data_engineering_mwaa_env-34mTr5"
      ],
      "Condition": {
          "StringEquals": {
              "iam:PassedToService": "airflow.amazonaws.com"
          }
      }
    },
		{
			"Action": [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents"
			],
			"Effect": "Allow",
			"Resource": "*",
			"Sid": "Logs"
		}
	],
	"Version": "2012-10-17"
}
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.emr_serverless_role.name
  policy_arn = aws_iam_policy.emr_policy.arn
}
