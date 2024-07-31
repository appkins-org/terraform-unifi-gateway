variable "create_parents" {
  description = "Create parent directories if they do not exist."
  type        = bool
  default     = true
  nullable    = false
}

variable "commands" {
  description = "Commands to run on the server."
  type        = list(string)
  default     = []
  nullable    = false
}

variable "commands_after_file_changes" {
  description = "Commands to run when the files change."
  type        = bool
  default     = false
  nullable    = false
}

variable "files" {
  description = "Configuration files to upload to the server."
  type = list(object({
    destination = string
    content     = optional(string)
    source      = optional(string)
    permissions = optional(string, "0644")
    owner       = optional(string)
    group       = optional(string)
  }))
  default  = []
  nullable = false

  validation {
    condition     = alltrue([for file in var.files : file.content == null ? (file.source != null) : (file.source == null)])
    error_message = "Exactly one of file content or source must not be null."
  }
}

variable "ssh" {
  type = object({
    host        = string
    port        = number
    username    = string
    private_key = string
  })
  description = "The SSH connection details."
  nullable    = false
}
