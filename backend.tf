terraform {
    backend "s3" {
        bucket         = "bucket-for-trigger"
        key            = "global/s3/gl-tf-an.tfstate"
        region         = "eu-central-1"
        encrypt        = true
    }
}