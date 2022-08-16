Example bucket to test module usage. 

# Usage

```module "s3" {
  source = "github.com/CloudNation-nl/aws-terraform-modules//s3/v0.0.1"
  bucket = "mybucket"
}
```

# CHANGELOG

v0.0.2
- Added `othername` to bucket to verify changes between modules.