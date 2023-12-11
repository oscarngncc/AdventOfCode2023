
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


  // The logic here is simply to record all { value = number, x = x-coordinate, y = y-coordinate} in a single declarative variable (because TF)
  // The first for-loop iterate through rows
  // The second for loop iterate through all numbers in row
  // The third loop is to handle the edge case when same number appears in a row: i.e. "4..5..14..4.." returns _ = [4,4] and index from 0 to 1 due to '4' integer appearing twice (NOT thrice, '14' is not integer '4')
  //
  // Using the example above, x-coordinate of multiple '4' integer is computed as follows
  // 1. "4..5..14..4.." is interpretted as ["4", "..", "5", "..", "14", "..", "4" ".."] here
  // 2. ["4", "..", "5", "..", "14", "..", "4" ".."] is transformed into ["\s", "..", "5", "..", "14", "..", "\s" ".."]. '\s' is not a symbol nor number which is why it's used
  // 3. ["\s", "..", "5", "..", "14", "..", "\s" ".."] is concated into "\s..5..14..\s.."
  // 4. "\s..5..14..\s.." is split into ["", "..5..14..", ".."] based on '\s'
  // 5. Since '\s' is originally '4' integer, we can conclude everything before the first split belongs to first '4', second split belongs to second '4' etc. So "" belongs to first 4, "" + "..5..14.." belongs to second '4'
  // 6. The actual prefix string for second '4' is actually  "4..5..14..". We don't care about the actual prefix string just the x-coordinate, so it can be deteremined as length("4..5..14..") + length('4') * number of '4' appearing previously
  //
  // Finally, this logic actually populate '4' twice. i.e. "4..4.." -> [{v:4,x:0,y:0}, {v:4,x:3,y:0}, {v:4,x:0,y:0}, {v:4,x:3,y:0}], so we need a distinct applied to the list of objects  
  
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
  value = try(sum(local.partNumbers), 0)
}