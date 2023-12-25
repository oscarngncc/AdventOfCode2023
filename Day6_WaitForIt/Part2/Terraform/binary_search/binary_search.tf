
variable "match" { 
    description = "direct passthrough"
}
variable "left" { 
    type = number
}
variable "right" { 
    type = number
}

locals {
  middle      = var.left + floor((var.right - var.left) / 2)
  new_left   = (var.match.time - local.middle) * local.middle > var.match.distance ? var.left : local.middle
  new_right  = (var.match.time - local.middle) * local.middle > var.match.distance ? local.middle : var.right
}


output "left" {
  value = local.new_left
}

output "right" {
  value = local.new_right
}

output "result" {
  value = signum(local.new_right - local.new_left) * (local.new_right - local.new_left) == 1 ? tonumber(local.new_right) : null
}

