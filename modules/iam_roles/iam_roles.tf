
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    effect = "Allow"
  }
}

# Create the IAM role using the policy document
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# Attach the ECS Task Execution Role policy
resource "aws_iam_role_policy_attachment" "ecsTaskExecution_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
