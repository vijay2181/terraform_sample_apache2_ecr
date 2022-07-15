resource "aws_iam_role" "ecr_access_role" {
  name               = "RCX-Demo-Sales-Config-UI-Instance-Role"
  assume_role_policy = "${file("assumerolepolicy.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = "RCX-Config-Demo-Sales-Config-UI-ECR-Managed-Policy"
  description = "Policy for pulling ECR images"
  policy      = "${file("iampolicy.json")}"
}

resource "aws_iam_policy_attachment" "policy-attach" {
  name       = "policy-attachment"
  roles      = ["${aws_iam_role.ecr_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "configui_profile" {
  name  = "configui_profile"
  role = "${aws_iam_role.ecr_access_role.name}"
}
