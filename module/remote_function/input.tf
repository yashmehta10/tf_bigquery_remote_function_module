variable "gcp_project" {
  description = "GCP Project to create resources in"
  type        = string
}

variable "location" {
  description = "Location used for resources i.e. BigQuery dataset and remote function. Should be in the same location"
  type        = string
}

variable "bigquery_dataset" {
  description = "The dataset to create the remote function in"
  type        = string
}

variable "bigquery_function_name" {
  description = "The name of function to be used in bigquery"
  type        = string
}

variable "bigquery_external_connection_name" {
  description = "BigQuery external connection name. Used to create a new connection that allows BigQuery connections to external data sources"
  type        = string
}

variable "endpoint_url" {
  description = "Cloud function or CLoud run HTTP/s URL endoint"
  type        = string
}

variable "remote_function_max_batch_size" {
  description = "Maximum records to send to a single cloud function instance. Ensure is set to abide by cloud function "
  type        = number
}

variable "template_file_path" {
  description = "SQL template location"
  type        = string
}
