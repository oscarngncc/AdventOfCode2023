
variable "instruction" {}
variable "nodes" {}
variable "c" {}


locals {
    current_step = var.c.current_step == "" ? var.instruction : var.c.current_step
    updated_state = (try(var.c.current_location, "") == "ZZZ" ? var.c : 
    {
      current_location = var.nodes[var.c.current_location][substr(local.current_step, 0, 1)],
      current_step = substr(local.current_step, 1, length(local.current_step))
      current_step_count = var.c.current_step_count + 1
    })
}

output "c" { value = local.updated_state }