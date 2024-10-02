locals {
  context = var.context
}

data "http" "manifest_url" {
  for_each = toset(var.crds_urls)
  url      = each.value
}

data "kubectl_file_documents" "manifest_url" {
  for_each = data.http.manifest_url
  content  = each.value.response_body
}

resource "kubectl_manifest" "install_manifest_url" {
  for_each  = { for key, value in data.kubectl_file_documents : key => value.manifests }
  yaml_body = each.value
}
