Example resource to demonstrate requirements. 

# Features

- Resource with a required and optional parameter
- Additional parameter that defaults to null

# Usage

```
module "example" {
  source         = "github.com/CloudNation-nl/aws-terraform-modules//modules/example/v0.0.1"
  requiredparam1 = "value"
}
```

# Inputs



| Input  | Required  | Purpose  | Default  | Type | Example  |
|---|---|---|---|---|
| requiredparam  | Y  | Sets a required input  | n/a  | string | myexampleresource  |
| defaultparam  | N  | Sets an input that has a default  | mydefaultvalue  | string | mychangedvalue |
| optionalparam  | N  | Sets an input that is optional  | null  | boolean | True  |

# Outputs
| Output Name | Description   | Conditional  | Example |
|---|---|---|---|
| arn  | the ARN of the resource   | N  | arn:aws:infinifash::123456789012:dash/myexample |
| name  | the name of the resource  | N  | myexampleresource |
| URL  | The URL of the resource, if enabled  | Y  | https://lorus.ips.um |

# CHANGELOG

v0.0.1
- Added this example README with fake resources