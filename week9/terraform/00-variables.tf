variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "theowaf-class75-ahmadqadafi"
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone."
  type        = string
  default     = "us-central1-a"
}

variable "zones" {
  description = "GCP zones."
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}