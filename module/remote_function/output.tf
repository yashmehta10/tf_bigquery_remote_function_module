output "connection_service_account" {
  value = google_bigquery_connection.main.cloud_resource[0].service_account_id
}