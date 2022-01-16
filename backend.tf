terraform {
  backend "s3" {
    bucket = "cloudcomputingwithdsh.com"
    key    = "terraformstatefile.tf"
    region = "us-east-1"
    access_key = "AKIAUXSNRRCUD4W4OLR3"
    secret_key = "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"
    #dynamodb_table = "danish"
  }
}