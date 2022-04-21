 variable "webapps" {
  description = "frontend and api layers."
  type        = list
  default     = ["frontendapp","apilayer"]

}

variable "resource_group_name" {
   description = "Name of the resource group in which the resources will be created"
   default     = "mygroup"
}

variable "location" {
   description = "Location where resources will be created"
   default = "mylocation"
}
