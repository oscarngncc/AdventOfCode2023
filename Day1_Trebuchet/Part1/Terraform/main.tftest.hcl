




run "test_case_one" {
  command = plan
  variables {
    calibration_document = ""
  }
  assert {
    condition     = output.result == 0
    error_message = "should match with empty edge case!"
  }
}


run "test_case_two" {
  command = plan
  variables {
    calibration_document = <<EOT
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
EOT
  }
  assert {
    condition     = output.result == 142
    error_message = "should match as example!"
  }
}


run "test_case_three" {
  command = plan
  variables {
    calibration_document = <<EOT
basic1879
EOT
  }
  assert {
    condition     = output.result == 19
    error_message = "should match!"
  }
}


run "test_case_four" {
    command = plan
    variables {
        calibration_document = <<EOT
pretty0
pretty1
pretty2

pretty3
pretty4
pretty5

pretty6
pretty7
pretty8
pretty9
pretty10
EOT
    }
    assert {
        condition     = output.result == 0 + 11 + 22 + 33 + 44 + 55 + 66 + 77 + 88 + 99 + 10
        error_message = "should match!"
    }
}



run "test_case_five" {
  command = plan
  variables {
    calibration_document = <<EOT

0b2asi9c80
0dfdaga

dfhah0

EOT
  }
  assert {
    condition     = output.result == 0
    error_message = "should match!"
  }
}
