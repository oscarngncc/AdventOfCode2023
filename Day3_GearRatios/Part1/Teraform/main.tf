
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
  rows = compact(split("\n", var.engine_schematic != null ? var.engine_schematic : file(var.engine_schematic_path)))
  coordinates = [for row in local.rows : [for unit in split("", row) : unit]]

  numbers = flatten([
    for y, row in local.rows : distinct(flatten([
      for num in regexall("[0-9]+", row) : [
        for index, _ in regexall("\\b${num}\\b",  join(" ",regexall("[0-9]+", row))   ) : {
          value = tonumber(num)
          y     = y
          x     = length(join( "", slice(split("\\s", join("", [for elem in flatten(regexall("([0-9]+|[^0-9]+)", row)): elem == num ? "\\s" : elem ])), 0, index + 1) )) + index * length("${num}")
        }
      ]
    ])) 
  ])

  partNumbers = [for num in local.numbers :
    # it's possible to do a regexall on this whole number level instead of digit level because
    #
    # (1): it returns true as long as any unit adjacent to any digits within the whole number is a symbol
    # (2): number is not a symbol. so for somthing like '17', '1' is not considered adjacent to a '7' symbol or vice-versa 
    length(regexall("[^0-9\\.]", join("", flatten(
      [for i, digit in split("", tostring(num.value)) : [
        try(local.coordinates[num.y - 1][num.x + i - 1], "."),
        try(local.coordinates[num.y][num.x + i - 1], "."),
        try(local.coordinates[num.y + 1][num.x + i - 1], "."),
        try(local.coordinates[num.y - 1][num.x + i], "."),
        try(local.coordinates[num.y][num.x + i], "."),
        try(local.coordinates[num.y + 1][num.x + i], "."),
        try(local.coordinates[num.y - 1][num.x + i + 1], "."),
        try(local.coordinates[num.y][num.x + i + 1], "."),
        try(local.coordinates[num.y + 1][num.x + i + 1], ".")
        ]
      ]
    ))))
    > 0 ? num.value : 0
  ]
}




output "result" {
  description = "sum of all part numbers in the engine schematic"
#  value = local.numbers
  value = try(sum( local.partNumbers ), 0)
}