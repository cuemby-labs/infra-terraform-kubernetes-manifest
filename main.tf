locals {
  context = var.context
}

data "http" "manifest_url" {
  for_each = toset(var.manifests_urls)
  url      = each.value
}

data "kubectl_file_documents" "manifest_url" {
  for_each = data.http.manifest_url
  content  = each.value.response_body
}

resource "kubectl_manifest" "install_manifest_url" {
  for_each  = { for key, doc in data.kubectl_file_documents : key => doc.documents }
  yaml_body = each.value
}
