variable "input" {
  description = "The plain text string of the input. If provided, will proritize this instead"
  type        = string
  default     = null
}

variable "input_path" {
  description = "The file path of the input_path. Note that it has lower prority than var.input_path"
  type        = string
  default     = "test_input.txt"
}

variable "c" {
  description = "State for temporary calculation"
  type = object({
    lower_bound      = optional(number, null)
    upper_bound      = optional(number, null)
    lower_iteration  = optional(number, 1)
    upper_iteration  = optional(number, 1)
  })
  default = {}
}

variable "b" {
  description = "State for binary search calculation"
  type = object({
    lower_left  = optional(number, null)
    lower_right = optional(number, null)
    upper_left  = optional(number, null)
    upper_right = optional(number, null)
  })
  default = null
}




locals {
    input  = compact(split("\n", var.input != null ? var.input : file(var.input_path)))
    match  = {
        time: tonumber(join("",regexall("[0-9]+", local.input[0]))),
        distance: tonumber(join("",regexall("[0-9]+", local.input[1])))
    }

    lower_bound = var.c.lower_bound == null ? 0: var.c.lower_bound
    upper_bound = var.c.upper_bound == null ? local.match.time : var.c.upper_bound
    new_lower_bound  = (local.match.time - local.lower_bound) * local.lower_bound > local.match.distance ? local.lower_bound - var.c.lower_iteration : local.lower_bound + var.c.lower_iteration
    new_upper_bound  = (local.match.time - local.upper_bound) * local.upper_bound > local.match.distance ? local.upper_bound + var.c.upper_iteration : local.upper_bound - var.c.upper_iteration

    // These values stop changing until reaching to a certain point
    new_c = {
        lower_bound       = local.new_lower_bound < 0 ? local.lower_bound : local.new_lower_bound
        upper_bound       = local.new_upper_bound > local.match.time ? local.upper_bound : local.new_upper_bound
        lower_iteration   = local.new_lower_bound > local.lower_bound ?  var.c.lower_iteration * 2 : var.c.lower_iteration
        upper_iteration   = local.new_upper_bound < local.upper_bound ?  var.c.upper_iteration * 2 : var.c.upper_iteration
    }
    stop = local.new_c.lower_bound == local.lower_bound  && local.new_c.upper_bound == local.upper_bound
}

locals {
  // Once the values stop, we do a binary search here
  b_default = local.stop ? {
    lower_left  = floor((local.lower_bound - var.c.lower_iteration / 2))
    lower_right = local.lower_bound
    upper_left  = floor((local.upper_bound + var.c.upper_iteration/  2))
    upper_right = local.upper_bound
  } : null
  b = var.b != null ? var.b : local.b_default
}


module "binary_search_lower" {
  count  = local.stop ? 1 : 0
  source = "./binary_search"
  match  = local.match
  left   = local.b.lower_left
  right  = local.b.lower_right
}

module "binary_search_upper" {
  count  = local.stop ? 1 : 0
  source = "./binary_search"
  match  = local.match
  left   = local.b.upper_left
  right  = local.b.upper_right
}


locals {
  new_b  = local.stop ? {
    lower_left  = module.binary_search_lower[0].left
    lower_right = module.binary_search_lower[0].right
    upper_left  = module.binary_search_upper[0].left
    upper_right = module.binary_search_upper[0].right
  } : null
}


// When this file get replaced, it will also recycle previous `.auto.tfvars.json`
resource "local_file" "calculation" {
  content  = jsonencode(merge(
    try(jsondecode(file("${path.module}/*.auto.tfvars.json")), {}),
    {
      "c": local.new_c
      "b": local.new_b
    }
  ))
  filename = "${path.module}/tmp.auto.tfvars.json"
}


output "current_state" {
  value = jsondecode(local_file.calculation.content)
}


output "result" {
  value = try( module.binary_search_upper[0].result - module.binary_search_lower[0].result + 1, "not ready yet")
  description = "The number of ways to beat the record in the race"
}

