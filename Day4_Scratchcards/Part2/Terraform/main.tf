
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



variable "scratchcards_previous_copies" {
  description = "The result of previous copies"
  type        = list(number)
  default     = []
}


locals {
  card_str_per_line = compact(split("\n", var.scratchcards != null ? var.scratchcards : file(var.scratchcards_path)))
  card_per_line = [for cardstr in local.card_str_per_line : {
    cardID : tonumber(replace(replace(split(":", cardstr)[0], "Card", ""), " ", ""))
    winnum : [for numstr in split(" ", split(":", split("|", cardstr)[0])[1]) : tonumber(numstr) if numstr != ""]
    guess : [for numstr in split(" ", split("|", cardstr)[1]) : tonumber(numstr) if numstr != ""]
  }]


  match_per_card = [
    for index, card in local.card_per_line: length(setintersection(card.winnum, card.guess))
  ]

  reach_limit = length(var.scratchcards_previous_copies) == length(local.match_per_card)

  // Dynamic Programming Logic goes like this:
  // 1
  // 1 + idx0to1 ? 1 : 0
  // 1 + idx0to2 ? 1 : 0 + idx1to2 ? prev1 : 0
  // 1 + idx0to3 ? 1 : 0 + idx1to3 ? prev1 : 0 + idx2to3 ? prev2 : 0
  // ...
  scratchcard_copies = local.reach_limit ? var.scratchcards_previous_copies : concat( var.scratchcards_previous_copies, length(var.scratchcards_previous_copies) == 0 ? [1] : [
    1 + sum([
        for index, prev_copy in var.scratchcards_previous_copies: index + local.match_per_card[index] >= length(var.scratchcards_previous_copies) ? prev_copy : 0
    ])
  ])
}


// Dynamic Programming!
// When this file get replaced, it will also recycle previous `.auto.tfvars.json`
resource "local_file" "scratchcards_previous_copies" {
  content  = jsonencode(merge(
    try(jsondecode(file("${path.module}/${length(var.scratchcards_previous_copies)}.auto.tfvars.json")), {}),
    { scratchcards_previous_copies: local.scratchcard_copies }
  ))
  filename = "${path.module}/${ length(local.scratchcard_copies)  }.auto.tfvars.json"
}


output "rotation" {
  value = length(local.scratchcard_copies)
  description = "Current rotation"
}

output "result" {
  value = try(sum(local.scratchcard_copies), 0)
  description = "Total winning copies of scratchcards"
}