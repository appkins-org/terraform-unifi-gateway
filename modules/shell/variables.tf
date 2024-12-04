variable "create" {
  type        = string
  description = "The content of the create script"
  default     = null
}

variable "delete" {
  type        = string
  description = "The content of the delete script"
  default     = null
}

variable "environment" {
  type        = map(string)
  description = "The environment variables to set for the shell script"
  default     = {}
  nullable    = false
}

variable "host" {
  type        = string
  description = "SSH host"
}

variable "port" {
  type        = number
  description = "SSH port"
  default     = 22
  nullable    = false
}

variable "read" {
  type        = string
  description = "The content of the read script"
  default     = null
}

variable "update" {
  type        = string
  description = "The content of the update script"
  default     = null
}

variable "username" {
  type        = string
  description = "SSH username"
  default     = "root"
  nullable    = false
}
