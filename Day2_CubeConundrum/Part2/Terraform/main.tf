
variable "game_record" {
  description = "The plan text string of the game record. If provided, will proritize this instead"
  type        = string
  default     = null
}

variable "game_record_path" {
  description = "The file path of the game record. Note that it has lower prority than var.game_record"
  type        = string
  default     = ""
}


locals {
  games_str_per_line = compact(split("\n", var.game_record != null ? var.game_record : file(var.game_record_path)))

  games_per_line = [for gamestr in local.games_str_per_line : {
    // assuming each subset color is an identifier (i.e. nothing like 1 red 1 red 1 blue;)
    // so we don't even need to iterate like: for subset in gamestr.split(":")
    red_minimum : length(regexall("[0-9]*red", replace(gamestr, " ", ""))) > 0 ? max([for numColor in regexall("[0-9]*red", replace(gamestr, " ", "")) : tonumber(replace(numColor, "red", ""))]...) : 0
    green_minimum: length(regexall("[0-9]*green", replace(gamestr, " ", ""))) > 0 ? max([for numColor in regexall("[0-9]*green", replace(gamestr, " ", "")) : tonumber(replace(numColor, "green", ""))]...) : 0
    blue_minimum : length(regexall("[0-9]*blue", replace(gamestr, " ", ""))) > 0 ? max([for numColor in regexall("[0-9]*blue", replace(gamestr, " ", "")) : tonumber(replace(numColor, "blue", ""))]...) : 0
  }]

  total_score = try(sum([for game in local.games_per_line : game.red_minimum * game.green_minimum * game.blue_minimum ]), 0)
}

output "result" {
  description = "sum of power of minimial ball per subset"
  value       = local.total_score
}