
run "test_case_example" {
  command = plan
  variables {
    input = <<EOF
Time:      7  15   30
Distance:  9  40  200
EOF
  }
  assert {
    condition     = output.result == "4*8*9"
    error_message = "should match"
  }
}


run "test_case_zero" {
  command = plan
  variables {
    input = <<EOF
Time:      1  1   1
Distance:  20  20  20
EOF
  }
  assert {
    condition     = output.result == "0*0*0"
    error_message = "should match"
  }
}

run "test_case_one" {
  command = plan
  variables {
    input = <<EOF
Time:      2  3  4
Distance:  1  4  9
EOF
  }
  assert {
    condition     = output.result == "0*0*0"
    error_message = "Should match! The best you can do is to go even with record but not beat it"
  }
}