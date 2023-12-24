
variable "key" { 
    type = number
}

variable "map" {
}

locals {
  matches = [ for info in var.map: var.key >= info.src && var.key < info.src + info.range ? info.dest + signum( info.src - var.key )  * (info.src - var.key) : -1 ]

  // if it's empty array, return key back
  // if it's not empty but only has -1, meaning nothing matches and return -1
  // otherwise, return the matched number
  result = length(distinct(local.matches)) == 0 || (length(distinct(local.matches)) == 1 && try(distinct(local.matches)[0] == -1, false))  ? var.key : sum(distinct(local.matches)) + (length(distinct(local.matches)) == 2 ? 1 : 0)
}

// && try(distinct(local.matches)[0] == -1, false)

output "value" {
  description = "The corresponded value"
  value = local.result
}