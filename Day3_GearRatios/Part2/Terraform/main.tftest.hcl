

run "test_case_one" {
  command = plan
  variables {
    engine_schematic = <<EOT
EOT
  }
  assert {
    condition     = output.result == ""
    error_message = "should match"
  }
}

run "test_case_two" {
  command = plan
  variables {
    engine_schematic = <<EOT
467..114..
EOT
  }
  assert {
    condition     = output.result == ""
    error_message = "should be zero"
  }
}

run "test_case_three" {
  command = plan
  variables {
    engine_schematic = <<EOT
12*1..
EOT
  }
  assert {
    condition     = output.result == "12*1"
    error_message = "should match"
  }
}

run "test_case_four" {
  command = plan
  variables {
    engine_schematic = <<EOT
..55..
.4*4..
..4.2.
....*1
EOT
  }
  assert {
    condition     = output.result == "55*4*4*4+2*1"
    error_message = "should match"
  }
}

run "test_case_six" {
  command = plan
  variables {
    engine_schematic = <<EOT
..999..
.1*10..
..1....
...10*1
EOT
  }
  assert {
    condition     = output.result == "999*1*10*1+10*1"
    error_message = "should be 10000!"
  }
}

run "test_case_seven" {
  command = plan
  variables {
    engine_schematic = <<EOT
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
EOT
  }
  assert {
    condition     = output.result == "467*35+755*598"
    error_message = "should be 467835!"
  }
}
