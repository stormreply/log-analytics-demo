output "artifact" {
  description = <<-EOD
    Artifact to be shown as a download link on the Github Action
    Workflow execution page.
  EOD
  value       = local.zeppelin_notebook
}
