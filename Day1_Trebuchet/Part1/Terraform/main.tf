
variable "calibration_document" {
  description = "The plan text string of the document"
  type        = string
  default     = <<EOF
EOF
}

locals {
  calibrations_per_line           = split("\n", var.calibration_document)
  calibration_all_digits_per_line = [for cline in local.calibrations_per_line : length(regexall("[0-9]", cline)) > 0 ? join("", regexall("[0-9]", cline)) : ""]
  calibration_two_digits_per_line = [for dline in local.calibration_all_digits_per_line : length(regexall("^.|.$", dline)) > 0 ? join("", regexall("^.|.$", dline)) : ""]
  // weird question setup that first and last single digit can be the same to form a double-digit (e.g. a7x -> 7 -> 77)
  calibration_force_two_digits_per_line = [for digitStr in local.calibration_two_digits_per_line : length(digitStr) == 1 ? "${digitStr}${digitStr}" : "${digitStr}" ]
  calibration_values_per_line           = [for dline in local.calibration_force_two_digits_per_line : try(tonumber(dline), 0)]
  calibration_values_sum                = try(sum(local.calibration_values_per_line), 0)
}

output "result" {
  description = "sum of all the calibration values"
  value       = local.calibration_values_sum
}