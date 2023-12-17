
variable "engine_schematic" {
  description = "The plain text string of the engine_schematic. If provided, will proritize this instead"
  type        = string
  default     = null
}

variable "engine_schematic_path" {
  description = "The file path of the engine_schematic. Note that it has lower prority than var.engine_schematic"
  type        = string
  default     = "test_input.txt"
}

locals {
  rows        = compact(split("\n", var.engine_schematic != null ? var.engine_schematic : file(var.engine_schematic_path)))
  coordinates = [for row in local.rows : [for unit in split("", row) : unit]]
  
  numbers = flatten([
    for y, row in local.rows : distinct(flatten([
      for num in regexall("[0-9]+", row) : [
        for index, _ in regexall("\\b${num}\\b", join(" ", regexall("[0-9]+", row))) : {
          value = tonumber(num)
          y     = y
          x     = length(join("", slice(split("\\s", join("", [for elem in flatten(regexall("([0-9]+|[^0-9]+)", row)) : elem == num ? "\\s" : elem])), 0, index + 1))) + index * length("${num}")
        }
      ]
    ]))
  ])

  gears = flatten([
    for y, row in local.rows : distinct(flatten([
      for index, gear in regexall("\\*", row) : {
          y     = y
          x     = length(join("", slice(split("\\s", join("", [for elem in flatten(regexall("(\\*|[^\\*]+)", row)) : elem == "*" ? "\\s" : elem])), 0, index + 1))) + index * 1
        }
    ]))
  ])

  gearNumbers = [for gear in local.gears: [
    for num in local.numbers: 
    // some terraform-ish lazy evaluation to speed-things up here
    // https://github.com/hashicorp/terraform/issues/24128
    (num.y - 1 > gear.y || num.y + 1 < gear.y) ? 0 : (
        num.y - 1 == gear.y && num.x - 1 == gear.x || 
        num.y + 0 == gear.y && num.x - 1 == gear.x ||
        num.y + 1 == gear.y && num.x - 1 == gear.x ||
        num.y - 1 == gear.y && num.x + 0 == gear.x ||
        num.y + 0 == gear.y && num.x + 0 == gear.x ||
        num.y + 1 == gear.y && num.x + 0 == gear.x ||
        num.y - 1 == gear.y && num.x + 1 == gear.x ||
        num.y + 0 == gear.y && num.x + 1 == gear.x ||
        num.y + 1 == gear.y && num.x + 1 == gear.x ||
        //Special cases for the starting digit to not be adjacent to gear but the subsequent digits are
        num.y - 1 == gear.y && num.x + 1 < gear.x &&  num.x + (length(tostring(num.value)) -1) + 1 >= gear.x ||
        num.y + 0 == gear.y && num.x + 1 < gear.x &&  num.x + (length(tostring(num.value)) -1) + 1 >= gear.x ||
        num.y + 1 == gear.y && num.x + 1 < gear.x &&  num.x + (length(tostring(num.value)) -1) + 1 >= gear.x 
        ? num.value : 0
      )
    ]
  ]

  // Result in string equation expression. 
  // If every neighbors is considered 0 (i.e. [0,0,0,0,0...]), then return 0. (calculated through distinct > 1 )
  // If only 1 neighbor is not 0 (i.e. [100,0,0,0,0...]), then according to the requirement it's not a gear hence return 0. (Hence the second complex expression)
  // Otherwise, exclude 0 and multiply them all 
  resultExpression = join("+", [ for gearNeighbors in local.gearNumbers : join("*", [ for neighbor in gearNeighbors: neighbor if neighbor != 0 ]) if length(distinct(gearNeighbors)) > 1 && !(length(distinct(gearNeighbors)) == 2 && (gearNeighbors[0]==0 || gearNeighbors[1]==0))   ])
}

output "result" {
  description = "[NOTE] You need to run 'terraform console' to obtain the actual numerical reult. Sum of all gear ratios in the engine schematic"
  value = local.resultExpression
}