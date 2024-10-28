variable "config_context_site" {
  type        = string
  description = "Config context for k8s (site)"
}


variable "access_codes" {
  description = "List of access codes"
  type        = list(string)
}
