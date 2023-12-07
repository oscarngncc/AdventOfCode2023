
variable "calibration_document" {
  description = "The plan text string of the document. If provided, will proritize this instead"
  type        = string
  default     = null
}

variable "calibration_document_path" {
  description = "The file path of the document. Note that it has lower prority than var.calibration_document"
  type        = string
  default     = ""
}


locals {
  calibrations_per_line = split("\n", var.calibration_document != null ? var.calibration_document : file(var.calibration_document_path))

  // extra requirement in part 2
  // Note that eightwo is 82, not 8wo -> 88
  //
  // To handle this, we abuse a couple English facts that:
  // (1): There's at max one letter at the end of digit that matches the start of other digit, (i.e. an imaginery english digit letter 'eni' will break this assumption since the 2-letter sequence end 'ni' matches the start of 'nine' )
  // (2): There's at max one letter at the start of digit that matches the end of other digit, (i.e. an imaginery english digit letter 'hti' will break this assumption since the 2-letter sequence end 'ht' matches the start of 'eight')
  // (3): All english digit letters are at least 3 letters long
  calibration_letter_digits_per_line = [
    for cline in local.calibrations_per_line :
    replace(
      replace(
        replace(
          replace(
            replace(
              replace(
                replace(
                  replace(
                    replace(
                      replace(
                        cline, "zero", "z0o" # might as well do 0, yoooooo
                      )
                    , "nine", "n9e")
                  , "eight", "e8t")
                , "seven", "s7n")
              , "six", "s6x")
            , "five", "f5e")
          , "four", "f4r")
        , "three", "t3e")
      , "two", "t2o")
    , "one", "o1e")
  ]

  calibration_all_digits_per_line = [for cline in local.calibration_letter_digits_per_line : length(regexall("[0-9]", cline)) > 0 ? join("", regexall("[0-9]", cline)) : ""]
  calibration_two_digits_per_line = [for dline in local.calibration_all_digits_per_line : length(regexall("^.|.$", dline)) > 0 ? join("", regexall("^.|.$", dline)) : ""]
  // weird question setup that first and last single digit can be the same to form a double-digit (e.g. a7x -> 7 -> 77)
  calibration_force_two_digits_per_line = [for digitStr in local.calibration_two_digits_per_line : length(digitStr) == 1 ? "${digitStr}${digitStr}" : "${digitStr}"]
  calibration_values_per_line           = [for dline in local.calibration_force_two_digits_per_line : try(tonumber(dline), 0)]
  calibration_values_sum                = try(sum(local.calibration_values_per_line), 0)
}

output "result" {
  description = "sum of all the calibration values"
  value       = local.calibration_values_sum
}