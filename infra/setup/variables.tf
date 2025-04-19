variable "tf-state-bucket" {
  default = "devsecopss3tfstate"
}

variable "tf-state-lock" {
  default = "Dynamodb-tf-state-lock"
}

variable "project" {
  default = "DevSecOps"
}

variable "contact" {
  default = "a.ghodbene@gmail.com"
}