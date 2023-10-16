## BigQuery remote function Terraform module

Terraform module which create a BigQuery external connection and a remote function. Remote function creation is only possible through SQL or BigQuery DataFrames, hence we need to create a null_resource to execute the query using `bq` CLI to integrate with existing Terraform infrastructure.

- [Creating remote function](https://cloud.google.com/bigquery/docs/remote-functions#create_a_remote_function_2)
- [Terraform null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource)
- [Remote function end-to-end guide](https://cloud.google.com/bigquery/docs/remote-functions#terraform)
- [bq cli guide](https://cloud.google.com/bigquery/docs/bq-command-line-tool)

### Usage
- Call the module by specifying the source
- Update the input variables 

```
module "remote_function" {
  source = "github.com/yashmehta10/tf_bigquery_remote_function_module"
  gcp_project = var.project_id
  location = var.location
  bigquery_dataset = google_bigquery_dataset.remote_function_dataset.dataset_id
  bigquery_function_name = "add_one"
  bigquery_external_connection_name = "remote_function_connection"
  endpoint_url = "https://australia-southeast1-yash-mehta-sandbox-398106.cloudfunctions.net/remote_function"
  remote_function_max_batch_size = 1000
  template_file_path = "./templates/remote_functions.sql.tfpl"
}
```

##### Template file - [remote_functions.sql.tfpl](tf_bigquery_remote_function/templates/remote_functions.sql.tfpl)

To update the template file, only update `(x NUMERIC) RETURNS NUMERIC` input parameters and output data types. All other templated variables i.e. `${variable_name}` will be populated by Terraform
```
#!/bin/bash

bq query --use_legacy_sql=false \
'CREATE FUNCTION `${project_id}.${dataset_id}`.${function_name}(x NUMERIC) RETURNS NUMERIC
REMOTE WITH CONNECTION `${project_id}.${location}.${connection_name}`
OPTIONS (
  endpoint = "${endpoint_url}",
  max_batching_rows = ${max_batching_rows}
)'
```

##### Other perepheral resources - [sample.tf](remote_functions.sql.tfpl)

This file contains all the resources required to setup a remote function. The following resources are created outside the module and hence are configurable to match with your current infrastructure patterns. 
1. Project Service APIs
    1. cloudfunctions.googleapis.com
    2. cloudbuild.googleapis.com
    3. bigqueryconnection.googleapis.com
2. Cloud function (Could also run with Cloud Run as remote function only requires target URL)
    1. GCS bucket to store Cloud Function source code
    2. Archive resource to zip local file
    3. GCS bucket object to upload local zip file to the GCS bucket
    4. Cloud Function 
    5. Cloud Function IAM (roles/cloudfunctions.invoker to BQ external connection service account)
3. BigQuery
    1. BigQuery dataset to hold remote function definition