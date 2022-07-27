resource "aws_iam_role" "ecr_access_role" {
  name               = "Instance-Role"
  assume_role_policy = "${file("./policy/assumerolepolicy.json")}"
}

resource "aws_iam_policy" "policy-1" {
  name        = "ECR-Policy"
  description = "Policy for pulling ECR images"
  policy      = "${file("./policy/iampolicy.json")}"
}

resource "aws_iam_policy" "policy-2" {
  name        = "SSM-Policy"
  description = "Policy for SSM"
  policy      = "${file("./policy/ssmpolicy.json")}"
}

resource "aws_iam_policy" "policy-3" {
  name        = "Key-Policy"
  description = "Policy for Key"
  policy      = "${file("./policy/keypolicy.json")}"
}

resource "aws_iam_policy_attachment" "policy-attach1" {
  name       = "policy-attachment1"
  roles      = ["${aws_iam_role.ecr_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy-1.arn}"
}

resource "aws_iam_policy_attachment" "policy-attach2" {
  name       = "policy-attachment2"
  roles      = ["${aws_iam_role.ecr_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy-2.arn}"
}

resource "aws_iam_policy_attachment" "policy-attach3" {
  name       = "policy-attachment3"
  roles      = ["${aws_iam_role.ecr_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy-3.arn}"
}

resource "aws_iam_instance_profile" "vijay_profile" {
  name  = "vijay_profile"
  role = "${aws_iam_role.ecr_access_role.name}"
}
