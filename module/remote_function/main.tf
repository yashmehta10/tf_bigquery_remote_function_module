# Create external connection for BigQuery 
resource "google_bigquery_connection" "main" {
  connection_id = var.bigquery_external_connection_name
  project       = var.gcp_project
  location      = var.location
  cloud_resource {}
}

# Create remote function using SQL
resource "null_resource" "create_remote_function" {
  provisioner "local-exec" {
    command = templatefile("${var.template_file_path}", {
      project_id        = "${var.gcp_project}"
      dataset_id        = "${var.bigquery_dataset}"
      function_name     = "${var.bigquery_function_name}"
      location          = "${var.location}"
      connection_name   = "${split("/", google_bigquery_connection.main.id)[5]}"
      endpoint_url      = "${var.endpoint_url}"
      max_batching_rows = "${var.remote_function_max_batch_size}"
    })
  }
  triggers = {
    bigquery_dataset       = var.bigquery_dataset,
    bigquery_function_name = var.bigquery_function_name,
    endpoint_url           = var.endpoint_url,
    max_batch_size         = var.remote_function_max_batch_size,
    connection_id          = google_bigquery_connection.main.id
  }
}