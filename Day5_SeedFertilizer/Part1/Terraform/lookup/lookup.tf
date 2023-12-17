
variable "key" { 
    type = number
    default = 14
}

variable "map" {
    default =  [
      {
        dest  = 0
        range = 37
        src   = 15
      },
      {
        dest  = 37
        range = 2
        src   = 52
      },
      {
        dest  = 39
        range = 15
        src   = 0
      }
    ]
}

locals {
  matches = [ for info in var.map: var.key >= info.src && var.key < info.src + info.range ? info.dest + signum( info.src - var.key )  * (info.src - var.key) : -1 ]

  // if it's empty array, return key back
  // if it's not empty but only has -1, meaning nothing matches and return -1
  // otherwise, return the matched number
  result = length(distinct(local.matches)) == 0 || (length(distinct(local.matches)) == 1 && try(distinct(local.matches)[0] == -1, false))  ? var.key : sum(local.matches) + (length(distinct(local.matches)) -1)
}

// && try(distinct(local.matches)[0] == -1, false)

output "value" {
  description = "The corresponded value"
  value = local.result
}