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


locals {
    input    = compact(split("\n", var.input != null ? var.input : file(var.input_path)))
    matches  =  [ for index, time in regexall("[0-9]+", local.input[0]) : {
        time: time,
        distance:  regexall("[0-9]+", local.input[1])[index]
    }]

    result  = [ for match in local.matches: length([
        for ms, _ in split("",format("%0${match.time}d", 0)): ms if (match.time - ms) * ms > match.distance 
        ])
    ]
}

output "result" {
  value = join("*", local.result)
  description = "The number of ways to beat the record across all races"
}