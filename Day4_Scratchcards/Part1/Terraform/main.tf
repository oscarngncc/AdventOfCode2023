
variable "scratchcards" {
  description = "The plain text string of the scratchcards. If provided, will proritize this instead"
  type        = string
  default     = null
}

variable "scratchcards_path" {
  description = "The file path of the scratchcards. Note that it has lower prority than var.scratchcards"
  type        = string
  default     = "test_input.txt"
}

locals {
  card_str_per_line = compact(split("\n", var.scratchcards != null ? var.scratchcards : file(var.scratchcards_path)))
  card_per_line = [for cardstr in local.card_str_per_line : {
    cardID : tonumber(replace(replace(split(":", cardstr)[0], "Card", ""), " ", ""))
    winnum : [for numstr in split(" ", split(":", split("|", cardstr)[0])[1]) : tonumber(numstr) if numstr != ""]
    guess : [for numstr in split(" ", split("|", cardstr)[1]) : tonumber(numstr) if numstr != ""]
  }]

  result = try(sum(flatten([for card in local.card_per_line: length(setintersection(card.winnum, card.guess)) == 0 ? 0 : 1 * pow(2, length(setintersection(card.winnum, card.guess)) -1) ])), 0)
}

output "result" {
  value = local.result
  description = "Total winning points"
}