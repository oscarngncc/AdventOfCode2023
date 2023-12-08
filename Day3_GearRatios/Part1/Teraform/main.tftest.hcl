

run "test_case_one" {
  command = plan
  variables {
    engine_schematic = <<EOT
EOT
  }
  assert {
    condition     = output.result == 0
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
    condition     = output.result == 0
    error_message = "should match"
  }
}

run "test_case_three" {
  command = plan
  variables {
    engine_schematic = <<EOT
467..114..
*....114..
EOT
  }
  assert {
    condition     = output.result == 467
    error_message = "should match"
  }
}

run "test_case_four" {
  command = plan
  variables {
    engine_schematic = <<EOT
101..102
...**...
...**...
103..104
EOT
  }
  assert {
    condition     = output.result == 410
    error_message = "diagonal should match"
  }
}

run "test_case_five" {
  command = plan
  variables {
    engine_schematic = <<EOT
...1....
..2@3...
...4....
EOT
  }
  assert {
    condition     = output.result == 10
    error_message = "next-to should match"
  }
}


run "test_case_six" {
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
    condition     = output.result == 4361
    error_message = "should match"
  }
}

run "test_case_seven" {
  command = plan
  variables {
    engine_schematic = <<EOT
...12
12*..
EOT
  }
  assert {
    condition     = output.result == 24
    error_message = "should match"
  }
}

run "test_case_eight" {
  command = plan
  variables {
    engine_schematic = <<EOT
12.......*..
+.........34
.......-12..
..78........
..*....60...
78.........9
15.....23..$
8...90*12...
............
2.2......12.
.*.........*
1.1..503+.56
EOT
  }
  assert {
    condition     = output.result == 925
    error_message = "should match"
  }
}

run "test_case_nine" {
  command = plan
  variables {
    engine_schematic = <<EOT
12.......*..
+.........34
.......-12..
..78........
..*....60...
78..........
.......23...
....90*12...
............
2.2......12.
.*.........*
1.1.......56
EOT
  }
  assert {
    condition     = output.result == 413
    error_message = "should match"
  }
}

run "test_case_ten" {
  command = plan
  variables {
    engine_schematic = <<EOT
.....11
.......
.....22
33+....
.......
44+1.44
.......
+55..55
......+
EOT
  }
  assert {
    condition     = output.result == 188
    error_message = "should match"
  }
}