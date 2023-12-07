

run "test_case_zero" {
  command = plan
  variables {
    game_record = <<EOT
EOT
  }
  assert {
    condition     = output.result == 0
    error_message = "should be 0 for empty"
  }
}

run "test_case_one" {
  command = plan
  variables {
    game_record = <<EOT
Game 3: 2 blue, 4 red; 1 red, 2 green, 1 blue; 2 green
EOT
  }
  assert {
    condition     = output.result == 16
    error_message = "should match"
  }
}

run "test_case_two" {
  command = plan
  variables {
    game_record = <<EOT
Game 5: 0 blue, 0 red
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
    game_record = <<EOT
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
EOT
  }
  assert {
    condition     = output.result == 2286
    error_message = "should match"
  }
}


run "test_case_four" {
  command = plan
  variables {
    game_record = <<EOT
Game 4: 1 blue, 1 red, 1 green
Game 1984: 999 red, 1 blue, 1 green; 999 red, 1 blue, 1 green 
EOT
  }
  assert {
    condition     = output.result == 1000
    error_message = "should match"
  }
}


run "test_case_five" {
  command = plan
  variables {
    game_record = <<EOT
Game 5: 1 blue, 1 red, 1 green
Game 7: 10 red, 1 blue, 1 green; 10 red, 1 blue, 1 green 
Game 27: 999 red, 1 blue, 1 green; 10 blue, 1 blue, 1 green 
EOT
  }
  assert {
    condition     = output.result == 10001
    error_message = "should match"
  }
}