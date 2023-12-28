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
  description = "State for step calculation"
  type = object({
    current_location  = optional(string, "AAA")
    current_step      = optional(string, "")
    current_step_count = optional(number, 0)
  })
  default = {}
}


locals {
    input    = compact(split("\n", var.input != null ? var.input : file(var.input_path)))
    instruction = local.input[0]
    nodes    = { for line in setsubtract(local.input, ["${local.instruction}"]) : "${regexall("[A-Z]+", line)[0]}"  => {
        L: regexall("[A-Z]+", line)[1]
        R: regexall("[A-Z]+", line)[2]
    }}
}


module "traverse" {
  source = "./hundred_traverse"
  instruction = local.instruction
  nodes = local.nodes
  c = var.c
}


// When this file get replaced, it will also recycle previous `.auto.tfvars.json`
resource "local_file" "calculation" {
  content  = jsonencode(merge(
    try(jsondecode(file("${path.module}/*.auto.tfvars.json")), {}),
    {
        "c": module.traverse.c
    }
  ))
  filename = "${path.module}/tmp.auto.tfvars.json"
}


output "current_state" {
  value = jsondecode(local_file.calculation.content)["c"]
}

output "result" {
  value = (try(module.traverse.c.current_location, "")) == "ZZZ" ? "${module.traverse.c.current_step_count}" : "cannot obtain result yet"
  description = "The number of steps required to reach ZZZ"
}